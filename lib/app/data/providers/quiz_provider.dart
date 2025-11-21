import '../models/quiz_model.dart';

class QuizProvider {
  Future<List<QuizModel>> fetchSample() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      QuizModel(
        id: 'q1',
        question: 'What is 11*11?',
        options: ['121', '111', '131', '101'],
        answerIndex: 0,
      ),
    ];
  }
}
