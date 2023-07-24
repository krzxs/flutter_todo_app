class Todo {
  String title;
  String description;
  bool isDone;
  DateTime dateCreated;

  Todo(this.title, this.description, this.isDone, this.dateCreated);

  changeState() {
    isDone = !isDone;
  }
}
