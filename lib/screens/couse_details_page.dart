import 'package:flutter/material.dart';
import '../models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    _loadOrCreateCourse();
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
      FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.name)
          .set(course.toMap());
    }
    setState(() => isLoading = false);
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
        // Allows the content to be scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.name,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
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
                : Column(
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
                                        'Review by User ID: ${review.createdByUserId}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
