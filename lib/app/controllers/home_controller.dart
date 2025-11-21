import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'global_progress_controller.dart';
import 'enhanced_vedic_course_controller.dart';
import 'vedic_course_controller.dart';

// Search Category Enum
enum SearchCategory { all, vedicSutras, vedicTactics, practice, mathTables }

// Search Result Model
class SearchResult {
  final String title;
  final String subtitle;
  final String category;
  final int? id;
  final String route;
  final dynamic data;

  SearchResult({
    required this.title,
    required this.subtitle,
    required this.category,
    this.id,
    required this.route,
    this.data,
  });
}

class HomeController extends GetxController {
  AuthService? _authService;
  final storage = GetStorage();
  final currentNavIndex = 1.obs; // Home is at index 1
  final userName = 'User'.obs;
  late final GlobalProgressController globalProgressController;

  // Method-specific stats
  final mathTablesAccuracy = 0.obs;
  final mathTablesPoints = 0.obs;
  final sutrasAccuracy = 0.obs;
  final sutrasPoints = 0.obs;
  final tacticsAccuracy = 0.obs;
  final tacticsPoints = 0.obs;
  final practiceAccuracy = 0.obs;
  final practicePoints = 0.obs;

  // Search functionality
  final selectedCategory = SearchCategory.all.obs;
  final searchQuery = ''.obs;
  final searchResults = <SearchResult>[].obs;
  final isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initAuthService();
    _loadUserName();
    _initGlobalProgress();
    _loadMethodStats();
  }

  void _loadMethodStats() {
    // Math Tables stats
    final mathTablesQ = storage.read<int>('math_tables_total_questions') ?? 0;
    final mathTablesC = storage.read<int>('math_tables_correct_answers') ?? 0;
    mathTablesPoints.value = storage.read<int>('math_tables_points') ?? 0;
    mathTablesAccuracy.value = mathTablesQ > 0
        ? ((mathTablesC / mathTablesQ) * 100).round()
        : 0;

    // Sutras stats (from practice)
    final sutrasQ = storage.read<int>('practice_sutras_questions') ?? 0;
    final sutrasC = storage.read<int>('practice_sutras_correct') ?? 0;
    sutrasPoints.value = storage.read<int>('practice_sutras_points') ?? 0;

    // Also check if sutras controller is available for additional stats
    try {
      final sutrasController = Get.find<EnhancedVedicCourseController>();
      final progress = sutrasController.overallProgress;
      final controllerPoints = progress['total_points'] as int? ?? 0;
      sutrasPoints.value += controllerPoints;
    } catch (e) {
      // Controller not available
    }

    sutrasAccuracy.value = sutrasQ > 0
        ? ((sutrasC / sutrasQ) * 100).round()
        : 0;

    // Tactics stats (from practice)
    final tacticsQ = storage.read<int>('practice_tactics_questions') ?? 0;
    final tacticsC = storage.read<int>('practice_tactics_correct') ?? 0;
    tacticsPoints.value = storage.read<int>('practice_tactics_points') ?? 0;

    // Also check tactics controller
    try {
      final tacticsController = Get.find<VedicCourseController>();
      final allLessons = tacticsController.getAllLessons();
      for (var item in allLessons) {
        if (item['lesson'].isCompleted) {
          tacticsPoints.value += 100;
        }
      }
    } catch (e) {
      // Controller not available
    }

    tacticsAccuracy.value = tacticsQ > 0
        ? ((tacticsC / tacticsQ) * 100).round()
        : 0;

    // Overall Practice stats (combining all practice types)
    final allPracticeQ = storage.read<int>('practice_total_questions') ?? 0;
    final allPracticeC = storage.read<int>('practice_correct_answers') ?? 0;
    practicePoints.value = storage.read<int>('practice_total_points') ?? 0;
    practiceAccuracy.value = allPracticeQ > 0
        ? ((allPracticeC / allPracticeQ) * 100).round()
        : 0;
  }

  void _initGlobalProgress() {
    try {
      globalProgressController = Get.find<GlobalProgressController>();
    } catch (e) {
      // Create if not found
      globalProgressController = Get.put(GlobalProgressController());
    }
    // Refresh progress when home loads
    globalProgressController.calculateOverallProgress();
  }

  void _initAuthService() {
    try {
      _authService = Get.find<AuthService>();
    } catch (e) {
      // AuthService not available, will use default username
      print('AuthService not available: $e');
    }
  }

  Future<void> _loadUserName() async {
    if (_authService == null) return;

    try {
      final user = await _authService!.getCurrentUser();
      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          userName.value = user.displayName!;
        } else if (user.email.isNotEmpty) {
          // Extract name from email (remove @gmail.com or other domains)
          final emailName = user.email.split('@')[0];
          // Capitalize first letter
          userName.value = emailName[0].toUpperCase() + emailName.substring(1);
        }
      }
    } catch (e) {
      print('Error loading user name: $e');
    }
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index)
      return; // Prevent navigation to same page

    currentNavIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
        break;
      case 1:
        // Already on home
        break;
      case 2:
        Get.offAllNamed(Routes.HISTORY);
        break;
    }
  }

  // Search functionality methods
  void onCategoryChanged(SearchCategory category) {
    selectedCategory.value = category;
    if (searchQuery.value.isNotEmpty) {
      performSearch(searchQuery.value);
    }
  }

  String getCategoryName(SearchCategory category) {
    switch (category) {
      case SearchCategory.all:
        return 'All Category';
      case SearchCategory.vedicSutras:
        return 'Vedic Sutras';
      case SearchCategory.vedicTactics:
        return 'Vedic Tactics';
      case SearchCategory.practice:
        return 'Practice';
      case SearchCategory.mathTables:
        return 'Math Tables';
    }
  }

  void performSearch(String query) {
    searchQuery.value = query.trim();
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    searchResults.clear();

    final lowerQuery = searchQuery.value.toLowerCase();

    switch (selectedCategory.value) {
      case SearchCategory.all:
        _searchAllCategories(lowerQuery);
        break;
      case SearchCategory.vedicSutras:
        _searchVedicSutras(lowerQuery);
        break;
      case SearchCategory.vedicTactics:
        _searchVedicTactics(lowerQuery);
        break;
      case SearchCategory.practice:
        _searchPractice(lowerQuery);
        break;
      case SearchCategory.mathTables:
        _searchMathTables(lowerQuery);
        break;
    }
  }

  void _searchAllCategories(String query) {
    _searchVedicSutras(query);
    _searchVedicTactics(query);
    _searchPractice(query);
    _searchMathTables(query);
  }

  void _searchVedicSutras(String query) {
    // Search in 16 Vedic Sutras
    final sutras = [
      {
        'id': 1,
        'name': 'Ekadhikena Purvena',
        'translation': 'By one more than the previous one',
      },
      {
        'id': 2,
        'name': 'Nikhilam Navatashcaramam Dashatah',
        'translation': 'All from 9 and the last from 10',
      },
      {
        'id': 3,
        'name': 'Urdhva-Tiryagbhyam',
        'translation': 'Vertically and Crosswise',
      },
      {
        'id': 4,
        'name': 'Paravartya Yojayet',
        'translation': 'Transpose and Apply',
      },
      {
        'id': 5,
        'name': 'Shunyam Saamyasamuccaye',
        'translation': 'When the sum is the same, that sum is zero',
      },
      {
        'id': 6,
        'name': 'Anurupye Shunyamanyat',
        'translation': 'If one is in ratio, the other is zero',
      },
      {
        'id': 7,
        'name': 'Sankalana-vyavakalanabhyam',
        'translation': 'By addition and subtraction',
      },
      {
        'id': 8,
        'name': 'Puranapuranabhyam',
        'translation': 'By the completion or non-completion',
      },
      {
        'id': 9,
        'name': 'Chalana-Kalanabhyam',
        'translation': 'Differences and Similarities',
      },
      {
        'id': 10,
        'name': 'Yaavadunam',
        'translation': 'Whatever the extent of its deficiency',
      },
      {'id': 11, 'name': 'Vyashtisamanstih', 'translation': 'Part and Whole'},
      {
        'id': 12,
        'name': 'Shesanyankena Charamena',
        'translation': 'The Remainders by the Last Digit',
      },
      {
        'id': 13,
        'name': 'Sopaantyadvayamantyam',
        'translation': 'The Ultimate and Twice the Penultimate',
      },
      {
        'id': 14,
        'name': 'Ekanyunena Purvena',
        'translation': 'By One Less than the Previous One',
      },
      {
        'id': 15,
        'name': 'Gunitasamuchyah',
        'translation': 'The Product of the Sum',
      },
      {
        'id': 16,
        'name': 'Gunakasamuchyah',
        'translation': 'The Factors of the Sum',
      },
    ];

    for (var sutra in sutras) {
      final name = sutra['name'] as String;
      final translation = sutra['translation'] as String;
      final id = sutra['id'] as int;

      if (name.toLowerCase().contains(query) ||
          translation.toLowerCase().contains(query) ||
          'sutra $id'.contains(query)) {
        searchResults.add(
          SearchResult(
            title: name,
            subtitle: translation,
            category: 'Vedic Sutras',
            id: id,
            route: Routes.VEDIC_16_SUTRAS,
            data: sutra,
          ),
        );
      }
    }
  }

  void _searchVedicTactics(String query) {
    // Search in Vedic Tactics/Lessons
    try {
      final tacticsController = Get.find<VedicCourseController>();
      final allLessons = tacticsController.getAllLessons();

      for (var item in allLessons) {
        final lesson = item['lesson'];
        final chapter = item['chapter'];

        if (lesson.lessonTitle.toLowerCase().contains(query) ||
            chapter.chapterTitle.toLowerCase().contains(query) ||
            lesson.lessonId.toString().contains(query)) {
          searchResults.add(
            SearchResult(
              title: lesson.lessonTitle,
              subtitle: chapter.chapterTitle,
              category: 'Vedic Tactics',
              id: lesson.lessonId,
              route: Routes.ALL_LESSONS,
              data: {'lesson': lesson, 'chapter': chapter},
            ),
          );
        }
      }
    } catch (e) {
      print('Tactics controller not available: $e');
    }
  }

  void _searchPractice(String query) {
    // Search in practice types
    final practiceTypes = [
      {
        'name': 'Sutras Practice',
        'description': 'Practice Vedic Sutras problems',
        'route': Routes.PRACTICE_SUTRAS,
      },
      {
        'name': 'Tactics Practice',
        'description': 'Practice Vedic Tactics lessons',
        'route': Routes.PRACTICE_TACTICS,
      },
      {
        'name': 'Math Tables',
        'description': 'Practice multiplication tables',
        'route': Routes.MATH_TABLES,
      },
      {
        'name': 'Arithmetic Practice',
        'description': 'General arithmetic practice',
        'route': Routes.PRACTICE_HUB,
      },
    ];

    for (var type in practiceTypes) {
      if (type['name']!.toLowerCase().contains(query) ||
          type['description']!.toLowerCase().contains(query)) {
        searchResults.add(
          SearchResult(
            title: type['name']!,
            subtitle: type['description']!,
            category: 'Practice',
            route: type['route']!,
            data: type,
          ),
        );
      }
    }
  }

  void _searchMathTables(String query) {
    // Search in math tables (2-20)
    for (int i = 2; i <= 20; i++) {
      if ('table $i'.contains(query) ||
          '$i table'.contains(query) ||
          'multiplication table $i'.contains(query) ||
          i.toString() == query) {
        searchResults.add(
          SearchResult(
            title: 'Table of $i',
            subtitle: 'Multiplication table practice',
            category: 'Math Tables',
            id: i,
            route: Routes.MATH_TABLES,
            data: {'table': i},
          ),
        );
      }
    }
  }

  void navigateToSearchResult(SearchResult result) {
    // Clear search
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;

    // Navigate to the result's route with data
    if (result.id != null) {
      Get.toNamed(
        result.route,
        arguments: {
          'scrollToId': result.id,
          'searchTerm': result.title,
          'data': result.data,
        },
      );
    } else {
      Get.toNamed(result.route);
    }
  }

  void showCategorySelector() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            ...SearchCategory.values.map((category) {
              return Obx(
                () => ListTile(
                  leading: Icon(
                    _getCategoryIcon(category),
                    color: selectedCategory.value == category
                        ? const Color(0xFF5B7FFF)
                        : Colors.grey,
                  ),
                  title: Text(
                    getCategoryName(category),
                    style: TextStyle(
                      fontWeight: selectedCategory.value == category
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: selectedCategory.value == category
                          ? const Color(0xFF5B7FFF)
                          : Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  trailing: selectedCategory.value == category
                      ? const Icon(Icons.check, color: Color(0xFF5B7FFF))
                      : null,
                  onTap: () {
                    onCategoryChanged(category);
                    Get.back();
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(SearchCategory category) {
    switch (category) {
      case SearchCategory.all:
        return Icons.apps;
      case SearchCategory.vedicSutras:
        return Icons.psychology_outlined;
      case SearchCategory.vedicTactics:
        return Icons.auto_awesome;
      case SearchCategory.practice:
        return Icons.lightbulb_outline;
      case SearchCategory.mathTables:
        return Icons.calculate_outlined;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void showPracticeDialog() {
    // Navigate directly to Practice Hub instead of showing dialog
    Get.toNamed(Routes.PRACTICE_HUB);
  }
}

class _PracticeSetupSheet extends StatelessWidget {
  final selectedOperation = 2.obs; // Default to multiplication
  final selectedTime = 1.obs; // Index of selected time
  final selectedTasks = 0.obs; // Index of selected tasks

  _PracticeSetupSheet();

  @override
  Widget build(BuildContext context) {
    // Time options in minutes
    final timeOptions = [
      {'label': '0:45', 'minutes': 0.75}, // 45 seconds
      {'label': '1:30', 'minutes': 1.5}, // 1.5 minutes
      {'label': '3:00', 'minutes': 3.0}, // 3 minutes
      {'label': '5:00', 'minutes': 5.0}, // 5 minutes
    ];
    final tasks = [5, 10, 20, 30, 50];
    final operations = [
      {'symbol': '+', 'label': 'Addition'},
      {'symbol': '−', 'label': 'Subtraction'},
      {'symbol': '×', 'label': 'Multiplication'},
      {'symbol': '÷', 'label': 'Division'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Setup Practice Session',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),

          // Operation Selection
          const Text(
            'Select Operation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => _OperationChip(
                  symbol: operations[index]['symbol'] as String,
                  label: operations[index]['label'] as String,
                  isSelected: selectedOperation.value == index,
                  onTap: () => selectedOperation.value = index,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Time Selection
          const Text(
            'Time',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => _TimeChip(
                  label: timeOptions[index]['label'] as String,
                  isSelected: selectedTime.value == index,
                  onTap: () => selectedTime.value = index,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tasks Selection
          const Text(
            'Number of Questions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => _TaskChip(
                  number: tasks[index],
                  isSelected: selectedTasks.value == index,
                  onTap: () => selectedTasks.value = index,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Start Practice Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed(
                  Routes.PRACTICE,
                  arguments: {
                    'operation': selectedOperation.value,
                    'tasks': tasks[selectedTasks.value],
                    'totalMinutes': timeOptions[selectedTime.value]['minutes'],
                    'timePerQuestion': 10, // 10 seconds per question
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B7FFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Practice',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Go Back Button
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _OperationChip extends StatelessWidget {
  final String symbol;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OperationChip({
    required this.symbol,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black54,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

class _TaskChip extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const _TaskChip({
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B7FFF) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black54,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
