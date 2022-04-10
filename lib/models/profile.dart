class Profile {
  Profile({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.uid,
  });

  String name;
  String phoneNumber;
  String email;
  String uid;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
    "email": email,
    "uid": uid,
  };

  @override
  String toString() {
    return 'Profile{name: $name, phoneNumber: $phoneNumber, email: $email, uid: $uid}';
  }

}
