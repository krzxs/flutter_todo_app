import 'package:flutter/material.dart';
import 'package:flutter_todo/colors.dart';
import 'package:flutter_todo/todo.dart';
import 'package:flutter_todo/todo_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: const Center(
          //TODO todo list
          ),
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
  }

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
}
