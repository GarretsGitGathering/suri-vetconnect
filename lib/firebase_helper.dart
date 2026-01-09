import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class which holds all firebase operation methods
class FirebaseHelper {
   // get data from firestore 
   static Future<Map<String, dynamic>?> getData(String collection, String documentId) async {
      try {
        // create snapshot of document - a momentary capture of all data in the document 
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection(collection).doc(documentId).get();

        // ensure that the document exists 
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        } else {
          return null;
        }
      } catch (error) {
        print("Error: $error");
        return null;
      }
   }

  // place data into firestore 
  static Future<bool> placeData(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(documentId).set(data, SetOptions(merge: true));
      return true;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  // function for registering new users 
  static Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String? userId = userCredential.user!.uid; 
      // TODO: Set userId globally
      return true;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  // log user in 
  static Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      String? userId = userCredential.user!.uid;
      return true;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }
}
