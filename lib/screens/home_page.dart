import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo/constants/colors.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/screens/todo_view_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences pref;

  List todoList = [];

  @override
  void initState() {
    super.initState();
    setupTodos();
  }

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
            //Menu na dole
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
                          clearTodos();
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

  //Przyciski w dolnym menu
  bottomSheetButton(String title, IconData icon, VoidCallback onTap) {
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

  //Pusta lista notatek
  emptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_list.png',
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

  //Wypełniona lista notatek
  tasksList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      scrollDirection: Axis.vertical,
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todoList[index] as Todo;
        //Gesty przesuwania
        return Dismissible(
          key: UniqueKey(),
          background: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 48.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
              removeTodo(index);
            }
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              changeTodoState(index);
              return false;
            }
            return true;
          },
          child: taskCard(todo, index),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return tasksSeparator();
      },
    );
  }

  //Card notatki
  taskCard(Todo todo, int index) {
    return Card(
      color: primaryColor,
      elevation: 0.0,
      shape: const LinearBorder(),
      child: InkWell(
        onTapUp: (tap) async {
          //Menu po przyciśnięciu
          await showMenu(
            color: secondaryColor,
            context: context,
            position: RelativeRect.fromLTRB(
              tap.globalPosition.dx,
              tap.globalPosition.dy,
              tap.globalPosition.dx,
              tap.globalPosition.dy,
            ),
            items: [
              popupMenuButton(
                todo.isDone
                    ? 'Oznacz jako niewykonane'
                    : 'Oznacz jako wykonane',
                todo.isDone ? Icons.close : Icons.check,
                () {
                  changeTodoState(index);
                },
              ),
              popupMenuButton(
                'Usuń notatkę',
                Icons.delete,
                () {
                  removeTodo(index);
                },
              ),
              popupMenuButton(
                'Edytuj notatkę',
                Icons.edit,
                () async {
                  editTodo(index);
                },
              ),
            ],
            elevation: 2.0,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4.0,
          ),
          child: ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                color: !todo.isDone ? primaryTextColor : secondaryTextColor,
                decoration: todo.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
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
        ),
      ),
    );
  }

  //Item z menu po przyciśnięciu
  PopupMenuItem popupMenuButton(
      String label, IconData icon, VoidCallback onTap) {
    return PopupMenuItem<String>(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryTextColor,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            label,
            style: const TextStyle(
              color: primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  //Separator między notatkami
  tasksSeparator() {
    return const Divider(
      color: secondaryTextColor,
      height: 1.0,
    );
  }

  addTodo() async {
    Todo todo = Todo('', '', false, DateTime.now());
    Todo? todoToReturn = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TodoViewPage(todo: todo)));
    if (todoToReturn != null) {
      setState(() {
        todoList.add(todoToReturn);
      });
      saveTodos();
    }
  }

  editTodo(int index) async {
    Todo todo = todoList[index];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Todo? todoToReturn = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => TodoViewPage(todo: todo)));
      if (todoToReturn != null) {
        setState(() {
          todoList[index] = todoToReturn;
        });
        saveTodos();
      }
    });
  }

  removeTodo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
    saveTodos();
  }

  changeTodoState(int index) {
    setState(() {
      todoList[index].changeState();
    });
    saveTodos();
  }

  clearTodos() {
    setState(() {
      todoList.clear();
    });
    saveTodos();
  }

  setupTodos() async {
    pref = await SharedPreferences.getInstance();
    if (pref.getString('todo') != null) {
      List jsonTodos = jsonDecode(pref.getString('todo')!);
      for (var todo in jsonTodos) {
        setState(() {
          todoList.add(fromJson(todo));
        });
      }
    }
  }

  saveTodos() {
    List jsonTodos = todoList.map((e) => e.toJson()).toList();
    pref.setString('todo', jsonEncode(jsonTodos));
  }
}
