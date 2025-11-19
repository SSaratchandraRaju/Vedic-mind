// Comprehensive Data Models for Vedic Mathematics Course

class VedicCourse {
  final String courseTitle;
  final String description;
  final int totalChapters;
  final String estimatedDuration;
  final String difficulty;
  final List<Chapter> chapters;

  VedicCourse({
    required this.courseTitle,
    required this.description,
    required this.totalChapters,
    required this.estimatedDuration,
    required this.difficulty,
    required this.chapters,
  });

  factory VedicCourse.fromJson(Map<String, dynamic> json) {
    return VedicCourse(
      courseTitle: json['course_title'] as String,
      description: json['description'] as String,
      totalChapters: json['total_chapters'] as int,
      estimatedDuration: json['estimated_duration'] as String,
      difficulty: json['difficulty'] as String,
      chapters: (json['chapters'] as List)
          .map((chapter) => Chapter.fromJson(chapter as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'description': description,
      'total_chapters': totalChapters,
      'estimated_duration': estimatedDuration,
      'difficulty': difficulty,
      'chapters': chapters.map((c) => c.toJson()).toList(),
    };
  }
}

class Chapter {
  final int chapterId;
  final String chapterTitle;
  final String chapterDescription;
  final String icon;
  final String color;
  final List<Lesson> lessons;
  
  // Progress tracking
  int completedLessons;
  double progress;

  Chapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.chapterDescription,
    required this.icon,
    required this.color,
    required this.lessons,
    this.completedLessons = 0,
    this.progress = 0.0,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapter_id'] as int,
      chapterTitle: json['chapter_title'] as String,
      chapterDescription: json['chapter_description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      lessons: (json['lessons'] as List)
          .map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_id': chapterId,
      'chapter_title': chapterTitle,
      'chapter_description': chapterDescription,
      'icon': icon,
      'color': color,
      'lessons': lessons.map((l) => l.toJson()).toList(),
    };
  }

  void updateProgress() {
    completedLessons = lessons.where((l) => l.isCompleted).length;
    progress = lessons.isEmpty ? 0 : completedLessons / lessons.length;
  }
}

class Lesson {
  final int lessonId;
  final String lessonTitle;
  final String objective;
  final int durationMinutes;
  final String content;
  final List<Example> examples;
  final List<PracticeQuestion> practice;
  final String summary;
  
  // Progress tracking
  bool isCompleted;
  bool isUnlocked;
  int score;
  DateTime? lastAttempted;

  Lesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.objective,
    required this.durationMinutes,
    required this.content,
    required this.examples,
    required this.practice,
    required this.summary,
    this.isCompleted = false,
    this.isUnlocked = true,
    this.score = 0,
    this.lastAttempted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'] as int,
      lessonTitle: json['lesson_title'] as String,
      objective: json['objective'] as String,
      durationMinutes: json['duration_minutes'] as int,
      content: json['content'] as String,
      examples: (json['examples'] as List)
          .map((ex) => Example.fromJson(ex as Map<String, dynamic>))
          .toList(),
      practice: (json['practice'] as List)
          .map((pr) => PracticeQuestion.fromJson(pr as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lesson_title': lessonTitle,
      'objective': objective,
      'duration_minutes': durationMinutes,
      'content': content,
      'examples': examples.map((e) => e.toJson()).toList(),
      'practice': practice.map((p) => p.toJson()).toList(),
      'summary': summary,
    };
  }
}

class Example {
  final String? problem;
  final String? solution;
  final String? explanation;
  final String? verification;
  
  // Additional fields for varied example types
  final String? method;
  final String? working;
  final String? step1;
  final String? step2;
  final String? step3;
  final String? step4;
  final String? answer;
  final List<String>? steps;
  final String? traditional;
  final String? vedic;
  final String? calculation;
  final String? exercise;
  final String? numbers;
  final String? base;
  final String? check;
  final String? level;
  final List<String>? problems;
  final List<String>? answers;
  final String? targetTime;
  final List<String>? techniques; // Changed from String? to List<String>?
  final String? adjust;
  final String? estimate;
  final String? actual;
  final String? round;
  final String? refine;
  final String? drillName;
  final int? timeLimit;
  final String? scoring;

