import 'package:flutter/material.dart';

/*
A class representing tasks.
*/
class Task {
  String title;
  String description;
  DateTime deadline = DateTime.now();

  /*
  CONSTRUCTORS
  */

  // Full constructor
  Task(this.title, this.description, this.deadline);

  // Constructor without date
  Task.noDate(this.title, this.description);

  /*
  SETTERS
  */  

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setDeadline(DateTime deadline) {
    this.deadline = deadline;
  }

  /*
  GETTERS
  */

  String getTitle() {
    return title; 
  }

  String getDescription() {
    return description;
  }

  DateTime getDeadline() {
    return deadline;
  }

  String? getDeadlineToString() {
    return getDeadline().day.toString();
  }

  Color getDeadlineColor() {
    if (getDeadline().isBefore(DateTime.now())) {
      return Colors.red;  // when deadline is passed show red
    } else if (getDeadline().isBefore(DateTime.now().add(const Duration(days: 1)))) {
      return Colors.orange; // when one day remains for deadline
    } else if (getDeadline().isBefore(DateTime.now().add(const Duration(days: 2)))) {
      return Colors.yellow; // when two days remains for deadline
    } else {
      return Colors.white;
    }
  }

}
