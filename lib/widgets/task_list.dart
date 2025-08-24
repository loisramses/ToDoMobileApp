import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/task_item.dart';

class TaskList extends StatefulWidget {
  final Function(int) onDelete;
  final Function(int, int) onStatusUpdate;
  final bool scrollable;
  final Widget header;
  final List<Task> tasks;

  const TaskList({
    super.key,
    required this.header,
    required this.tasks,
    required this.onDelete,
    required this.onStatusUpdate,
    this.scrollable = true,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header,
        if (widget.scrollable) ...[
          Expanded(
            child: ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                Task task = widget.tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: (taskId) async {
                    await widget.onDelete(taskId);
                    setState(() {
                      widget.tasks.removeAt(index);
                    });
                  },
                  onStatusUpdate: (taskId, value) async {
                    await widget.onStatusUpdate(taskId, value);
                    setState(() {
                      widget.tasks[index].status = value;
                    });
                  },
                );
              },
            ),
          ),
        ] else
          ...widget.tasks.map(
            (task) {
              return TaskItem(
                task: task,
                onDelete: (taskId) async {
                  await widget.onDelete(taskId);
                  // setState(() {});
                },
                onStatusUpdate: (taskId, value) async {
                  await widget.onStatusUpdate(taskId, value);
                  // setState(() {});
                },
              );
            },
          ),
      ],
    );
  }
}
