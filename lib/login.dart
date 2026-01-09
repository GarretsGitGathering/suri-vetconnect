import 'package:flutter/material.dart';
import 'package:flutterproject/firebase_helper.dart';
import 'package:flutterproject/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void showPopup(String title, String content) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Text(content, style: TextStyle(fontSize: 14)) 
        );
      }
    );
  }

  Future<void> loginHandler(String email, String password) async {
    if (email.length != 0 && email.contains("@") && email.contains(".") &&
        password.length >= 6) {
      // try logging user in
      bool status = await FirebaseHelper.login(email, password);

      if (status) {
        // push to the homepage 
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        showPopup(
          "Incorrect Credentials",
          "The email or password you inputted is incorrect. Please carefully try again."
        );
      }
    } else {
      showPopup(
        "Incorrect Information",
        "Please enter a valid email and a password longer than six characters."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                onChanged: (String newEntry) {
                  print("Username was changed to $newEntry");
                },
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),

              SizedBox(height: 30),
              FloatingActionButton(
                onPressed: loginHandler(email, password) 
              )
            ],
          ),
        ),
      )
    );
  }
}
