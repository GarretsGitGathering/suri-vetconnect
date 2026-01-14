import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:string_similarity/string_similarity.dart';

class _FirebaseUser {
  final String _userId;
  final String? _email;
  String? _userName;
  LatLng? _location;

  _FirebaseUser(this._userId, this._userName, this._email);

  String get userId => _userId;
  String? get userName => _userName;
  String? get email => _email;
  LatLng? get location => _location;

  set userName(String userName) {
    _userName = userName;
  }

  set location(LatLng location) {
    _location = location;
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
    Map<String, dynamic>? userData = await _getData("users", userId);

    if (userData == null) {
      return null;
    }

    return userData["business"] as Map<String, dynamic>?;
  }

  Future<List<Map<String, dynamic>?>> searchForBusiness(String queryString) async {
    List<QueryDocumentSnapshot<Object?>> collectionSnapshot = await _getCollection("users") ?? [];
   
    collectionSnapshot.sort((a, b) => a["business"]["name"].similarityTo(b["business"]["name"]));

    List<Map<String, dynamic>> users = collectionSnapshot.sublist(0, 9) as List<Map<String, dynamic>>;

    List<Map<String, dynamic>> userBusinesses = users.map((map) {
      return map["business"];
    }).toList() as List<Map<String, dynamic>>;

    return userBusinesses;
  }

  Future<List<QueryDocumentSnapshot<Object?>>?> _getCollection(String collection) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collection).get();
      return snapshot.docs.toList();
    } catch (e) {
      print("Unable to get collection: $e");
      return null;
    }
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
