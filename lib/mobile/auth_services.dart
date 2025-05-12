import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

ValueNotifier<AuthServices> authService = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currenctUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // Save user data to Firestore
    await saveUserToFirestore(userCredential.user!);

    return userCredential;
  }

  // Add a method to save user data to Firestore
  Future<void> saveUserToFirestore(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'uid': user.uid,
      'emailVerified': user.emailVerified,
      'displayName': user.displayName,
      'isAdmin': false, // default to regular user
      'createdAt': DateTime.now(),
    });
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> restPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currenctUser!.updateDisplayName(username);

    // Update username in Firestore as well
    if (currenctUser != null) {
      await _firestore.collection('users').doc(currenctUser!.uid).update({
        'displayName': username,
      });
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currenctUser!.reauthenticateWithCredential(credential);

    // Delete user data from Firestore first
    if (currenctUser != null) {
      await _firestore.collection('users').doc(currenctUser!.uid).delete();
    }

    await currenctUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currenctUser!.reauthenticateWithCredential(credential);
    await currenctUser!.updatePassword(newPassword);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception("Google sign-in aborted.");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await firebaseAuth.signInWithCredential(
      credential,
    );

    // Also save Google sign-in users to Firestore
    await saveUserToFirestore(userCredential.user!);

    return userCredential;
  }
}
