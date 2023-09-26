import 'dart:convert';

class TodoModel {
  final int id;
  final int userId;
  String title;
  String content;
  final dynamic createdAt;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "content": content,
      "createdAt": createdAt,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));
}
