import 'dart:async';
import 'dart:convert';
import 'task_model.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  // A method that retrieves all the tasks from the network.
  Future<List<Task>> tasks() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Task>((json) => Task.fromMap(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tasks');
    }
  }

  // Define a function that inserts tasks into the network
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
      print(jsonDecode(response.body));
      return Task.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create task.');
    }
  }
}
