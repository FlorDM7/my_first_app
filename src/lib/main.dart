import 'package:flutter/material.dart';
import 'tasklist.dart';
import 'task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do list',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Tasklist tasklist = Tasklist(); // create new tasklist object

  // method that makes a pop up widget for adding a new task
  Future<void> _showAddTaskDialog() async {
    String _newTaskTitle = "Untitled task"; // variables for the new task
    String _newTaskDescription = "";

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter a new task"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(), // place to get input from user
                    label: Text("Enter a title"),
                  ),
                  onChanged: (value) {
                    _newTaskTitle = value; // change the local variable
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(), // place to get input from user
                    label: Text("Enter a description"),
                  ),
                  onChanged: (value) {
                    _newTaskDescription = value; // change the local variable
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // two 'action' buttons at the bottom of the widget
            // cancel button
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // when button is pressed return to home screen
                },
                child: const Text("Cancel")),
            // add button
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // press add, call addTask method
                  _addTask(_newTaskTitle, _newTaskDescription);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  // add a new task
  // by changing the state
  void _addTask(String title, String description) {
    setState(() {
      tasklist.addTask(Task.noDate(title, description));
    });
  }


  // method that makes a pop up widget for an existing task, 
  // with the option to edit or complete/delete the task
  Future<void> _showInfoTaskDialog(Task currentTask) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(currentTask.getTitle()),
            content: Text(currentTask.getDescription()),
            actions: <Widget>[
              // return button
              TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // when button is pressed return to home screen
                  },
                  child: const Text("Return")),
              // edit button
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showEditTaskDialog(currentTask);
                },
                child: const Text("Edit"),
              ),
              // complete button
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  _deleteTask(currentTask);
                  Navigator.of(context).pop();
                },
                child: const Text("Complete"),
              ),
            ],
          );
        });
  }

  // delete a existing task
  // by changing the state
  void _deleteTask(Task task) {
    setState(() {
      tasklist.removeTask(task);
      // TODO add to the archive
    });
  }


  // method that makes a pop up widget for an exitsing task
  // with the option to edit the title and description
  Future<void> _showEditTaskDialog(Task currentTask) async {
    String _newTaskTitle = currentTask.getTitle();
    String _newTaskDescription = currentTask.getDescription();

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit '${currentTask.getTitle()}'"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(), // place to enter text
                    label: Text("Enter a new title (optional)"),
                  ),
                  onChanged: (value) {
                    _newTaskTitle = value; // change the local variable
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(), // place to enter text
                    label: Text("Enter a new description (optional)"),
                  ),
                  onChanged: (value) {
                    _newTaskDescription = value; // change the local variable
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // two buttons at the bottom of the widget
            // cancel button
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  // when button is pressed return to home screen
                  Navigator.of(context).pop(); 
                },
                child: const Text("Cancel")),
            // confirm button
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // press confirm, call editTask method
                  _editTask(currentTask, _newTaskTitle, _newTaskDescription);
                },
                child: const Text("Confirm")),
          ],
        );
      },
    );
  }

  // edit an existing task
  // by changing the state
  void _editTask(Task task, String title, String description) {
    setState(() {
      task.setTitle(title);
      task.setDescription(description);
    });
  }

  // This build method is rerun every time setState is called.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // List framework
      body: tasklist.isEmpty()
          ? const Center(child: Text('There are no tasks. Create one!'))
          : ListView.builder(
              itemCount: tasklist.length(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasklist.getTaskAt(index).getTitle()),
                  subtitle: Text(tasklist.getTaskAt(index).getDescription()),
                  onTap: () {
                    _showInfoTaskDialog(tasklist.getTaskAt(index));
                  },
                );
              },
            ),
      // Button to add new task
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
