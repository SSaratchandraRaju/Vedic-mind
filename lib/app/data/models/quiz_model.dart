class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizModel({
    this.id = '',
    this.question = '',
    this.options = const [],
    this.answerIndex = 0,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    id: json['id'] ?? '',
    question: json['question'] ?? '',
    options: List<String>.from(json['options'] ?? []),
    answerIndex: json['answerIndex'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'answerIndex': answerIndex,
  };
}
