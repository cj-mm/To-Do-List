import 'dart:convert';

List<Task> postFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromMap(x)));

class Task {
  final int userId;
  final int? id;
  final String title;
  final bool completed;

  const Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // Implement toString to make it easier to see information about
  // each task when using the print statement.
  @override
  String toString() {
    return 'Task{userId: $userId, id: $id, title: $title, completed: $completed}';
  }
}
