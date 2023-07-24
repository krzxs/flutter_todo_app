import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo/colors.dart';
import 'package:flutter_todo/todo.dart';
import 'package:flutter_todo/todo_view_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todoList = [
    Todo(
      'Test - false',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      false,
      DateTime.now(),
    ),
    Todo(
      'Test - true',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      true,
      DateTime.now(),
    ),
    Todo(
      'Test - true',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      true,
      DateTime.now(),
    ),
    Todo(
      'Test - true',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      true,
      DateTime.now(),
    ),
    Todo(
      'Test - true',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      true,
      DateTime.now(),
    ),
    Todo(
      'Test - true',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus enim ex, tincidunt non ligula nec, posuere.',
      true,
      DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: primaryTextColor,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
              ),
              backgroundColor: secondaryColor,
              builder: (context) {
                return SizedBox(
                  height: 128,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetButton(
                        'Dodaj notatkę',
                        Icons.add,
                        () {
                          Navigator.pop(context);
                          addTodo();
                        },
                      ),
                      bottomSheetButton(
                        'Wyczyść notatki',
                        Icons.delete,
                        () {
                          Navigator.pop(context);
                          //TODO clear all notes
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'ToDo App',
            style: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: todoList.isEmpty ? emptyList() : tasksList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColorAccent,
        tooltip: 'Dodaj notatkę',
        onPressed: () {
          addTodo();
        },
        child: const Icon(
          Icons.add,
          color: secondaryColorAccent,
        ),
      ),
    );
  }

  addTodo() async {
    Todo todo = Todo('', '', false, DateTime.now());
    Todo? todoToReturn = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TodoViewPage(todo: todo)));
    //TODO add todo
  }

  //TODO save todos

  Widget bottomSheetButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: secondaryTextColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: primaryTextColor,
          ),
        ),
      ),
    );
  }

  Widget emptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'empty_list.svg',
            height: 256,
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'Brak notatek!',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 18.0,
            ),
          ),
          const Text(
            'Dodaj notatki klikając przycisk w rogu.',
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }

  Widget tasksList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      scrollDirection: Axis.vertical,
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todoList[index] as Todo;
        return Dismissible(
          key: UniqueKey(),
          background: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 48.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  todo.isDone ? Icons.close : Icons.check,
                  color: todo.isDone ? errorColor : primaryColorAccent,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  todo.isDone
                      ? 'Oznacz jako niewykonane'
                      : 'Oznacz jako wykonane',
                  style: const TextStyle(
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          secondaryBackground: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 48.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete,
                  color: errorColor,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Usuń notatkę',
                  style: TextStyle(
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              setState(() {
                todoList.removeAt(index);
              });
            }
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              setState(() {
                todoList[index].changeState();
              });
              return false;
            }
            return true;
          },
          child: taskCard(todo),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return tasksSeparator();
      },
    );
  }

  //TODO on press card menu
  Widget taskCard(Todo todo) {
    return Card(
      color: primaryColor,
      elevation: 0.0,
      shape: const LinearBorder(),
      child: ListTile(
        title: Text(
          todo.title,
          style: TextStyle(
            color: !todo.isDone ? primaryTextColor : secondaryTextColor,
            decoration:
                todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: secondaryColorAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.description,
              style: TextStyle(
                color: !todo.isDone ? primaryTextColor : secondaryTextColor,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: secondaryColorAccent,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Utworzono: ${(DateFormat('HH:mm dd.MM.yyyy').format(todo.dateCreated))}',
              style: TextStyle(
                color: secondaryTextColor,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: secondaryColorAccent,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tasksSeparator() {
    return const Divider(
      color: secondaryTextColor,
    );
  }
}
