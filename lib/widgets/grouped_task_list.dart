import 'package:flutter/material.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/general_utils.dart';
import 'package:todo_app/widgets/task_list.dart';

class GroupedTaskList extends StatefulWidget {
  final DatabaseService databaseService;
  final Function(int) onDelete;
  final Function(int, int) onStatusUpdate;
  final ScrollController scrollController;
  final Function(bool) onScroll;

  const GroupedTaskList({
    super.key,
    required this.databaseService,
    required this.onDelete,
    required this.onStatusUpdate,
    required this.scrollController,
    required this.onScroll,
  });

  @override
  State<GroupedTaskList> createState() => _GroupedTaskListState();
}

class _GroupedTaskListState extends State<GroupedTaskList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final showButton = widget.scrollController.position.pixels >
        (widget.scrollController.position.maxScrollExtent * 0.1);
    widget.onScroll(showButton);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.databaseService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        Map groupedTasks = groupTasksByDate(snapshot.data!);
        var dates = groupedTasks.keys.toList();

        return ListView.builder(
          controller: widget.scrollController,
          itemCount: groupedTasks.length,
          reverse: true,
          itemBuilder: (context, index) {
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
