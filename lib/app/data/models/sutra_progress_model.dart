/// Model for tracking individual sutra progress and accuracy
class SutraProgress {
  final int sutraId;
  final bool isCompleted;
  final int totalAttempts;
  final int correctAnswers;
  final int hintsUsed;
  final int wrongAnswers;
  final DateTime? lastAttemptDate;
  final DateTime? completedDate;
  
  SutraProgress({
    required this.sutraId,
    this.isCompleted = false,
    this.totalAttempts = 0,
    this.correctAnswers = 0,
    this.hintsUsed = 0,
    this.wrongAnswers = 0,
    this.lastAttemptDate,
    this.completedDate,
  });
  
  /// Calculate accuracy percentage
  double get accuracy {
    if (totalAttempts == 0) return 0.0;
    // Reduce accuracy for hints and wrong answers
    final baseAccuracy = (correctAnswers / totalAttempts) * 100;
    final hintPenalty = hintsUsed * 2.0; // 2% penalty per hint
    final wrongPenalty = wrongAnswers * 5.0; // 5% penalty per wrong answer
    
    final finalAccuracy = (baseAccuracy - hintPenalty - wrongPenalty).clamp(0.0, 100.0);
    return finalAccuracy;
  }
  
  /// Get completion percentage (0-100)
  double get completionPercentage {
    if (isCompleted) return 100.0;
    if (totalAttempts == 0) return 0.0;
    // Partial completion based on attempts
    return (totalAttempts * 10.0).clamp(0.0, 90.0);
  }
  
  /// Calculate points earned from this sutra
  int get points {
    if (totalAttempts == 0) return 0;
    // Base points: 10 points per correct answer
    final basePoints = correctAnswers * 10;
    // Bonus for completion: 50 points
    final completionBonus = isCompleted ? 50 : 0;
    // Accuracy bonus: up to 50 points based on accuracy
    final accuracyBonus = (accuracy / 2).floor();
    
    return basePoints + completionBonus + accuracyBonus;
  }
  
  /// Create from JSON
  factory SutraProgress.fromJson(Map<String, dynamic> json) {
    return SutraProgress(
      sutraId: json['sutra_id'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      totalAttempts: json['total_attempts'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      hintsUsed: json['hints_used'] ?? 0,
      wrongAnswers: json['wrong_answers'] ?? 0,
      lastAttemptDate: json['last_attempt_date'] != null
          ? DateTime.parse(json['last_attempt_date'])
          : null,
      completedDate: json['completed_date'] != null
          ? DateTime.parse(json['completed_date'])
          : null,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sutra_id': sutraId,
      'is_completed': isCompleted,
      'total_attempts': totalAttempts,
      'correct_answers': correctAnswers,
      'hints_used': hintsUsed,
      'wrong_answers': wrongAnswers,
      'last_attempt_date': lastAttemptDate?.toIso8601String(),
      'completed_date': completedDate?.toIso8601String(),
    };
  }
  
  /// Create a copy with updated values
  SutraProgress copyWith({
    int? sutraId,
    bool? isCompleted,
    int? totalAttempts,
    int? correctAnswers,
    int? hintsUsed,
    int? wrongAnswers,
    DateTime? lastAttemptDate,
    DateTime? completedDate,
  }) {
    return SutraProgress(
      sutraId: sutraId ?? this.sutraId,
      isCompleted: isCompleted ?? this.isCompleted,
      totalAttempts: totalAttempts ?? this.totalAttempts,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      lastAttemptDate: lastAttemptDate ?? this.lastAttemptDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
