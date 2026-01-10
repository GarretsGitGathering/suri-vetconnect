import 'package:flutter/material.dart';
import 'package:vetconnect/business/business_handler.dart';
import 'package:vetconnect/firebase_helper.dart';
import 'package:uuid/uuid.dart';

class Constants {
  static late FirebaseHelper firebaseHelper;
  static late BusinessHandler businessHandler;
  static Uuid uuid = Uuid();

  static void showPopup(BuildContext context, String title, String content) {
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
}

