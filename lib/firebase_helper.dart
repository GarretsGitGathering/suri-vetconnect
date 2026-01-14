// class which holds all firebase operation methods
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// private classes are only accessible inside the file 
class _FirebaseUser {
  String _uid;
  String _email;
  String _userName;
  String _location;

  _FirebaseUser(this._uid, this._email, this._userName, this._location);

  get uid => _uid;
  get email => _email;
  get userName => _userName;
  get location => _location;

  set userName(String userName) {
    _userName = userName;
  }

  set location(String location) {
    _location = location;
  }
}

class FirebaseHelper{
  _FirebaseUser _user;

  FirebaseHelper._(this._user);

  //get data from firestore
  Future<Map<String, dynamic>?> _getData(String collection, String documentId) async{
    try{
      //create snapshot of a document - a momentary capture of all data in the document
      DocumentSnapshot doc =  await  FirebaseFirestore.instance.collection(collection).doc(documentId).get();
      //ensure that the document exists
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

  //place data into firestore
  static Future<bool> _placeData(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(documentId).set(data, SetOptions(merge: true));
      return true;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  
  Future<void> updateBusiness() async {

  }

  //function for registering new users
  static Future<FirebaseHelper?> register(String email, String password) async{
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        
        return FirebaseHelper._(
          _FirebaseUser(
            userCredential.user!.uid,
            userCredential.user!.email!,
            userCredential.user!.displayName!,
            "Blvd"
          )
        );
      } catch (error) {
        print("Error: $error");
        return null;
      }
  }

  static Future<bool> login(String email, String password) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String? userId = userCredential.user!.uid;
    } catch (error) {
      print("Error: $error");
      return false;
    }
    return true;
  }
}
