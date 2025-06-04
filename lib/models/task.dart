class Task {
  final int id, status, repetitionId;
  final String content, initialDate, initialTime, duration;

  Task({
    required this.id,
    required this.content,
    required this.status,
    required this.initialDate,
    required this.initialTime,
    required this.duration,
    required this.repetitionId,
  });
}
