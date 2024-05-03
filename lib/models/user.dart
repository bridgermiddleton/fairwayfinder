import 'review.dart';

class CustomUser {
  String uid;
  String email;
  List<String> wishlist; // List of course names
  List<Review> reviews;

  CustomUser({
    required this.uid,
    required this.email,
    List<String>? wishlist,
    List<Review>? reviews,
  })  : this.wishlist = wishlist ?? [], // Initialize with an empty list if null
        this.reviews = reviews ?? []; // Initialize with an empty list if null

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    if (map['uid'] == null || map['email'] == null) {
      throw Exception("Critical user information missing or null.");
    }
    return CustomUser(
      uid: map['uid'],
      email: map['email'],
      wishlist: List<String>.from(map['wishlist'] ?? []),
      reviews: (map['reviews'] as List<dynamic> ?? [])
          .map((reviewMap) => Review.fromMap(reviewMap))
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
