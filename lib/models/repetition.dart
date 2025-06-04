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
}
