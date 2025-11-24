import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class LeaderboardUser {
  final String userId;
  final String displayName; // fallback to userId if not present
  final int totalXp;
  final int currentLevel;
  final int totalProblemsAttempted;
  final int totalProblemsCorrect;
  final int streak;
  final String? photoUrl; // nullable user avatar URL
  LeaderboardUser({
    required this.userId,
    required this.displayName,
    required this.totalXp,
    required this.currentLevel,
    required this.totalProblemsAttempted,
    required this.totalProblemsCorrect,
    required this.streak,
    this.photoUrl,
  });
}

class LeaderboardController extends GetxController {
  final selectedTab = 0.obs; // 0 = This Week, 1 = This Month
  final currentNavIndex = 0.obs; // Leaderboard is at index 0
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Top users list (ordered by total_xp desc)
  final RxList<LeaderboardUser> topUsers = <LeaderboardUser>[].obs;
  // Around current user list (subset including user +/- neighbors)
  final RxList<LeaderboardUser> aroundYou = <LeaderboardUser>[].obs;
  final RxBool loading = false.obs;
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserId();
    _subscribeLeaderboard();
  }

  Future<void> _loadCurrentUserId() async {
    if (Get.isRegistered<AuthService>()) {
      try {
        final auth = Get.find<AuthService>();
        final user = await auth.getCurrentUser();
        currentUserId = user?.id;
      } catch (e) {
        print('Leaderboard auth load error: $e');
      }
    }
  }

  void _subscribeLeaderboard() {
    loading.value = true;
    // Listen to top 50 users by total_xp
    _firestore
        .collection('user_progress')
        .orderBy('total_xp', descending: true)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
      final list = <LeaderboardUser>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        // Attempt to read nested user_core.photo_url first
        String? photoUrl;
        if (data['user_core'] is Map) {
          final uc = data['user_core'] as Map;
          final p = uc['photo_url'];
          if (p is String && p.trim().isNotEmpty) {
            photoUrl = p.trim();
          }
        }
        // Also allow legacy root-level photoUrl if ever present
        final rootP = data['photoUrl'];
        if (photoUrl == null && rootP is String && rootP.trim().isNotEmpty) {
          photoUrl = rootP.trim();
        }
        list.add(LeaderboardUser(
          userId: doc.id,
          displayName: (data['display_name'] ?? doc.id) as String,
          totalXp: (data['total_xp'] ?? 0) as int,
          currentLevel: (data['current_level'] ?? 1) as int,
          totalProblemsAttempted: (data['total_problems_attempted'] ?? 0) as int,
          totalProblemsCorrect: (data['total_problems_correct'] ?? 0) as int,
          streak: (data['streak'] ?? 0) as int,
          photoUrl: photoUrl,
        ));
      }
      topUsers.assignAll(list);
      _computeAroundYou();
      loading.value = false;
    }, onError: (e) {
      loading.value = false;
      print('Leaderboard stream error: $e');
    });
  }

  void _computeAroundYou() {
    if (currentUserId == null || topUsers.isEmpty) {
      aroundYou.assignAll(topUsers.take(7));
      return;
    }
    final index = topUsers.indexWhere((u) => u.userId == currentUserId);
    if (index == -1) {
      aroundYou.assignAll(topUsers.take(7));
      return;
    }
    final start = (index - 2).clamp(0, topUsers.length - 1);
    final end = (index + 3).clamp(0, topUsers.length);
    aroundYou.assignAll(topUsers.sublist(start, end));
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index)
      return; // Prevent navigation to same page

    currentNavIndex.value = index;

    switch (index) {
      case 0:
        // Already on leaderboard
        break;
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        Get.offAllNamed(Routes.HISTORY);
        break;
    }
  }
}
