import '../models/lesson_model.dart';

class LessonProvider {
  Future<List<LessonModel>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      LessonModel(
        id: '1',
        title: 'Addition Tricks',
        category: 'Addition',
        description: 'Quick addition techniques',
      ),
      LessonModel(
        id: '2',
        title: 'Multiplication Shortcuts',
        category: 'Multiplication',
        description: 'Fast multiplication',
      ),
    ];
  }
}
