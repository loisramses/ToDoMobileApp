import 'package:todo_app/models/task.dart';

Map<String, List<Task>> groupTasksByDate(List<Task> tasks) {
  Map<String, List<Task>> groupedTasks = {};
  for (var task in tasks) {
    if (groupedTasks.containsKey(task.initialDate)) {
      groupedTasks[task.initialDate]!.add(task);
    } else {
      groupedTasks[task.initialDate] = [task];
    }
  }
  return groupedTasks;
}
