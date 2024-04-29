import 'package:flutter/material.dart';
import 'course_details_screen.dart';

class ProfilePage extends StatelessWidget {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.golf_course, color: Color(0xFFFFDF00)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => CourseDetailsPage()));
          },
        ),
      ),
      body: Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
