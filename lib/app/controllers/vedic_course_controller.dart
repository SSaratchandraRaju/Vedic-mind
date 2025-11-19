import 'package:get/get.dart';
import '../data/models/vedic_course_models.dart';
import '../data/repositories/vedic_course_repository.dart';

class VedicCourseController extends GetxController {
  final VedicCourseRepository _repository = VedicCourseRepository();

  final course = Rxn<VedicCourse>();
  final chapters = <Chapter>[].obs;
  final currentChapter = Rxn<Chapter>();
  final currentLesson = Rxn<Lesson>();
  final isLoading = false.obs;
  final userProgress = Rxn<UserProgress>();

  @override
  void onInit() {
    super.onInit();
    loadCourse();
  }

  Future<void> loadCourse() async {
    try {
      isLoading.value = true;
      final loadedCourse = await _repository.getCourse();
      course.value = loadedCourse;
      chapters.value = loadedCourse.chapters;
      
      // Initialize user progress (in real app, load from Firebase)
      userProgress.value = UserProgress(userId: 'current_user');
    } catch (e, stackTrace) {
      print('Error loading course: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar('Error', 'Failed to load course: $e',
        duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadChapter(int chapterId) async {
    try {
      isLoading.value = true;
      final chapter = await _repository.getChapter(chapterId);
      currentChapter.value = chapter;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load chapter: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLesson(int lessonId) async {
    try {
      isLoading.value = true;
      final lesson = await _repository.getLesson(lessonId);
      currentLesson.value = lesson;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load lesson: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void completeLesson(int lessonId) {
    if (userProgress.value != null) {
      userProgress.value!.completedLessons[lessonId] = true;
      
      // Update the actual lesson object's isCompleted flag
      for (var chapter in chapters) {
        for (var lesson in chapter.lessons) {
          if (lesson.lessonId == lessonId) {
            lesson.isCompleted = true;
            
            // Unlock next lesson if exists
            final lessonIndex = chapter.lessons.indexOf(lesson);
            if (lessonIndex < chapter.lessons.length - 1) {
              chapter.lessons[lessonIndex + 1].isUnlocked = true;
            }
            break;
          }
        }
      }
      
      userProgress.refresh();
      
      // Update chapter progress
      updateChapterProgress();
      
      // Check for achievements
      checkAchievements();
      
      // In real app, save to Firebase
      saveProgressToFirebase();
    }
  }

  void recordPracticeAttempt(bool isCorrect) {
    if (userProgress.value != null) {
      userProgress.value!.totalProblemsAttempted++;
      if (isCorrect) {
        userProgress.value!.totalProblemsCorrect++;
      }
      userProgress.refresh();
    }
  }

  void updateChapterProgress() {
    for (var chapter in chapters) {
      chapter.updateProgress();
    }
    chapters.refresh();
  }

  void checkAchievements() {
    // Check various achievement conditions
    final progress = userProgress.value;
    if (progress == null) return;

    List<String> newBadges = [];

    // First Lesson
    if (progress.completedLessons.isNotEmpty && 
        !progress.earnedBadges.contains('first_lesson')) {
      newBadges.add('first_lesson');
    }

    // 50 Problems
    if (progress.totalProblemsAttempted >= 50 && 
        !progress.earnedBadges.contains('50_problems')) {
      newBadges.add('50_problems');
    }

    // 90% Club
    if (progress.overallAccuracy >= 0.9 && 
        progress.totalProblemsAttempted >= 100 &&
        !progress.earnedBadges.contains('90_club')) {
      newBadges.add('90_club');
    }

    // Add new badges
    for (var badge in newBadges) {
      progress.earnedBadges.add(badge);
      showBadgeEarned(badge);
    }

    if (newBadges.isNotEmpty) {
      userProgress.refresh();
    }
  }

  void showBadgeEarned(String badgeId) {
    final badgeNames = {
      'first_lesson': '🌟 First Lesson Complete!',
      '50_problems': '⭐ 50 Problems Solved!',
      '90_club': '🏆 90% Club Member!',
      'chapter_complete': '📚 Chapter Complete!',
      'speed_demon': '⚡ Speed Demon!',
    };

    Get.snackbar(
      'Achievement Unlocked!',
      badgeNames[badgeId] ?? 'New Badge Earned!',
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> saveProgressToFirebase() async {
    // TODO: Implement Firebase save
    // await FirebaseFirestore.instance
    //     .collection('user_progress')
    //     .doc(userProgress.value?.userId)
    //     .set(userProgress.value!.toJson());
  }

  double getOverallProgress() {
    final progress = userProgress.value;
    if (progress == null || chapters.isEmpty) return 0.0;

    int totalLessons = 0;
    for (var chapter in chapters) {
      totalLessons += chapter.lessons.length;
    }

    if (totalLessons == 0) return 0.0;
    return progress.completedLessons.length / totalLessons;
  }

  double getChapterProgress(int chapterId) {
    final chapter = chapters.firstWhere(
      (ch) => ch.chapterId == chapterId,
      orElse: () => chapters.first,
    );
    return chapter.progress;
  }

  bool isLessonCompleted(int lessonId) {
    return userProgress.value?.completedLessons[lessonId] ?? false;
  }

  int getLessonScore(int lessonId) {
    return userProgress.value?.lessonScores[lessonId] ?? 0;
  }
}
