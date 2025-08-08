import 'package:todo_app/models/repetition.dart';

class Task {
  final int id, status;
  final Repetition repetition;
  final String content, initialDate, initialTime, duration;

  Task({
    required this.id,
    required this.content,
    required this.status,
    required this.initialDate,
    required this.initialTime,
    required this.duration,
    required this.repetition,
  });

  @override
  String toString() {
    return "Task(id: $id, content: $content, status: $status, initialDate: $initialDate, initialTime: $initialTime, duration: $duration, repetition: ${repetition.toString()})";
  }
}
