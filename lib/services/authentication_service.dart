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
        // Initialize the user with empty wishlist and reviews
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'name': '', // Optionally initialize name as empty
          'wishlist': [],
          'reviews': []
        });
        return getCurrentUser();
      } else {
        print("Failed to create user account");
      }
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  static Future<CustomUser?> getCurrentUser() async {
    User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userDoc.exists) {
        return CustomUser.fromMap(userDoc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }
}
