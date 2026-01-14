import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vetconnect/services/firebase_helper.dart';
import 'package:vetconnect/route_page.dart';
import 'package:vetconnect/constants.dart';
import 'package:vetconnect/registration/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> loginHandler(String email, String password) async {
    if (email.length != 0 &&
        email.contains("@") &&
        email.contains(".") &&
        password.length >= 6) {
      // try logging user in
      FirebaseHelper? firebaseHelper = await FirebaseHelper.login(
        email,
        password,
      );

      if (firebaseHelper != null) {
        // instantiate firebase helper
        Constants.firebaseHelper = firebaseHelper;

        // push to the route page
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => RoutePage()));
      } else {
        Constants.showPopup(
          context,
          "Incorrect Credentials",
          "The email or password you inputted is incorrect. Please carefully try again.",
        );
      }
    } else {
      Constants.showPopup(
        context,
        "Incorrect Information",
        "Please enter a valid email and a password longer than six characters.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                SizedBox(height: 30),
                CupertinoButton.filled(
                  onPressed: () {
                    loginHandler(emailController.text, passwordController.text);
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterPage()),
                    );
                  },
                  child: Text(
                    'Don\'t have an account? Register',
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
