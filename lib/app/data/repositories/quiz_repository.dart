import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';

class QuizRepository {
  final QuizProvider _provider = QuizProvider();

  Future<List<QuizModel>> getSampleQuestions() => _provider.fetchSample();
}
