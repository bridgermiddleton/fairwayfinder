class Review {
  String createdByUserId;
  String text;
  String courseName;

  Review(
      {required this.createdByUserId,
      required this.text,
      required this.courseName});

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      createdByUserId: map['createdByUserId'],
      text: map['text'],
      courseName: map['courseName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdByUserId': createdByUserId,
      'text': text,
      'courseName': courseName,
    };
  }
}
