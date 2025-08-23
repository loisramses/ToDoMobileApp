import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/date_time_utils.dart';
import 'package:todo_app/widgets/task_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final todosList = null;
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(2000, 01, 01);
  DateTime lastDay = DateTime.utc(2999, 01, 01);

  late String taskDateText = getDateText(_focusedDay, day: true, month: true);

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: TaskList(
                databaseService: _databaseService,
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
                          _focusedDay = today;
                          taskDateText =
                              getDateText(_focusedDay, day: true, month: true);
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
                date: getDateText(_focusedDay),
                onDelete: (taskId) => _databaseService.deleteTask(taskId),
                onStatusUpdate: (taskId, status) =>
                    _databaseService.updateTaskStatus(
                  taskId,
                  status,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
