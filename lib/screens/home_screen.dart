import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/date_time_utils.dart';
import 'package:todo_app/widgets/task_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final DatabaseService _databaseService = DatabaseService.instance;
  late List<Task> tasksList;
  DateTime focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(2000, 01, 01);
  DateTime lastDay = DateTime.utc(2999, 01, 01);

  late String taskDateText = getDateText(focusedDay, day: true, month: true);

  @override
  bool get wantKeepAlive => true;

  void refreshTasks() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
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
              focusedDay: focusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(focusedDay, day),
              onPageChanged: (focusedDay) {
                setState(() {
                  if (!isSameDay(focusedDay, this.focusedDay)) {
                    _calendarFormat = CalendarFormat.month;
                  }
                  this.focusedDay = focusedDay;
                });
              },
              onDaySelected: (selectedDay, focusedDay) => {
                setState(() {
                  this.focusedDay = selectedDay;
                  taskDateText =
                      getDateText(selectedDay, day: true, month: true);
                  _calendarFormat = CalendarFormat.week;
                })
              },
              calendarFormat: _calendarFormat,
              rowHeight: 40,
              currentDay: DateTime.now(),
            ),
            Expanded(
              child: FutureBuilder(
                future:
                    _databaseService.getTasksByDate(getDateText(focusedDay)),
                builder: (context, snapshot) {
                  tasksList = snapshot.data ?? [];
                  return TaskList(
                    header: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              taskDateText,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              focusedDay = today;
                              taskDateText = getDateText(focusedDay,
                                  day: true, month: true);
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.cyan.shade100),
                          ),
                          child: Text(
                            getDateText(today, day: true),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    tasks: tasksList,
                    onDelete: (taskId) => _databaseService.deleteTask(taskId),
                    onStatusUpdate: (taskId, status) =>
                        _databaseService.updateTaskStatus(taskId, status),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
