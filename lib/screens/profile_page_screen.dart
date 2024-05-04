import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';
import '../widgets/common_widgets.dart';
import './couse_details_page.dart';
import '../models/course.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  final ImagePicker _picker = ImagePicker();

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
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userData = data;
          userData!['wishlist'] ??= [];
          userData!['reviews'] ??= [];
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        await FirebaseStorage.instance
            .ref('profile_pictures/${user!.uid}.jpg')
            .putFile(imageFile);
        fetchUserData(); // Refresh profile image URL
      } catch (e) {
        print('Error uploading profile picture: $e');
      }
    }
  }

  Future<String?> getProfilePictureUrl() async {
    try {
      return await FirebaseStorage.instance
          .ref('profile_pictures/${user!.uid}.jpg')
          .getDownloadURL();
    } catch (e) {
      print("Error fetching profile picture: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar(context),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: FutureBuilder<String?>(
                      future: getProfilePictureUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return GestureDetector(
                          onTap: uploadImage,
                          child: CircleAvatar(
                            backgroundImage: snapshot.data != null
                                ? NetworkImage(snapshot.data!)
                                : AssetImage('assets/images/default_user.png')
                                    as ImageProvider,
                            radius: 60,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Email: ${user!.email}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Wishlist',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  userData!['wishlist'].isEmpty
                      ? Text("No wishlist items",
                          style: TextStyle(fontStyle: FontStyle.italic))
                      : Column(
                          children: userData!['wishlist'].map<Widget>((item) {
                            Course course = Course.fromMap(item);
                            return ListTile(
                              title: Text(
                                course.name,
                                style: TextStyle(color: Colors.blue),
                              ),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CourseDetailsPage(
                                          name: course.name,
                                          city: course.city,
                                          state: course.state))),
                            );
                          }).toList(),
                        ),
                  Divider(thickness: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('My Reviews',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  userData!['reviews'].isEmpty
                      ? Text("No reviews posted yet",
                          style: TextStyle(fontStyle: FontStyle.italic))
                      : Column(
                          children: userData!['reviews'].map<Widget>((review) {
                            return ListTile(
                              title: Text(review['text']),
                              subtitle: Text('Course: ${review['courseName']}'),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}
