class Repetition {
  final int id;
  final String name;
  // final List<String> repetitions = [
  //   'Não se repete',
  //   'Todos os dias',
  //   'Todas as semanas',
  //   'Todos os meses',
  //   'Todos os anos',
  //   'Personalizado'
  // ];
  static List<String> listRepetitions = [
    "Doesn't repeat",
    "Every day",
    "Every week",
    "Every month",
    "Every year",
    "Custom"
  ];

  Repetition({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Repetition &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "Repetition(id: $id, name: $name)";
  }
}
