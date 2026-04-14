class UserClass {
  String? uuid;
  DateTime createdAt;
  String email;
  String name;
  String password;

  UserClass({
    this.uuid,
    required this.email,
    required this.createdAt,
    required this.name,
    required this.password,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
