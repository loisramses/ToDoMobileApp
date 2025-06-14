import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/services/database_service.dart';

import '../models/task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _databaseService = DatabaseService.instance;
  String? _task;

  final todosList = null;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.grey.shade300,
              title: Center(child: Text('Add Task')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _task = value;
                      });
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Write your task...'),
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (_task == null || _task == '') return;

                      _databaseService.addTask(_task!);
                      setState(() {
                        _task = null;
                      });
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            TableCalendar(
              locale: "pt_PT",
              headerStyle: HeaderStyle(titleCentered: true),
              focusedDay: today,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2999, 01, 01),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(today, day),
              onDaySelected: (selectedDay, focusedDay) => {
                setState(() {
                  today = selectedDay;
                })
              },
            ),
            Text(
              "All Tasks",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _databaseService.getTasks(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      Task task = snapshot.data![index];
                      return ListTile(
                        onLongPress: () {
                          _showConfirmBox(context, task);
                        },
                        title: Text(
                          task.content,
                          style: TextStyle(
                            decoration: task.status == 1
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        trailing: Checkbox(
                          value: task.status == 1,
                          onChanged: (value) {
                            _databaseService.updateTaskStatus(
                              task.id,
                              value == true ? 1 : 0,
                            );
                            setState(() {});
                          },
                        ),
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

  Future<dynamic> _showConfirmBox(BuildContext context, Task task) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: Center(child: Text('Remove Task')),
          content: Text('Are you sure you want to remove this task?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _databaseService.deleteTask(task.id);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade400,
      elevation: 0,
      centerTitle: true,
      leading: Icon(
        Icons.menu,
        color: Colors.black45,
        size: 38,
      ),
      title: Text(
        "TodoApp",
      ),
    );
  }
}
