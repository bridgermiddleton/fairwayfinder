class Course {
  String name;
  String city;
  String state;

  Course({required this.name, required this.city, required this.state});

  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      name: data['name'],
      city: data['city'],
      state: data['state'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'city': city,
      'state': state,
    };
  }
}
