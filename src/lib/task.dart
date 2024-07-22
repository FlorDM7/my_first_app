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

  void setDeadline(DateTime deadline){
    this.deadline = deadline;
  }

  /*
  GETTERS
  */

  String getTitle(){
    return title; 
  }

  String getDescription(){
    return description;
  }

  DateTime getDeadline(){
    return deadline;
  }

  String? getDeadlineToString(){
    return getDeadline().day.toString();
  }
}
