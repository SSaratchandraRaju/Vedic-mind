class UserProgressModel {
  double completionPercent;
  int totalQuizzes;
  int correctAnswers;

  UserProgressModel({
    this.completionPercent = 0.0,
    this.totalQuizzes = 0,
    this.correctAnswers = 0,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      UserProgressModel(
        completionPercent: (json['completionPercent'] ?? 0).toDouble(),
        totalQuizzes: json['totalQuizzes'] ?? 0,
        correctAnswers: json['correctAnswers'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'completionPercent': completionPercent,
    'totalQuizzes': totalQuizzes,
    'correctAnswers': correctAnswers,
  };
}
