import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vetconnect/constants.dart';
import 'package:vetconnect/route_page.dart';
import 'package:vetconnect/services/firebase_helper.dart';
import 'package:vetconnect/registration/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> registerHandler(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.length == 0 || !email.contains("@") || !email.contains(".")) {
      Constants.showPopup(
        context,
        "Invalid Email",
        "The email address you have entered is not valid. Please enter a valid email.",
      );
      return;
    }

    if (password.length < 6 || password != confirmPassword) {
      Constants.showPopup(
        context,
        "Invalid Passwords",
        "The password(s) you have entered are invalid. Please ensure both passwords are greater that 6 characters and match.",
      );
    }

    FirebaseHelper? firebaseHelper = await FirebaseHelper.register(
      email,
      password,
    );

    if (firebaseHelper != null) {
      // update global firebase helper and push to RoutePage
      Constants.firebaseHelper = firebaseHelper;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => RoutePage()));
    } else {
      Constants.showPopup(
        context,
        "Unable to Register",
        "We were unable to create your account at this time. Please try again soon.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffa3a3), Color(0xffffffff), Color(0xff95a3fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to VetConnect',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                CupertinoTextField(
                  controller: emailController,
                  placeholder: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 16),
                CupertinoTextField(
                  controller: passwordController,
                  placeholder: 'Password',
                  obscureText: true,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 16),
                CupertinoTextField(
                  controller: confirmPasswordController,
                  placeholder: 'Confirm Password',
                  obscureText: true,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: () {
                    registerHandler(
                      emailController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                    );
                  },
                  child: Text('Register'),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
