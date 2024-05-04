import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../models/user.dart";

class AuthenticationService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<CustomUser?> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return getCurrentUser();
    } catch (e) {
      print("Login Failed: ${e.toString()}");
      return null;
    }
  }

  static Future<CustomUser?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid, // Include this line to explicitly store the uid
          'email': email,
          'wishlist': [],
          'reviews': []
        });
        return getCurrentUser(); // Fetches the newly created user
      }

      return null;
    } catch (e) {
      print("Sign Up Failed: ${e.toString()}");
      return null;
    }
  }

  static Future<CustomUser?> getCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          print("Fetched user data: $userData");
          return CustomUser.fromMap(userData);
        } else {
          print("User data is null for UID: ${firebaseUser.uid}");
        }
      } else {
        print("No document found for UID: ${firebaseUser.uid}");
      }
    } else {
      print("Firebase user is null");
    }
    return null;
  }
}
