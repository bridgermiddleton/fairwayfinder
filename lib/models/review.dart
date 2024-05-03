class Review {
  String createdByUserEmail;
  String text;
  String courseName;

  Review(
      {required this.createdByUserEmail,
      required this.text,
      required this.courseName});

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      createdByUserEmail: map['createdByUserId'],
      text: map['text'],
      courseName: map['courseName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdByUserId': createdByUserEmail,
      'text': text,
      'courseName': courseName,
    };
  }
}
