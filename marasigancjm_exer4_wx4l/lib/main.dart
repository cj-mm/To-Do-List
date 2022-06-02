import 'package:flutter/material.dart';
import 'network_helper.dart';
import 'task_model.dart';

void main() {
  // move here the ensureInitialized method of WidgetsFlutterBinding from the db_helper.dart
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Networking';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(title: 'To Do v2'),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _task =
      TextEditingController(); //controller for getting name
  final TextEditingController _edit =
      TextEditingController(); //controller for getting edit
  final _formKey = GlobalKey<FormState>();
  //create a counter variable for Task id
  int counter = 200;
  String newEditValue = "";
  String editTextFieldValue = "";
  bool _checked = false;

  //create a helper object to access network functions
  NetworkHelper db = NetworkHelper();

  // create a future list of task that will store all the task data from database
  late Future<List<Task>> myTask;
  // late Future<Task> myTask;
  @override
  void initState() {
    super.initState();

    // initialize myTask list by getting data from database
    myTask = db.tasks();
  }

  final bool _validate = false; //used for validation of input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: const Color.fromARGB(255, 11, 119, 56),
          leading: const Icon(Icons.task),
          titleSpacing: 0,
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/bg_img.jpg"), fit: BoxFit.cover),
            ), // background image
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildTextField('Enter task title', _task),
                    // const SizedBox(height: 10), // just add space in between
                    // buildTextField('Enter details', _details),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildSaveButton(),
                      ],
                    ),
                    myTaskList(),
                  ],
                ),
              ),
            )));
  }

  // function for creating a textfield widget which accepts the label and controller as parameter
  Widget buildTextField(String label, TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 22, 22, 22), width: 2),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 87, 135, 238), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: const Color.fromARGB(43, 255, 255, 255),
          filled: true,
          labelText: label,
          errorText: _validate ? 'Value can\'t be empty' : null),
      validator: (value) {
        //validates if value in controller/textfield is not empty
        if (value == null || value.isEmpty) {
          return 'Please $label';
        }
        return null;
      },
    );
  }

  // function for creating save button
  Widget buildSaveButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: const Color.fromARGB(221, 0, 0, 0),
            primary: const Color.fromARGB(255, 255, 255, 255),
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16)),
        child: const Text(
          'ADD TASK',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final List tasksList = await myTask;
            db.insertTask(1, counter++, _task.text, false);
            setState(() {
              tasksList.add(Task(
                  userId: 1,
                  id: counter++,
                  title: _task.text,
                  completed: false));
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Processing Data'),
                  duration: Duration(milliseconds: 500)),
            );
            //clear text on controllers after successful insert of data to database
            _task.clear();

            FocusScope.of(context).unfocus(); // unfocus input fields
          }
        });
  }

  Widget myTaskList() {
    return Expanded(
      child: FutureBuilder(
          future: myTask,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildText(snapshot.data as List<Task>);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(
                child:
                    CircularProgressIndicator(value: null, strokeWidth: 7.0));
          }),
    );
  }

  Future<void> editModal(BuildContext context, int taskIdx) async {
    final List tasksList = await myTask;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  editTextFieldValue = value;
                });
              },
              controller: _edit..text = tasksList[taskIdx].title,
              decoration: const InputDecoration(hintText: "Edit Task"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  newEditValue = editTextFieldValue;
                  db.updateTask(1, tasksList[taskIdx].id, newEditValue,
                      tasksList[taskIdx].completed);
                  setState(() {
                    tasksList[taskIdx] = Task(
                        userId: 1,
                        id: taskIdx,
                        title: newEditValue,
                        completed: tasksList[taskIdx].completed);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  // widget that returns listview of myTask data
  Widget buildText(List<Task> myTask) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: myTask.length,
      itemBuilder: (context, int index) {
        _checked = myTask[index].completed;
        return Center(
          child: Card(
            // wrap in card for styling
            margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: const Color.fromARGB(0, 0, 0, 0),
            child: CheckboxListTile(
              selected: _checked,
              value: _checked,
              contentPadding: const EdgeInsets.only(left: 10),
              title: Text(myTask[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 44, 43, 43))),
              secondary: Wrap(
                spacing: -18, // space between two icons
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Color.fromARGB(255, 92, 57, 248)),
                    onPressed: () {
                      editModal(context, index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Color.fromARGB(255, 219, 15, 0)),
                    onPressed: () {
                      db.deleteTask(myTask[index].id.toString()); // delete task
                      setState(() {
                        myTask.removeAt(
                            index); // remove task in the UI without reloading
                      });
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Successfully Deleted"),
                          duration: Duration(milliseconds: 500)));
                    },
                  ),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) async {
                final List tasksList = await myTask;
                setState(() {
                  tasksList[index] = Task(
                      userId: 1,
                      id: tasksList[index].id,
                      title: tasksList[index].title,
                      completed: value!);
                });
              },
            ),
          ),
        );
      },
    );
  }
}
