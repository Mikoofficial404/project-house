import 'package:flutter/material.dart';
import 'package:project_house/mobile/auth_services.dart';
import 'package:project_house/shared/theme.dart';
import 'package:project_house/ui/pages/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final fromKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = true;

  void toggleObsecure() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  void handleSignup() async {
    if (fromKey.currentState!.validate()) {
      try {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        await authService.value.createAccount(email: email, password: password);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ),
            );
          },
        ),
      ),

      backgroundColor: Colors.white,
      body: Form(
        key: fromKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text(
                  'Sign Up &\nActive your Account',
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
              child: Image.asset('assets/images/signup.jpg'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                label: Text(
                  'Email',
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
                  onTap: () {
                    toggleObsecure();
                  },
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
              onPressed: handleSignup,
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text(
                  'Sign Up',
                  style: whiteTextSF.copyWith(
                    fontSize: 16,
                    fontWeight: extraBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
