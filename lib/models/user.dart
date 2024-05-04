import 'review.dart';
import 'course.dart';

class CustomUser {
  String uid;
  String email;
  List<Course> wishlist; // List of course names
  List<Review> reviews;

  CustomUser({
    required this.uid,
    required this.email,
    this.wishlist = const [],
    this.reviews = const [],
  });

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    if (map['uid'] == null || map['email'] == null) {
      throw Exception("UID or Email is missing");
    }
    return CustomUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      // Correctly parse the wishlist field
      wishlist: (map['wishlist'] as List<dynamic>? ?? [])
          .map((item) => Course.fromMap(item as Map<String, dynamic>))
          .toList(),
      // Correctly parse the reviews field
      reviews: (map['reviews'] as List<dynamic>? ?? [])
          .map((reviewMap) => Review.fromMap(reviewMap as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'wishlist': wishlist,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }
}
