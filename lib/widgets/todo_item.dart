import 'package:flutter/material.dart';

import '../models/task.dart';

class TodoItem extends StatelessWidget {
  final Task todo;
  final onToDoChanged;
  final onToDoDelete;

  const TodoItem(
      {super.key,
      required this.todo,
      required this.onToDoChanged,
      required this.onToDoDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: IconButton(
          icon: todo.status == 1
              ? Icon(Icons.check_circle)
              : Icon(Icons.check_circle_outline),
          color: Colors.blue,
          onPressed: () {
            onToDoChanged(todo);
            debugPrint('check');
          },
        ),
        title: Text(
          todo.content,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            decoration: todo.status == 0 ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_outlined,
            color: Colors.redAccent,
          ),
          onPressed: () {
            onToDoDelete(todo);
            debugPrint('delete');
          },
        ),
      ),
    );
  }
}
