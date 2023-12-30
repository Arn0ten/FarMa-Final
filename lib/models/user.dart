class User {
  final String uid;
  final String email;
  final String displayName;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      // Add other User properties as needed
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      // Add other User properties as needed
    };
  }
}
