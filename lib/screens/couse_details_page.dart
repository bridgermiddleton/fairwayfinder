import 'package:flutter/material.dart';
import '../models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common_widgets.dart';
import '../models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class CourseDetailsPage extends StatefulWidget {
  final String name;
  final String city;
  final String state;

  CourseDetailsPage(
      {Key? key, required this.name, required this.city, required this.state})
      : super(key: key);

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late Course course;
  bool isLoading = true;
  bool isWishlisted = false; // State to manage wishlist status
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrCreateCourse();
    _checkWishlistStatus();
  }

  void _loadOrCreateCourse() async {
    var doc = await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.name)
        .get();
    if (doc.exists) {
      course = Course.fromMap(doc.data()!);
    } else {
      course = Course(
          name: widget.name,
          city: widget.city,
          state: widget.state,
          reviews: []);
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.name)
          .set(course.toMap());
    }
    setState(() => isLoading = false);
  }

  Future<void> _checkWishlistStatus() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      // Use the custom user model to parse data
      CustomUser currentUser =
          CustomUser.fromMap(userDoc.data()! as Map<String, dynamic>);
      setState(() {
        isWishlisted = currentUser.wishlist.contains(widget.name);
      });
    }
  }

  void _toggleWishlist() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userEmail);

    // Check if the document exists before updating
    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      // Document does not exist, create it with default values
      await userRef.set({
        'email': userEmail, // Set the email or other initial fields as needed
        'wishlist': [],
        'reviews': [],
      });
    }

    // Now safely update the document
    if (isWishlisted) {
      userRef.update({
        'wishlist': FieldValue.arrayRemove([widget.name])
      });
    } else {
      userRef.update({
        'wishlist': FieldValue.arrayUnion([widget.name])
      });
    }

    setState(() {
      isWishlisted = !isWishlisted;
    });
  }

  void _submitReview() async {
    final String userEmail = FirebaseAuth.instance.currentUser!.email!;
    final Review newReview = Review(
      createdByUserEmail: userEmail,
      text: _reviewController.text,
      courseName: widget.name,
    );

    // Update the Firestore course document with the new review
    FirebaseFirestore.instance.collection('courses').doc(widget.name).update({
      'reviews': FieldValue.arrayUnion([newReview.toMap()])
    });

    // Optionally update user's own document with this new review
    FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'reviews': FieldValue.arrayUnion([newReview.toMap()])
    });

    setState(() {
      course.reviews.add(newReview);
      isWishlisted = !isWishlisted;
      _reviewController.clear(); // Clear the text field after submitting
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CommonWidgets.buildAppBar(context),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CommonWidgets.buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(course.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ),
                IconButton(
                  icon: Icon(isWishlisted ? Icons.star : Icons.star_border,
                      color: Colors.yellow[800]),
                  onPressed: _toggleWishlist,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('City: ${course.city}',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(height: 5),
            Text('State: ${course.state}',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(height: 20),
            Text('Reviews:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 10),
            course.reviews.isEmpty
                ? Text('No reviews yet',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent))
                : ListView(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scroll within the ListView
                    children: course.reviews
                        .map((review) => Card(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review.text,
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(height: 5),
                                    Text(
                                        'Review by: ${review.createdByUserEmail}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Write a Review:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                        hintText: "Your review", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: _submitReview,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF006747)),
                      child: Text(
                        "Submit Review",
                        style: TextStyle(color: Color(0xFFFFDF00)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
