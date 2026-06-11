class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isLocal = false,
  });

  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isLocal;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isLocal: json['isLocal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'isLocal': isLocal,
    };
  }

  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isLocal,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
