import '../models/vedic_course_models.dart';
import '../vedic_course_data.dart';

class VedicCourseProvider {
  VedicCourse? _cachedCourse;

  Future<VedicCourse> getCourse() async {
    if (_cachedCourse != null) {
      return _cachedCourse!;
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Parse the course data
    _cachedCourse = VedicCourse.fromJson(vedicCourseData);
    return _cachedCourse!;
  }

  Future<Chapter?> getChapter(int chapterId) async {
    final course = await getCourse();
    try {
      return course.chapters.firstWhere((ch) => ch.chapterId == chapterId);
    } catch (e) {
      return null;
    }
  }

  Future<Lesson?> getLesson(int lessonId) async {
    final course = await getCourse();
    for (var chapter in course.chapters) {
      try {
        return chapter.lessons.firstWhere((l) => l.lessonId == lessonId);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  Future<List<Chapter>> getAllChapters() async {
    final course = await getCourse();
    return course.chapters;
  }

  Future<List<Lesson>> getLessonsForChapter(int chapterId) async {
    final chapter = await getChapter(chapterId);
    return chapter?.lessons ?? [];
  }

  Future<Map<String, dynamic>> getCourseStats() async {
    final course = await getCourse();

    int totalLessons = 0;
    int totalPracticeQuestions = 0;
    int totalExamples = 0;

    for (var chapter in course.chapters) {
      totalLessons += chapter.lessons.length;
      for (var lesson in chapter.lessons) {
        totalPracticeQuestions += lesson.practice.length;
        totalExamples += lesson.examples.length;
      }
    }

    return {
      'total_chapters': course.totalChapters,
      'total_lessons': totalLessons,
      'total_practice_questions': totalPracticeQuestions,
      'total_examples': totalExamples,
      'estimated_duration': course.estimatedDuration,
    };
  }
}
