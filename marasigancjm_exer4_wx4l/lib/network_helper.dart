import 'dart:async';
import 'dart:convert';
import 'task_model.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  String testOutput = "";

  // A method that retrieves all the tasks from the network.
  Future<List<Task>> tasks() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      testOutput =
          parsed.map<Task>((json) => Task.fromMap(json)).toList()[0].toString();
      print(testOutput);
      return parsed.map<Task>((json) => Task.fromMap(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tasks');
    }
  }

  // function that inserts a task into the network
  Future<Task> insertTask(
      int userId, int id, String title, bool completed) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      testOutput = jsonDecode(response.body).toString();
      print(testOutput); // to check
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create task.');
    }
  }

  // function that edits a task in the network
  Future<Task> updateTask(
      int userId, int id, String title, bool completed) async {
    String strId = id.toString();
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/$strId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      testOutput = jsonDecode(response.body).toString();
      print(testOutput);
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update task.');
    }
  }

  // function that deletes a task in the network
  Future<void> deleteTask(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON. After deleting,
      // we'll get an empty JSON `{}` response.
      testOutput = jsonDecode(response.body).toString();
      print(testOutput);
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete task.');
    }
  }
}
