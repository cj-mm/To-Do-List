import 'dart:convert';

// Task Model
class Task {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // maps the data of json
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // Deserializes the result from JSON
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
