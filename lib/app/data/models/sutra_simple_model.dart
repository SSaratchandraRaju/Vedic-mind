class SutraSimpleModel {
  final int sutraId;
  final String name;
  final String translation;
  final String difficulty;
  final int timeMinutes;
  final String whyLearn;
  final String objective;
  final String miniGame;
  final List<PracticeProblem> practice;

  SutraSimpleModel({
    required this.sutraId,
    required this.name,
    required this.translation,
    required this.difficulty,
    required this.timeMinutes,
    required this.whyLearn,
    required this.objective,
    required this.miniGame,
    required this.practice,
  });

  factory SutraSimpleModel.fromJson(Map<String, dynamic> json) {
    return SutraSimpleModel(
      sutraId: json['sutra_id'],
      name: json['name'],
      translation: json['translation'],
      difficulty: json['difficulty'],
      timeMinutes: json['time_minutes'],
      whyLearn: json['why_learn'],
      objective: json['objective'],
      miniGame: json['mini_game'] ?? '',
      practice: json['practice'] != null
          ? (json['practice'] as List)
                .map((p) => PracticeProblem.fromJson(p))
                .toList()
          : [],
    );
  }
}

class PracticeProblem {
  final String problem;
  final String answer;
  final String hint;

  PracticeProblem({
    required this.problem,
    required this.answer,
    required this.hint,
  });

  factory PracticeProblem.fromJson(Map<String, dynamic> json) {
    return PracticeProblem(
      problem: json['problem'],
      answer: json['answer'],
      hint: json['hint'],
    );
  }
}