  Example({
    this.problem,
    this.solution,
    this.explanation,
    this.verification,
    this.method,
    this.working,
    this.step1,
    this.step2,
    this.step3,
    this.step4,
    this.answer,
    this.steps,
    this.traditional,
    this.vedic,
    this.calculation,
    this.exercise,
    this.numbers,
    this.base,
    this.check,
    this.level,
    this.problems,
    this.answers,
    this.targetTime,
    this.techniques,
    this.adjust,
    this.estimate,
    this.actual,
    this.round,
    this.refine,
    this.drillName,
    this.timeLimit,
    this.scoring,
  });

  factory Example.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse steps, problems, and answers which could be String or List
    List<String>? _parseStringList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return List<String>.from(value);
      }
      if (value is String) {
        return [value]; // Wrap single string in a list
      }
      return null;
    }

    // Helper function to safely parse time_limit which could be int or String
    int? _parseTimeLimit(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) {
        // Try to extract number from strings like "60 seconds"
        final match = RegExp(r'\d+').firstMatch(value);
        if (match != null) {
          return int.tryParse(match.group(0)!);
        }
      }
      return null;
    }

    return Example(
      problem: json['problem'] as String?,
      solution: json['solution'] as String?,
      explanation: json['explanation'] as String?,
      verification: json['verification'] as String?,
      method: json['method'] as String?,
      working: json['working'] as String?,
      step1: json['step1'] as String?,
      step2: json['step2'] as String?,
      step3: json['step3'] as String?,
      step4: json['step4'] as String?,
      answer: json['answer'] as String?,
      steps: _parseStringList(json['steps']),
      traditional: json['traditional'] as String?,
      vedic: json['vedic'] as String?,
      calculation: json['calculation'] as String?,
      exercise: json['exercise'] as String?,
      numbers: json['numbers'] as String?,
      base: json['base'] as String?,
      check: json['check'] as String?,
      level: json['level'] as String?,
      problems: _parseStringList(json['problems']),
      answers: _parseStringList(json['answers']),
      targetTime: json['target_time'] as String?,
      techniques: _parseStringList(json['techniques']),
      adjust: json['adjust'] as String?,
      estimate: json['estimate'] as String?,
      actual: json['actual'] as String?,
      round: json['round'] as String?,
      refine: json['refine'] as String?,
      drillName: json['drill_name'] as String?,
      timeLimit: _parseTimeLimit(json['time_limit']),
      scoring: json['scoring'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (problem != null) json['problem'] = problem;
    if (solution != null) json['solution'] = solution;
    if (explanation != null) json['explanation'] = explanation;
    if (verification != null) json['verification'] = verification;
    if (method != null) json['method'] = method;
    if (working != null) json['working'] = working;
    if (step1 != null) json['step1'] = step1;
    if (step2 != null) json['step2'] = step2;
    if (step3 != null) json['step3'] = step3;
    if (step4 != null) json['step4'] = step4;
    if (answer != null) json['answer'] = answer;
    if (steps != null) json['steps'] = steps;
    if (traditional != null) json['traditional'] = traditional;
    if (vedic != null) json['vedic'] = vedic;
    if (calculation != null) json['calculation'] = calculation;
    if (exercise != null) json['exercise'] = exercise;
    if (numbers != null) json['numbers'] = numbers;
    if (base != null) json['base'] = base;
    if (check != null) json['check'] = check;
    if (level != null) json['level'] = level;
    if (problems != null) json['problems'] = problems;
    if (answers != null) json['answers'] = answers;
    if (targetTime != null) json['target_time'] = targetTime;
    if (techniques != null) json['techniques'] = techniques;
    if (adjust != null) json['adjust'] = adjust;
    if (estimate != null) json['estimate'] = estimate;
    if (actual != null) json['actual'] = actual;
    if (round != null) json['round'] = round;
    if (refine != null) json['refine'] = refine;
    if (drillName != null) json['drill_name'] = drillName;
    if (timeLimit != null) json['time_limit'] = timeLimit;
    if (scoring != null) json['scoring'] = scoring;
    return json;
  }
}

