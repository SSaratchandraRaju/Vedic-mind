import '../models/vedic_course_models.dart';
import '../providers/vedic_course_provider.dart';

class VedicCourseRepository {
  final VedicCourseProvider _provider = VedicCourseProvider();

  Future<VedicCourse> getCourse() => _provider.getCourse();

  Future<Chapter?> getChapter(int chapterId) => _provider.getChapter(chapterId);

  Future<Lesson?> getLesson(int lessonId) => _provider.getLesson(lessonId);

  Future<List<Chapter>> getAllChapters() => _provider.getAllChapters();

  Future<List<Lesson>> getLessonsForChapter(int chapterId) =>
      _provider.getLessonsForChapter(chapterId);

  Future<Map<String, dynamic>> getCourseStats() => _provider.getCourseStats();
}
