class CommentClass {
  String? uuid;
  DateTime createdAt;
  String comment;
  String userId;
  String customerId;

  CommentClass({
    this.uuid,
    required this.createdAt,
    required this.comment,
    required this.userId,
    required this.customerId,
  });

  factory CommentClass.fromJson(Map<String, dynamic> json) {
    return CommentClass(
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['created_at']),
      comment: json['comment'] as String,
      customerId: json['customer_id'] as String,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    var data = {
      'comment': comment,
      'customer_id': customerId,
      'user_id': userId,
    };
    if (uuid != null) {
      data['uuid'] = uuid!;
    }
    return data;
  }
}
