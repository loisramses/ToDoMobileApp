import 'package:flutter/material.dart';

import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/widgets/showDialogs/show_edit_task_box.dart';
import 'showDialogs/show_confirm_box.dart';

class TaskItem extends StatefulWidget {
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
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;

    return ListTile(
      onTap: () async {
        final updatedTask = await showEditTaskBox(
            context: context,
            databaseService: databaseService,
            task: widget.task);
        setState(() {
          _task = updatedTask ?? widget.task;
        });
      },
      onLongPress: () {
        showConfirmBox(
          context: context,
          title: 'Remove Task',
          confirmationText: 'Are you sure you want to remove this task?',
          onPressed: () {
            widget.onDelete(widget.task.id);
            Navigator.pop(context);
          },
        );
      },
      title: Text(
        "${_task.content} ${_task.repetition.name}",
        style: TextStyle(
          decoration: _task.status == 1 ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: _task.status == 1,
        onChanged: (value) {
          widget.onStatusUpdate(widget.task.id, value == true ? 1 : 0);
        },
        shape: CircleBorder(),
      ),
    );
  }
}
