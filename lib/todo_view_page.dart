import 'package:flutter/material.dart';
import 'package:flutter_todo/todo.dart';

import 'colors.dart';

class TodoViewPage extends StatefulWidget {
  final Todo todo;

  const TodoViewPage({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoViewPage> createState() => _TodoViewPageState();
}

class _TodoViewPageState extends State<TodoViewPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late Todo todo;

  @override
  void initState() {
    super.initState();
    todo = widget.todo;
    if(todo.title.isNotEmpty && todo.description.isNotEmpty) {
      titleController.text = todo.title;
      descriptionController.text = todo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: primaryTextColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Edytuj notatkę',
            style: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                textFormField(
                  'Wpisz tytuł',
                  titleController,
                  1,
                  20,
                ),
                const SizedBox(
                  height: 24,
                ),
                textFormField(
                  'Wpisz opis',
                  descriptionController,
                  4,
                  160,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: secondaryColor,
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              todo.title = titleController.text;
              todo.description = descriptionController.text;
              Navigator.pop(context, todo);
            }
          },
          child: const SizedBox(
            height: 64,
            child: Center(
              child: Text(
                'Zapisz',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Pola - input
  textFormField(String label, TextEditingController controller,
      int maxLines, int maxLength) {
    return TextFormField(
      controller: controller,
      cursorColor: secondaryTextColor,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        floatingLabelStyle: const TextStyle(
          color: primaryTextColor,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryTextColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColorAccent,
            width: 2.0,
          ),
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: secondaryTextColor,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: errorColor,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: errorColor,
            width: 2.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: errorColor,
        ),
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        color: primaryTextColor,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Pole nie może być puste!';
        }
        return null;
      },
    );
  }
}
