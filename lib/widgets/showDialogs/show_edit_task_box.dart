import 'package:flutter/material.dart';
import 'package:todo_app/models/repetition.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/database_service.dart';
import 'package:todo_app/utils/date_time_utils.dart';

Future<Task?> showEditTaskBox({
  required context,
  required DatabaseService databaseService,
  required Task task,
}) {
  DateTime firstDay = DateTime.utc(2000, 01, 01);
  DateTime lastDay = DateTime.utc(2999, 01, 01);

  return showDialog<Task?>(
    context: context,
    builder: (_) {
      DateTime selectedInitialDay = getDateTimeFromString(task.initialDate);
      TimeOfDay selectedTimeOfDay = getTimeOfDayFromString(task.initialTime);
      TimeOfDay selectedDuration = getTimeOfDayFromString(task.duration);
      Repetition selectedRepetition = task.repetition;
      bool allDay =
          selectedDuration.isAtSameTimeAs(TimeOfDay(hour: 0, minute: 0));

      final TextEditingController taskTextController = TextEditingController();
      taskTextController.text = task.content;

      return StatefulBuilder(builder: (context, setStateDialog) {
        VoidCallback? chooseDayButton = allDay
            ? () async {
                TimeOfDay? pickedTimeOfDay = await showTimePicker(
                  context: context,
                  initialTime: selectedTimeOfDay,
                );
                setStateDialog(() =>
                    selectedTimeOfDay = pickedTimeOfDay ?? TimeOfDay.now());
              }
            : null;
        VoidCallback? chooseDurationButton = allDay
            ? () async {
                TimeOfDay? pickedDuration = await showTimePicker(
                  context: context,
                  initialTime: selectedDuration,
                );
                setStateDialog(
                  () {
                    selectedDuration = pickedDuration ?? selectedDuration;
                  },
                );
              }
            : null;
        return AlertDialog(
          backgroundColor: Colors.grey.shade300,
          title: Center(child: Text('Add Task')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskTextController,
                  autofocus: true,
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
                              initialDate: selectedInitialDay,
                            );
                            setStateDialog(() {
                              selectedInitialDay =
                                  pickedDate ?? selectedInitialDay;
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
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: allDay,
                        onChanged: (value) {
                          setStateDialog(() {
                            allDay = value;
                            if (!allDay) {
                              chooseDayButton = () async {
                                TimeOfDay? pickedTimeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: selectedTimeOfDay,
                                );
                                setStateDialog(() => selectedTimeOfDay =
                                    pickedTimeOfDay ?? TimeOfDay.now());
                              };
                              chooseDurationButton = () async {
                                TimeOfDay? pickedDuration =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: selectedDuration,
                                );
                                setStateDialog(
                                  () {
                                    selectedDuration =
                                        pickedDuration ?? selectedDuration;
                                  },
                                );
                              };
                            } else {
                              chooseDayButton = null;
                              chooseDurationButton = null;
                            }
                          });
                        },
                      ),
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
                    Text("Duration"),
                    Expanded(
                      child: Center(
                        child: OutlinedButton(
                          onPressed: chooseDurationButton,
                          child: Text(
                            selectedDuration.format(context),
                          ),
                        ),
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
                                    selectedRepetition = newValue!;
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
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    task.content = taskTextController.text;
                    task.initialDate = getDateText(selectedInitialDay);
                    task.initialTime = selectedTimeOfDay.format(context);
                    task.duration = selectedDuration.format(context);
                    task.repetition = selectedRepetition;

                    if (task.content == '') return;

                    databaseService.updateTask(
                      task,
                    );
                    Navigator.pop(context, task);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Update',
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
