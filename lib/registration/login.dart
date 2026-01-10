import 'package:flutter/material.dart';
import 'package:vetconnect/firebase_helper.dart';
import 'package:vetconnect/home_page.dart';
import 'package:vetconnect/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> loginHandler(String email, String password) async {
    if (email.length != 0 && email.contains("@") && email.contains(".") &&
        password.length >= 6) {
      // try logging user in
      FirebaseHelper? firebaseHelper = await FirebaseHelper.login(email, password);

      if (firebaseHelper != null) {
        // instantiate firebase helper 
        Constants.firebaseHelper = firebaseHelper;

        // push to the homepage 
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        Constants.showPopup(
          context,
          "Incorrect Credentials",
          "The email or password you inputted is incorrect. Please carefully try again."
        );
      }
    } else {
      Constants.showPopup(
        context,
        "Incorrect Information",
        "Please enter a valid email and a password longer than six characters."
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
            colors: [
                Color(0xffa3a3),
                Color(0xffffffff),
                Color(0xff95a3fc)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Padding(
        padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),

              SizedBox(height: 30),
              FloatingActionButton(
                onPressed: () {
                  loginHandler(emailController.text, passwordController.text); 
                }
              )
            ],
          ),
        ),
      )
    );
  }
}
