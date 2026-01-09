import 'package:flutter/material.dart';

void showPopup(BuildContext context, String title, String content) {
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
