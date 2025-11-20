/// Interactive Step Model with TTS Support
/// Represents a single interactive learning step with audio narration capabilities

class InteractiveStep {
  final String id;
  final int stepNumber;
  final String title;
  final String content;
  final String? ttsText; // Text for TTS narration
  final InteractionType interactionType;
  final StepVisualType visualType;
  final Map<String, dynamic>? interactionData;
  final String? animationDescription;
  final List<String>? highlightedTerms;
  
  // Progress tracking
  bool isCompleted;
  bool isRevealed;
  DateTime? completedAt;
  
  InteractiveStep({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.content,
    this.ttsText,
    required this.interactionType,
    required this.visualType,
    this.interactionData,
    this.animationDescription,
    this.highlightedTerms,
    this.isCompleted = false,
    this.isRevealed = false,
    this.completedAt,
  });
  
  /// Get the text to be read by TTS
  String get textForTTS => ttsText ?? content;
  
  factory InteractiveStep.fromJson(Map<String, dynamic> json) {
    return InteractiveStep(
      id: json['id'] as String,
      stepNumber: json['step_number'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      ttsText: json['tts_text'] as String?,
      interactionType: InteractionType.values.firstWhere(
        (e) => e.name == (json['interaction_type'] as String),
        orElse: () => InteractionType.tapToReveal,
      ),
      visualType: StepVisualType.values.firstWhere(
        (e) => e.name == (json['visual_type'] as String),
        orElse: () => StepVisualType.text,
      ),
      interactionData: json['interaction_data'] as Map<String, dynamic>?,
      animationDescription: json['animation_description'] as String?,
      highlightedTerms: json['highlighted_terms'] != null
          ? List<String>.from(json['highlighted_terms'])
          : null,
      isCompleted: json['is_completed'] as bool? ?? false,
      isRevealed: json['is_revealed'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'step_number': stepNumber,
      'title': title,
      'content': content,
      if (ttsText != null) 'tts_text': ttsText,
      'interaction_type': interactionType.name,
      'visual_type': visualType.name,
      if (interactionData != null) 'interaction_data': interactionData,
      if (animationDescription != null) 'animation_description': animationDescription,
      if (highlightedTerms != null) 'highlighted_terms': highlightedTerms,
      'is_completed': isCompleted,
      'is_revealed': isRevealed,
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }
  
  /// Mark the step as completed
  void complete() {
    isCompleted = true;
    completedAt = DateTime.now();
  }
  
  /// Reveal the step content
  void reveal() {
    isRevealed = true;
  }
}

/// Types of interactions available for learning steps
enum InteractionType {
  tapToReveal,        // Tap to show hidden content
  fillInBlank,        // Fill in the missing information
  dragAndDrop,        // Drag numbers or operations to correct places
  numberPuzzle,       // Interactive number puzzle
  calculation,        // Real-time calculation practice
  multipleChoice,     // Choose the correct answer
  slider,             // Adjust values with a slider
  animation,          // Watch an animated demonstration
  quiz,               // Mini quiz question
  practice,           // Practice problem to solve
}

/// Visual presentation types for steps
enum StepVisualType {
  text,               // Plain text content
  card,               // Card-style presentation
  calculation,        // Mathematical calculation display
  diagram,            // Visual diagram
  table,              // Data in table format
  animation,          // Animated content
  interactive,        // Interactive widget
  highlighted,        // Text with highlights
  stepByStep,         // Sequential step presentation
}

/// Challenge Model for interactive learning challenges
class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final DifficultyLevel difficulty;
  final int timeLimit; // in seconds
  final int pointsReward;
  final List<ChallengeProblem> problems;
  final String? badgeId; // Badge earned on completion
  
  // Progress
  bool isCompleted;
  int currentProblemIndex;
  int score;
  int timeElapsed;
  DateTime? startedAt;
  DateTime? completedAt;
  
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.timeLimit,
    required this.pointsReward,
    required this.problems,
    this.badgeId,
    this.isCompleted = false,
    this.currentProblemIndex = 0,
    this.score = 0,
    this.timeElapsed = 0,
    this.startedAt,
    this.completedAt,
  });
  
