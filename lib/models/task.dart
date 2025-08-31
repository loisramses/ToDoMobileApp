import 'package:todo_app/models/repetition.dart';

class Task {
  int id, status;
  Repetition repetition;
  String content, initialDate, initialTime, duration;

  Task({
    required this.id,
    required this.content,
    required this.status,
    required this.initialDate,
    required this.initialTime,
    required this.duration,
    required this.repetition,
  });

  Map<String, dynamic> asMap() {
    return {
      'id': id,
      'content': content,
      'status': status,
      'initialDate': initialDate,
      'initialTime': initialTime,
      'duration': duration,
      'repetition': repetition.id,
    };
  }

  @override
  String toString() {
    return "Task(id: $id, content: $content, status: $status, initialDate: $initialDate, initialTime: $initialTime, duration: $duration, repetition: ${repetition.toString()})";
  }
}
