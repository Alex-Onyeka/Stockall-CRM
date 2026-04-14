class CustomerClass {
  final String? uuid;
  final DateTime createdAt;
  final String? email;
  final String name;
  final String userId;
  final String phone;
  DateTime lastComment;
  int status;

  CustomerClass({
    this.uuid,
    required this.createdAt,
    required this.email,
    required this.name,
    required this.userId,
    required this.phone,
    required this.lastComment,
    required this.status,
  });

  factory CustomerClass.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      email: json['email'] as String?,
      name: json['name'] as String,
      userId: json['user_id'] as String,
      phone: json['phone'] as String,
      lastComment: DateTime.parse(json['last_comment']),
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'last_comment': lastComment.toIso8601String(),
      'status': status,
    };

    if (uuid != null) {
      data['uuid'] = uuid!;
    }

    return data;
  }
}
