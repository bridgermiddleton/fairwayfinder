import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006747),
        title:
            Text('FairwayFinder', style: TextStyle(color: Color(0xFFFFDF00))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle, color: Color(0xFFFFDF00)),
            onPressed: () {
              // This button is already on the profile page, typically this would be redundant.
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.golf_course, color: Color(0xFFFFDF00)),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
          },
        ),
      ),
      body: Center(
        child: userData == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Email: ${userData!['email']}',
                      style: TextStyle(fontSize: 20)),
                  Text('Name: ${userData!['name'] ?? "Not Set"}',
                      style: TextStyle(fontSize: 20)),
                  // Add more fields as necessary
                ],
              ),
      ),
    );
  }
}
