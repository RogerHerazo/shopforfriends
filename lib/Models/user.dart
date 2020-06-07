class User{
  String name;
  String email;
  User
({this.name, this.email});

  factory User
.fromJson(Map<String, dynamic> json) {
    return User
  (
      name: json['name'],
      email: json['email'],
    );
  }

  Map toJson() {
    return {'name': name, 'email': email};
  }
}
