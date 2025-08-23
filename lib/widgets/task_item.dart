import 'package:flutter/material.dart';

import 'package:todo_app/models/task.dart';
import 'showDialogs/show_confirm_box.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(int) onDelete;
  final Function(int, int) onStatusUpdate;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        showConfirmBox(
          context: context,
          title: 'Remove Task',
          confirmationText: 'Are you sure you want to remove this task?',
          onPressed: () {
            onDelete(task.id);
            Navigator.pop(context);
          },
        );
      },
      title: Text(
        "${task.content} ${task.repetition.name}",
        style: TextStyle(
          decoration: task.status == 1 ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: task.status == 1,
        onChanged: (value) {
          onStatusUpdate(task.id, value == true ? 1 : 0);
        },
      ),
    );
  }
}
