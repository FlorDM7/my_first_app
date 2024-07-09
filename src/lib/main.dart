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

  Future<void> _showAddTaskDialog() async {
    String _newTaskTitle = "Unnamed task";
    String _newTaskDescription = "You didn't enter anything";

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
                    border: UnderlineInputBorder(),
                    label: Text("Enter a title"),
                  ),
                  onChanged: (value) {
                    _newTaskTitle = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text("Enter a description"),
                  ),
                  onChanged: (value) {
                    _newTaskDescription = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge,),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel")),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge,),
              onPressed: () {
                Navigator.of(context).pop();
                _addTask(_newTaskTitle, _newTaskDescription);
              },
              child: const Text("Add")),
          ],
        );
      },
    );
  }

  void _addTask(String title, String description) {
    setState(() {
      tasklist.addTask(Task.noDate(title, description));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: tasklist.isEmpty()
          ? const Center(child: Text('There are no tasks. Create one!'))
          : ListView.builder(
              itemCount: tasklist.length(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasklist.getTaskAt(index).getTitle()),
                  subtitle: Text(tasklist.getTaskAt(index).getDescription()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
