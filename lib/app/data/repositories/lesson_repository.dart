import '../models/lesson_model.dart';
import '../providers/lesson_provider.dart';

class LessonRepository {
  final LessonProvider _provider = LessonProvider();

  Future<List<LessonModel>> getAllLessons() => _provider.fetchAll();
}
