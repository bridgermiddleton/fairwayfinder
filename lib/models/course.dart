import 'review.dart';

class Course {
  String name;
  String city;
  String state;
  List<Review> reviews;

  Course({
    required this.name,
    required this.city,
    required this.state,
    required this.reviews,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'state': state,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'],
      city: map['city'],
      state: map['state'],
      reviews: (map['reviews'] as List<dynamic>? ?? [])
          .map((reviewMap) => Review.fromMap(reviewMap as Map<String, dynamic>))
          .toList(),
    );
  }
}
