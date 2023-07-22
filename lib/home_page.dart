import 'package:flutter/material.dart';
import 'package:flutter_todo/colors.dart';

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
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetButton(
                        'Dodaj notatkę',
                        Icons.add,
                        () {
                          //TODO add note
                        },
                      ),
                      bottomSheetButton(
                        'Wyczyść notatki',
                        Icons.delete,
                        () {
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
          //TODO add note
        },
        child: const Icon(
          Icons.add,
          color: secondaryColorAccent,
        ),
      ),
    );
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
