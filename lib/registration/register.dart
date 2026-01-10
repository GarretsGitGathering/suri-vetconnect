import 'package:flutter/material.dart';
import 'package:vetconnect/constants.dart';
import 'package:vetconnect/home_page.dart';
import 'package:vetconnect/firebase_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  Future<void> registerHandler(String email, String password, String confirmPassword) async {
    if (email.length == 0 || !email.contains("@") || !email.contains(".")) {
      Constants.showPopup(
        context, 
        "Invalid Email", 
        "The email address you have entered is not valid. Please enter a valid email."
      );
      return;
    }

    if (password.length < 6 || password != confirmPassword) {
      Constants.showPopup(
        context, 
        "Invalid Passwords", 
        "The password(s) you have entered are invalid. Please ensure both passwords are greater that 6 characters and match."
      );
    }

    FirebaseHelper? firebaseHelper = await FirebaseHelper.register(email, password);

    if (firebaseHelper != null) {
      // update global firebase helper and push to HomePage
      Constants.firebaseHelper = firebaseHelper;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      Constants.showPopup(
        context,
        "Unable to Register",
        "We were unable to create your account at this time. Please try again soon."
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
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),

              SizedBox(height: 30),
              FloatingActionButton(
                onPressed: () {
                  registerHandler(emailController.text, passwordController.text, confirmPasswordController.text); 
                }
              )
            ],
          ),
        ),
      )

    );
  }
}


