import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _FirebaseUser {
  final String _userId;
  final String? _email;
  String? _userName;

  _FirebaseUser(this._userId, this._userName, this._email);

  String get userId => _userId;
  String? get userName => _userName;
  String? get email => _email;

  set userName(String userName) {
    _userName = userName;
  }
}

class FirebaseHelper {

  final _FirebaseUser _firebaseUser;

  String get userId => _firebaseUser.userId; 
  String? get userName => _firebaseUser.userName;
  String? get email => _firebaseUser.email;


  FirebaseHelper._(this._firebaseUser);


  Future<bool> saveBusiness(List<String?> businessData) async {
    if (userId != FirebaseAuth.instance.currentUser?.uid) {
      print("UserId does not match currently logged in user.");
      return false;
    }
    return await _placeData("users", userId, {"business" : businessData});
  }

  Future<Map<String, dynamic>?> getBusiness(String userId) async {
    return await _getData("users", userId);
  }

  Future<Map<String, dynamic>?> _getData(String collection, String documentId) async {
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

  Future<bool> _placeData(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(documentId).set(data, SetOptions(merge: true));
      return true;
    } catch (error) {
      print("Error: $error");
      return false;
    }
  }

  static Future<FirebaseHelper?> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return FirebaseHelper._(
        _FirebaseUser(
          userCredential.user!.uid,
          userCredential.user!.displayName,
          userCredential.user!.email
        )
      ); 
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  static Future<FirebaseHelper?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return FirebaseHelper._(
        _FirebaseUser(
          userCredential.user!.uid,
          userCredential.user!.displayName,
          userCredential.user!.email
        )
      );
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }


  // TODO: save and get images from firebase storage
}
