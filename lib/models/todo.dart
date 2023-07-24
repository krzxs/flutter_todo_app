class Todo {
  String title;
  String description;
  bool isDone;
  DateTime dateCreated;

  Todo(this.title, this.description, this.isDone, this.dateCreated);

  changeState() {
    isDone = !isDone;
  }

  toJson() {
    return {
      "title": title,
      "description": description,
      "isDone": isDone,
      "dateCreated": dateCreated.millisecondsSinceEpoch,
    };
  }
}

fromJson(jsonData) {
  return Todo(
    jsonData['title'],
    jsonData['description'],
    jsonData['isDone'],
    DateTime.fromMicrosecondsSinceEpoch(jsonData['dateCreated']),
  );
}
