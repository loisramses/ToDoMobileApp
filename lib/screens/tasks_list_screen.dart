import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/widgets/task_item.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final todosList = null;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _databaseService.getTasks(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              return TaskItem(
                task: task,
                onDelete: (taskId) {
                  _databaseService.deleteTask(task.id);
                  setState(() {});
                },
                onStatusUpdate: (taskId, status) {
                  _databaseService.updateTaskStatus(
                    taskId,
                    status,
                  );
                  setState(() {});
                },
              );
            },
          );
        },
      ),
    );
  }
}

// use this if performance issues with too much tasks trying to load
// import 'package:flutter/material.dart';

// // Assuming TasksList is a StatefulWidget
// class TasksList extends StatefulWidget {
//   const TasksList({super.key});

//   @override
//   State<TasksList> createState() => _TasksListState();
// }

// class _TasksListState extends State<TasksList> with AutomaticKeepAliveClientMixin { // <-- Add this mixin
//   // Your existing state variables and methods for TasksList

//   @override
//   bool get wantKeepAlive => true; // <-- Crucial: Tells Flutter to keep this state alive

//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // <-- Must call super.build(context) when using the mixin
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tasks List')),
//       body: const Center(
//         child: Text('This is your Tasks List Screen', style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }
