/*
A class representing tasks.
*/
class Task {
  String title = "";
  String discription = "";
  DateTime deadline = DateTime.now();

  /*
  CONSTRUCTORS
  */

  // Full constructor
  Task(String title, String discription, DateTime deadline) {
    setTitle(title);
    setDiscription(discription);
    setDeadline(deadline);
  }

  // Constructor without date
  Task.noDate(String title, String discription) {
    Task(title, discription, DateTime.now().add(const Duration(days: 2)));
  }

  // Constructor only with title
  Task.fromTitle(String title) {
    Task(title, "", DateTime.now().add(const Duration(days: 2)));
  }

  /*
  SETTERS
  */  

  void setTitle(String title){
    this.title = title;
  }

  void setDiscription(String discription){
    this.discription = discription;
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

  String getDiscription(){
    return discription;
  }

  DateTime getDeadline(){
    return deadline;
  }

  String getDeadlineToString(){
    String day = getDeadline().day.toString();
    return day; 
  }
}
