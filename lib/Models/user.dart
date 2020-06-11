class User{
  String name;
  String email;
  String uid;
  User({this.uid, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
