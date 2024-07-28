import 'task.dart';
import 'package:hive/hive.dart';

part 'tasklist.g.dart'; // Generated file for the adapter

/*
A class representing a list of tasks.
*/
@HiveType(typeId: 1)
class Tasklist {
  @HiveField(0)
  List<Task> tasks = [];

  // empty constructor
  Tasklist();

  void addTask(Task task) {
    tasks.add(task);
  }

  bool removeTask(Task task) {
    if (isElementOfList(task)){
      tasks.remove(task);
      return true;
    }
    return false;
  }

  Task getTaskAt(int index) {
    return tasks[index];
  }

  int getIndexOf(Task task) {
    int n = 0;
    for (Task task in tasks) {
      if (task == getTaskAt(n)) return n++;
    }
    return -1;
  }

  bool isElementOfList(Task task) {
    return getIndexOf(task) != -1;
  }

  int length() {
    return tasks.length;
  }

  bool isEmpty() {
    return tasks.isEmpty;
  }

  void sortByDate() {
    tasks.sort((a, b) => a.getDeadline().compareTo(b.getDeadline()));
  }

}