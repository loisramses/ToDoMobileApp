import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/repetition.dart';
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
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(2000, 01, 01);
  DateTime lastDay = DateTime.utc(2999, 01, 01);

  late String taskDateText = getDateText(_focusedDay, day: true, month: true);

  String getDateText(DateTime date,
      {bool day = false, bool month = false, bool year = false}) {
    String dateString = date.toString().split(" ")[0];
    List<String> dateStringSplit = dateString.split("-");
    String dayString = dateStringSplit[2];
    String monthString = dateStringSplit[1];
    String yearString = dateStringSplit[0];
    String res = "";
    if (day) res = dayString;
    if (month) res = "$res-$monthString";
    if (year) res = "$res-$yearString";
    if (res.isEmpty || date.year != today.year) {
      return "$dayString-$monthString-$yearString";
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddTask(context);
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
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              focusedDay: _focusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(_focusedDay, day),
              onPageChanged: (focusedDay) {
                setState(() {
                  if (!isSameDay(focusedDay, _focusedDay)) {
                    _calendarFormat = CalendarFormat.month;
                  }
                  _focusedDay = focusedDay;
                });
              },
              onDaySelected: (selectedDay, focusedDay) => {
                setState(() {
                  _focusedDay = selectedDay;
                  taskDateText =
                      getDateText(selectedDay, day: true, month: true);
                  _calendarFormat = CalendarFormat.week;
                })
              },
              calendarFormat: _calendarFormat,
              rowHeight: 40,
              currentDay: DateTime.now(),
            ),
            Text(
              taskDateText,
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

  Future<dynamic> _showDialogAddTask(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) {
        DateTime _selectedInitialDay = _focusedDay;
        TimeOfDay _selectedTimeOfDay = TimeOfDay.now();
        bool _allDay = true;
        VoidCallback? _chooseDayButton;

        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: Center(child: Text('Add Task')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setStateDialog(() {
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
                  Text("Day"),
                  OutlinedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: firstDay,
                        lastDate: lastDay,
                        initialDate: _focusedDay,
                      );
                      setStateDialog(() {
                        _selectedInitialDay = pickedDate ?? _focusedDay;
                      });
                    },
                    child: Text(
                      getDateText(_selectedInitialDay),
                    ),
                  ),
                  Text("Repetition"),
                  Row(
                    children: [
                      Text("All day"),
                      Checkbox(
                        value: _allDay,
                        onChanged: (value) {
                          setStateDialog(() {
                            _allDay = value!;
                            if (!_allDay) {
                              _chooseDayButton = () async {
                                TimeOfDay? pickedTimeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTimeOfDay,
                                );
                                _selectedTimeOfDay =
                                    pickedTimeOfDay ?? TimeOfDay.now();
                              };
                            } else {
                              _chooseDayButton = null;
                            }
                          });
                        },
                      ),
                      OutlinedButton(
                        onPressed: _chooseDayButton,
                        child: Text(
                          _selectedTimeOfDay.format(context),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: _databaseService.getRepetitions(),
                    builder: (context, snapshot) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 30),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            Repetition repetition = snapshot.data![index];
                            return ListTile(
                              title: Text(
                                repetition.name,
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (_task == null || _task == '') return;

                      _databaseService.addTask(
                        _task!,
                        getDateText(_selectedInitialDay),
                      );
                      setStateDialog(() {
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
        });
      },
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
