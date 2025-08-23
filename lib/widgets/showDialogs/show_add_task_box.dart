import 'package:flutter/material.dart';
import 'package:todo_app/models/repetition.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/date_time_utils.dart';

Future<dynamic> showAddTaskBox({
  required context,
  required DatabaseService databaseService,
  required DateTime focusedDay,
}) {
  DateTime firstDay = DateTime.utc(2000, 01, 01);
  DateTime lastDay = DateTime.utc(2999, 01, 01);
  String? task;
  return showDialog(
    context: context,
    builder: (_) {
      DateTime selectedInitialDay = focusedDay;
      TimeOfDay selectedTimeOfDay = TimeOfDay.now();
      TimeOfDay duration = TimeOfDay(hour: 0, minute: 0);
      Repetition? selectedRepetition;
      bool allDay = true;
      VoidCallback? chooseDayButton;
      final TextEditingController taskTextController = TextEditingController();

      return StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: Center(child: Text('Add Task')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskTextController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Write your task...',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Day"),
                    Expanded(
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: firstDay,
                              lastDate: lastDay,
                              initialDate: focusedDay,
                            );
                            setStateDialog(() {
                              selectedInitialDay = pickedDate ?? focusedDay;
                            });
                          },
                          child: Text(
                            getDateText(selectedInitialDay),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("All day"),
                    Checkbox(
                      value: allDay,
                      onChanged: (value) {
                        setStateDialog(() {
                          allDay = value!;
                          if (!allDay) {
                            chooseDayButton = () async {
                              TimeOfDay? pickedTimeOfDay = await showTimePicker(
                                context: context,
                                initialTime: selectedTimeOfDay,
                              );
                              selectedTimeOfDay =
                                  pickedTimeOfDay ?? TimeOfDay.now();
                            };
                          } else {
                            chooseDayButton = null;
                          }
                        });
                      },
                    ),
                    OutlinedButton(
                      onPressed: chooseDayButton,
                      child: Text(
                        selectedTimeOfDay.format(context),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Repetition"),
                    SizedBox(width: 10),
                    Expanded(
                      child: FutureBuilder<List<Repetition>>(
                        future: databaseService.getRepetitions(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Text('No data');
                          }

                          selectedRepetition =
                              selectedRepetition ?? snapshot.data!.first;

                          return SizedBox(
                            width: double.infinity,
                            // padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Repetition>(
                                value: selectedRepetition,
                                hint: Text("Select repetition"),
                                isExpanded: true,
                                items:
                                    snapshot.data!.map((Repetition repetition) {
                                  return DropdownMenuItem<Repetition>(
                                    value: repetition,
                                    child: Text(repetition.name),
                                  );
                                }).toList(),
                                onChanged: (Repetition? newValue) {
                                  setStateDialog(() {
                                    selectedRepetition = newValue;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Duration"),
                    SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () async {
                        TimeOfDay? pickedDuration = await showTimePicker(
                          context: context,
                          initialTime: duration,
                        );
                        setStateDialog(
                          () {
                            duration =
                                pickedDuration ?? TimeOfDay(hour: 0, minute: 0);
                          },
                        );
                      },
                      child: Text(
                        duration.format(context),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    task = taskTextController.text;

                    if (task == null || task == '') return;

                    databaseService.addTask(
                      task!,
                      getDateText(selectedInitialDay),
                      selectedRepetition!.id,
                    );
                    setStateDialog(() {
                      task = null;
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
                )
              ],
            ),
          ),
        );
      });
    },
  );
}
