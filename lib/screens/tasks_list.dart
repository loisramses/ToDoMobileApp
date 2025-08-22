import 'package:flutter/material.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
