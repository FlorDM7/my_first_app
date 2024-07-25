import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Tasklist tasklist = Tasklist(); // create new tasklist object
  Tasklist archive = Tasklist();

  // method that makes a pop up widget for adding a new task
  Future<void> _showAddTaskDialog() async {
    String _newTaskTitle = "Untitled task"; // variables for the new task
    String _newTaskDescription = "";
    int _deadlineYear = DateTime.now().year;
    int _deadlineMonth = DateTime.now().month;
    int _deadlineDay = DateTime.now().day;

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
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a year for the deadline")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineYear = int.parse(value); // change the local variable
                  },  
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a month for the deadline")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineMonth = int.parse(value); // change the local variable
                  },  
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a day for the deadline")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineDay = int.parse(value); // change the local variable
                  },  
                )
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
                  _addTask(_newTaskTitle, _newTaskDescription, _deadlineYear, _deadlineMonth, _deadlineDay);
                },
                child: const Text("Add")),
          ],
        );
      },
    );
  }

  // add a new task
  // by changing the state
  void _addTask(String title, String description, int year, int month, int day) {
    setState(() {
      tasklist.addTask(Task(title, description, DateTime.utc(year, month, day)));
      tasklist.sortByDate();
  });
  }


  // method that makes a pop up widget for an existing task, 
  // with the option to edit or complete/delete the task
  Future<void> _showInfoTaskDialog(Task currentTask) async {
    int day = currentTask.deadline.day;
    int month = currentTask.deadline.month;
    int year = currentTask.deadline.year;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(currentTask.getTitle()),
            content: Text("${currentTask.getDescription()}\nDeadline: ${day.toString()}/${month.toString()}/${year.toString()}"),
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
      tasklist.sortByDate();
      archive.addTask(task);
    });
  }


  // method that makes a pop up widget for an exitsing task
  // with the option to edit the title and description
  Future<void> _showEditTaskDialog(Task currentTask) async {
    String _newTaskTitle = currentTask.getTitle();
    String _newTaskDescription = currentTask.getDescription();
    int _deadlineYear = currentTask.getDeadline().year;
    int _deadlineMonth = currentTask.getDeadline().month;
    int _deadlineDay = currentTask.getDeadline().day;

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit '${currentTask.getTitle()}'"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Current description: ${currentTask.getDescription()}\nCurrent deadline: ${currentTask.deadline.day.toString()}/${currentTask.deadline.month.toString()}/${currentTask.deadline.year.toString()}"),
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
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a new year for the deadline (optional)")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineYear = int.parse(value); // change the local variable
                  },  
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a new month for the deadline (optional)")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineMonth = int.parse(value); // change the local variable
                  },  
                ),
                TextField(
                  decoration: const InputDecoration(label: Text("Enter a new day for the deadline (optional)")),
                  keyboardType: TextInputType.datetime,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    _deadlineDay = int.parse(value); // change the local variable
                  },  
                )
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
                  _editTask(currentTask, _newTaskTitle, _newTaskDescription, _deadlineYear, _deadlineMonth, _deadlineDay);
                },
                child: const Text("Confirm")),
          ],
        );
      },
    );
  }

  // edit an existing task
  // by changing the state
  void _editTask(Task task, String title, String description, int year, int month, int day) {
    setState(() {
      task.setTitle(title);
      task.setDescription(description);
      task.setDeadline(DateTime.utc(year, month, day));
      tasklist.sortByDate();
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
      // Tasklist framework
      body: tasklist.isEmpty()
          ? const Center(child: Text('There are no tasks. Create one!'))
          : ListView.builder(
              itemCount: tasklist.length(),
              itemBuilder: (context, index) {
                Task currentTask = tasklist.getTaskAt(index);
                return ListTile(
                  tileColor: currentTask.getDeadlineColor(),
                  title: Text(currentTask.getTitle()),
                  subtitle: Text(currentTask.getDescription()),
                  onTap: () {
                    _showInfoTaskDialog(currentTask);
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