import 'package:flutter_test/flutter_test.dart';
import 'package:marasigancjm_exer4_wx4l/network_helper.dart';

void main() {
  test('Testing get request', () async {
    // setup
    NetworkHelper network = NetworkHelper();
    // do
    await network.tasks();
    // test
    expect(network.testOutput,
        "Task{userId: 1, id: 1, title: delectus aut autem, completed: false}"); // first task in the network
  });

  test('Testing post request', () async {
    // setup
    NetworkHelper network = NetworkHelper();
    // do
    await network.insertTask(1, 201, "Task", false);
    // test
    expect(network.testOutput,
        "{userId: 1, id: 201, title: Task, completed: false}");
  });

  test('Testing put request', () async {
    // setup
    NetworkHelper network = NetworkHelper();
    // do
    await network.updateTask(1, 1, "updated title", false);
    // test
    expect(network.testOutput,
        "{userId: 1, id: 1, title: updated title, completed: false}");
  });

  test('Testing delete request', () async {
    // setup
    NetworkHelper network = NetworkHelper();
    // do
    await network.deleteTask("10");
    // test
    expect(network.testOutput, "{}");
  });
}
