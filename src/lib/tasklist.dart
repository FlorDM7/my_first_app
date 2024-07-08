import 'task.dart';

/*
A class representing a list of tasks.
*/
class Tasklist {
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

}