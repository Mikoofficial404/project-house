import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/mobile/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fromKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;

  void toggleObsecure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  Future<void> login() async {
    if (fromKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (emailController.text.trim().toLowerCase() == 'admin@admin.com') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          // Navigate to regular user home page
          Navigator.pushReplacementNamed(
            // ignore: use_build_context_synchronously
            context,
            '/home',
          );
        }
      } on FirebaseAuthException catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Login Failed'),
                content: Text(e.message ?? 'Unknown error occurred'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Form(
        key: fromKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text(
                  'Sign in &\nSearch Your House',
                  style: blackTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/signin.jpg'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                label: Text(
                  'Enter Your Email',
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
                suffixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email Tidak Boleh Kosong';
                }
                if (!value.contains('@') || value.contains(',')) {
                  return 'Email Tidak Valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: isObscure,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                label: Text(
                  'Password',
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: toggleObsecure,
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password Tidak Boleh Kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  'Login',
                  style: whiteTextSF.copyWith(
                    fontSize: 16,
                    fontWeight: extraBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/signup',
                    ); // Navigasi ke halaman signup
                  },
                  child: Text(
                    'Sign Up',
                    style: blueTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            GFButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                      await authService.value.signInWithGoogle();
                  print(
                    "Signed in with Google: ${userCredential.user?.displayName}",
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  print("Error signing in with Google: $e");
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Google Sign-In Failed'),
                          content: Text(
                            'Something went wrong during Google sign-in. Please try again later.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                }
              },
              text: "Login with Google",
              icon: FaIcon(FontAwesomeIcons.googlePlusG, color: Colors.white),
              color: Colors.red,
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
              fullWidthButton: false,
            ),
          ],
        ),
      ),
    );
  }
}
