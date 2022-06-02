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
}