  double get accuracy {
    if (problems.isEmpty) return 0;
    final correctCount = problems.where((p) => p.isCorrect == true).length;
    return correctCount / problems.length;
  }
  
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: ChallengeType.values.firstWhere(
        (e) => e.name == (json['type'] as String),
        orElse: () => ChallengeType.speedDrill,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == (json['difficulty'] as String),
        orElse: () => DifficultyLevel.medium,
      ),
      timeLimit: json['time_limit'] as int,
      pointsReward: json['points_reward'] as int,
      problems: (json['problems'] as List)
          .map((p) => ChallengeProblem.fromJson(p as Map<String, dynamic>))
          .toList(),
      badgeId: json['badge_id'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      currentProblemIndex: json['current_problem_index'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      timeElapsed: json['time_elapsed'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'difficulty': difficulty.name,
      'time_limit': timeLimit,
      'points_reward': pointsReward,
      'problems': problems.map((p) => p.toJson()).toList(),
      if (badgeId != null) 'badge_id': badgeId,
      'is_completed': isCompleted,
      'current_problem_index': currentProblemIndex,
      'score': score,
      'time_elapsed': timeElapsed,
      if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }
}

enum ChallengeType {
  speedDrill,         // Solve as many as possible in time limit
  accuracyTest,       // Focus on getting all correct
  timedRace,          // Beat the clock
  survival,           // Continue until mistake
  progressive,        // Gets harder as you progress
}

enum DifficultyLevel {
  beginner,
  easy,
  medium,
  hard,
  expert,
  master,
}

/// Single problem within a challenge
class ChallengeProblem {
  final String id;
  final String problem;
  final String correctAnswer;
  final int pointValue;
  final int timeLimitSeconds;
  
  // User interaction
  String? userAnswer;
  bool? isCorrect;
  int timeSpent;
  int attempts;
  
  ChallengeProblem({
    required this.id,
    required this.problem,
    required this.correctAnswer,
    this.pointValue = 1,
    this.timeLimitSeconds = 10,
    this.userAnswer,
    this.isCorrect,
    this.timeSpent = 0,
    this.attempts = 0,
  });
  
  void submitAnswer(String answer, int elapsedTime) {
    userAnswer = answer;
    timeSpent = elapsedTime;
    attempts++;
    isCorrect = answer.trim() == correctAnswer.trim();
  }
  
  factory ChallengeProblem.fromJson(Map<String, dynamic> json) {
    return ChallengeProblem(
      id: json['id'] as String,
      problem: json['problem'] as String,
      correctAnswer: json['correct_answer'] as String,
      pointValue: json['point_value'] as int? ?? 1,
      timeLimitSeconds: json['time_limit_seconds'] as int? ?? 10,
      userAnswer: json['user_answer'] as String?,
      isCorrect: json['is_correct'] as bool?,
      timeSpent: json['time_spent'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problem': problem,
      'correct_answer': correctAnswer,
      'point_value': pointValue,
      'time_limit_seconds': timeLimitSeconds,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      'time_spent': timeSpent,
      'attempts': attempts,
    };
  }
}

/// Badge/Achievement Model
class Badge {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final BadgeCategory category;
  final BadgeTier tier;
  final int requirement;
  final int xpReward;
  
  // Progress
  bool isEarned;
  int currentProgress;
  DateTime? earnedAt;
  
  Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.category,
    required this.tier,
    required this.requirement,
    required this.xpReward,
    this.isEarned = false,
    this.currentProgress = 0,
    this.earnedAt,
  });
  
  double get progressPercentage {
    if (requirement == 0) return 0;
    return (currentProgress / requirement).clamp(0.0, 1.0);
  }
  
  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String,
      category: BadgeCategory.values.firstWhere(
        (e) => e.name == (json['category'] as String),
        orElse: () => BadgeCategory.general,
      ),
      tier: BadgeTier.values.firstWhere(
        (e) => e.name == (json['tier'] as String),
        orElse: () => BadgeTier.bronze,
      ),
      requirement: json['requirement'] as int,
      xpReward: json['xp_reward'] as int,
      isEarned: json['is_earned'] as bool? ?? false,
      currentProgress: json['current_progress'] as int? ?? 0,
      earnedAt: json['earned_at'] != null
          ? DateTime.parse(json['earned_at'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'category': category.name,
      'tier': tier.name,
      'requirement': requirement,
      'xp_reward': xpReward,
      'is_earned': isEarned,
      'current_progress': currentProgress,
      if (earnedAt != null) 'earned_at': earnedAt!.toIso8601String(),
    };
  }
}

enum BadgeCategory {
  general,
  speed,
  accuracy,
  practice,
  completion,
  streak,
  mastery,
}

enum BadgeTier {
  bronze,
  silver,
  gold,
  platinum,
  diamond,
}