class PracticeQuestion {
  final String question;
  final String type; // 'input', 'multiple_choice', 'fill_blank', 'timed_set'
  final String answer;
  final List<String>? options;
  final String? hint;
  final int? timeLimit;
  final String? difficulty;
  final List<String>? problems;
  
  // User response tracking
  String? userAnswer;
  bool? isCorrect;
  int attemptTime;

  PracticeQuestion({
    required this.question,
    required this.type,
    required this.answer,
    this.options,
    this.hint,
    this.timeLimit,
    this.difficulty,
    this.problems,
    this.userAnswer,
    this.isCorrect,
    this.attemptTime = 0,
  });

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      question: json['question'] as String? ?? '',
      type: json['type'] as String? ?? 'input',
      answer: json['answer'] as String? ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      hint: json['hint'] as String?,
      timeLimit: json['time_limit'] as int?,
      difficulty: json['difficulty'] as String?,
      problems: json['problems'] != null ? List<String>.from(json['problems']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'type': type,
      'answer': answer,
      if (options != null) 'options': options,
      if (hint != null) 'hint': hint,
      if (timeLimit != null) 'time_limit': timeLimit,
      if (difficulty != null) 'difficulty': difficulty,
      if (problems != null) 'problems': problems,
    };
  }

  void checkAnswer(String userResponse) {
    userAnswer = userResponse;
    isCorrect = userAnswer?.trim().toLowerCase() == answer.trim().toLowerCase();
  }
}

class UserProgress {
  final String userId;
  int currentChapterId;
  int currentLessonId;
  final Map<int, bool> completedLessons;
  final Map<int, int> lessonScores;
  int totalProblemsAttempted;
  int totalProblemsCorrect;
  DateTime lastStudyDate;
  int studyStreak;
  final List<String> earnedBadges;
  
  UserProgress({
    required this.userId,
    this.currentChapterId = 1,
    this.currentLessonId = 101,
    Map<int, bool>? completedLessons,
    Map<int, int>? lessonScores,
    this.totalProblemsAttempted = 0,
    this.totalProblemsCorrect = 0,
    DateTime? lastStudyDate,
    this.studyStreak = 0,
    List<String>? earnedBadges,
  })  : completedLessons = completedLessons ?? {},
        lessonScores = lessonScores ?? {},
        lastStudyDate = lastStudyDate ?? DateTime.now(),
        earnedBadges = earnedBadges ?? [];

  double get overallAccuracy {
    if (totalProblemsAttempted == 0) return 0;
    return totalProblemsCorrect / totalProblemsAttempted;
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'] as String,
      currentChapterId: json['current_chapter_id'] as int? ?? 1,
      currentLessonId: json['current_lesson_id'] as int? ?? 101,
      completedLessons: json['completed_lessons'] != null
          ? Map<int, bool>.from(json['completed_lessons'])
          : {},
      lessonScores: json['lesson_scores'] != null
          ? Map<int, int>.from(json['lesson_scores'])
          : {},
      totalProblemsAttempted: json['total_problems_attempted'] as int? ?? 0,
      totalProblemsCorrect: json['total_problems_correct'] as int? ?? 0,
      lastStudyDate: json['last_study_date'] != null
          ? DateTime.parse(json['last_study_date'])
          : DateTime.now(),
      studyStreak: json['study_streak'] as int? ?? 0,
      earnedBadges: json['earned_badges'] != null
          ? List<String>.from(json['earned_badges'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'current_chapter_id': currentChapterId,
      'current_lesson_id': currentLessonId,
      'completed_lessons': completedLessons,
      'lesson_scores': lessonScores,
      'total_problems_attempted': totalProblemsAttempted,
      'total_problems_correct': totalProblemsCorrect,
      'last_study_date': lastStudyDate.toIso8601String(),
      'study_streak': studyStreak,
      'earned_badges': earnedBadges,
    };
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category; // 'beginner', 'intermediate', 'advanced', 'master'
  final int requirement;
  
  bool isEarned;
  int currentProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.requirement,
    this.isEarned = false,
    this.currentProgress = 0,
  });

  double get progressPercentage {
    if (requirement == 0) return 0;
    return (currentProgress / requirement).clamp(0.0, 1.0);
  }
}
