import 'package:flutter/material.dart';
import '../screens/profile_page_screen.dart';
import '../screens/home_page.dart';

class CommonWidgets {
  static AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF006747),
      title: Text('FairwayFinder', style: TextStyle(color: Color(0xFFFFDF00))),
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
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
        },
      ),
    );
  }
}
