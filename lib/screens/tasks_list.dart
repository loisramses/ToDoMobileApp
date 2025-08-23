import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/widgets/showDialogs/show_add_task_box.dart';
import 'package:todo_app/widgets/todo_item.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddTaskBox(
            context: context,
            databaseService: _databaseService,
            focusedDay: DateTime.now(),
          );
          setState(() {});
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Some Date',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Expanded(
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
            )
          ],
        ),
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
