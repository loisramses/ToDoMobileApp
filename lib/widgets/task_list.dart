import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/widgets/task_item.dart';

class TaskList extends StatefulWidget {
  final DatabaseService databaseService;
  final Function(int) onDelete;
  final Function(int, int) onStatusUpdate;
  final Widget header;
  final String date;

  const TaskList({
    super.key,
    required this.databaseService,
    required this.header,
    required this.date,
    required this.onDelete,
    required this.onStatusUpdate,
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
        Expanded(
          child: FutureBuilder(
            future: widget.databaseService.getTasksByDate(widget.date),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Task task = snapshot.data![index];
                  return TaskItem(
                    task: task,
                    onDelete: (taskId) async {
                      await widget.onDelete(taskId);
                      setState(() {});
                    },
                    onStatusUpdate: (taskId, value) async {
                      await widget.onStatusUpdate(taskId, value);
                      setState(() {});
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
