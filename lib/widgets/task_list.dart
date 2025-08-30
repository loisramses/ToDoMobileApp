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
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
  }

  @override
  void didUpdateWidget(covariant TaskList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks != oldWidget.tasks) {
      setState(() {
        _tasks = List.from(widget.tasks);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header,
        if (widget.scrollable) ...[
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                Task task = _tasks[index];
                return TaskItem(
                  task: task,
                  onDelete: (taskId) async {
                    await widget.onDelete(taskId);
                    setState(() {
                      _tasks.removeAt(index);
                    });
                  },
                  onStatusUpdate: (taskId, value) async {
                    await widget.onStatusUpdate(taskId, value);
                    setState(() {
                      _tasks[index].status = value;
                    });
                  },
                );
              },
            ),
          ),
        ] else
          ..._tasks.map(
            (task) {
              return TaskItem(
                task: task,
                onDelete: (taskId) async {
                  await widget.onDelete(taskId);
                  setState(() {
                    _tasks.removeWhere(
                      (task) => task.id == taskId,
                    );
                  });
                },
                onStatusUpdate: (taskId, value) async {
                  await widget.onStatusUpdate(taskId, value);
                  setState(() {
                    final taskIndex = _tasks.indexWhere(
                      (task) => task.id == taskId,
                    );
                    _tasks[taskIndex].status = value;
                  });
                },
              );
            },
          ),
      ],
    );
  }
}
