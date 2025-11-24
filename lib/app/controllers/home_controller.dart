import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'global_progress_controller.dart';
import 'vedic_course_controller.dart';
import '../data/repositories/firestore_progress_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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
  final currentNavIndex = 1.obs; // Home is at index 1
  final userName = 'User'.obs;
  final RxString userPhotoUrl = ''.obs;
  late final GlobalProgressController globalProgressController;
  final FirestoreProgressRepository _progressRepo = FirestoreProgressRepository();
  String? _userId;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSub;

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
    _subscribeAggregate();
  }

  void _loadMethodStats() {
    // Initial values set to zero; real stats arrive via Firestore aggregate stream.
  }

  void _initGlobalProgress() {
    try {
      globalProgressController = Get.find<GlobalProgressController>();
    } catch (e) {
      // Create if not found
      globalProgressController = Get.put(GlobalProgressController());
    }
    // Defer refresh to next frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalProgressController.calculateOverallProgress();
    });
  }

  void _initAuthService() {
    try {
      _authService = Get.find<AuthService>();
      _authService!.getCurrentUser().then((u) {
        _userId = u?.id;
        if (_userId != null) {
          _subscribeAggregate();
          _subscribeUserDoc();
        }
      });
    } catch (e) {
      // AuthService not available, will use default username
      print('AuthService not available: $e');
    }
  }

  void _subscribeUserDoc() {
    if (_userId == null) return;
    _userDocSub?.cancel();
    _userDocSub = FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .snapshots()
        .listen((snap) {
      final data = snap.data();
      if (data == null) return;
      final dn = data['displayName'];
      final pu = data['photoUrl'];
      if (dn is String && dn.isNotEmpty) {
        userName.value = dn;
      }
      if (pu is String && pu.isNotEmpty) {
        userPhotoUrl.value = pu;
      }
    }, onError: (e) {
      // ignore errors silently for UI
      // print('user doc stream error: $e');
    });
  }

  void _subscribeAggregate() {
    if (_userId == null) return;
    final gp = globalProgressController;
    // Fallback: mark loaded after a timeout if no snapshot arrives (e.g., offline or empty Firestore) to avoid infinite shimmer.
    if (!gp.isProgressLoaded.value) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!gp.isProgressLoaded.value) {
          gp.isProgressLoaded.value = true; // show empty stats instead of shimmer
        }
      });
    }
    _progressRepo.watchAggregate(_userId!).listen((agg) {
      // Update observable stats from remote aggregate
      mathTablesPoints.value = agg.mathTablesPoints;
      final mtQ = agg.mathTablesTotalQuestions;
      final mtC = agg.mathTablesCorrectAnswers;
      mathTablesAccuracy.value = mtQ > 0 ? ((mtC / mtQ) * 100).round() : 0;

      practicePoints.value = agg.practiceTotalPoints;
      final pQ = agg.practiceTotalQuestions;
      final pC = agg.practiceCorrectAnswers;
      practiceAccuracy.value = pQ > 0 ? ((pC / pQ) * 100).round() : 0;

      // Sutras stats from aggregate (if available) override local estimates
      sutrasPoints.value = agg.sutrasTotalPoints;
      sutrasAccuracy.value = agg.sutrasAccuracy;
  // Tactics stats from aggregate
  tacticsPoints.value = agg.tacticsTotalPoints;
  tacticsAccuracy.value = agg.tacticsAccuracy;
      if (!gp.isProgressLoaded.value) {
        gp.isProgressLoaded.value = true; // first successful aggregate
      }
    });
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
      {
        'id': 11,
        'name': 'Vyashtisamanstih',
        'translation': 'Part and Whole'
      },
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
    _userDocSub?.cancel();
    // Intentionally not disposing searchController here because the HomeView's
    // TextField may still rebuild during navigation transitions (e.g., when
    // returning from other routes or using bottom navigation) leading to
    // 'TextEditingController was used after being disposed'. In apps where
    // the controller truly goes out of scope permanently, dispose it manually
    // via Get.delete<HomeController>() after popping HomeView.
    super.onClose();
  }

  void showPracticeDialog() {
    // Navigate directly to Practice Hub instead of showing dialog
    Get.toNamed(Routes.PRACTICE_HUB);
  }
}

