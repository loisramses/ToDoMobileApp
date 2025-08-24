import 'package:flutter/material.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/general_utils.dart';
import 'package:todo_app/widgets/task_list.dart';

class GroupedTaskList extends StatefulWidget {
  final DatabaseService databaseService;
  final Function(int) onDelete;
  final Function(int, int) onStatusUpdate;

  const GroupedTaskList({
    super.key,
    required this.databaseService,
    required this.onDelete,
    required this.onStatusUpdate,
  });

  @override
  State<GroupedTaskList> createState() => _GroupedTaskListState();
}

class _GroupedTaskListState extends State<GroupedTaskList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.databaseService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        Map groupedTasks = groupTasksByDate(snapshot.data!);
        var dates = groupedTasks.keys.toList();

        return ListView.builder(
          itemCount: groupedTasks.length,
          reverse: true,
          itemBuilder: (context, index) {
            // return Text(snapshot.data![index].content);
            return TaskList(
              header: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(dates[index]),
                    ),
                  )
                ],
              ),
              tasks: groupedTasks[dates[index]],
              onDelete: widget.onDelete,
              onStatusUpdate: widget.onStatusUpdate,
              scrollable: false,
            );
          },
        );
      },
    );
  }
}
