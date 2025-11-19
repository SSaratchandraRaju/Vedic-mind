import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class HomeController extends GetxController {
  AuthService? _authService;
  final currentNavIndex = 1.obs; // Home is at index 1
  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuthService();
    _loadUserName();
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
    if (currentNavIndex.value == index) return; // Prevent navigation to same page
    
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
}
