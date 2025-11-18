import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../services/firebase_auth_service.dart';

class HomeController extends GetxController {
  final FirebaseAuthService _authService = Get.find<FirebaseAuthService>();
  final currentNavIndex = 1.obs; // Home is at index 1
  final userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
  }

  void _loadUserName() {
    final user = _authService.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        userName.value = user.displayName!;
      } else if (user.email != null) {
        // Extract name from email (remove @gmail.com or other domains)
        final emailName = user.email!.split('@')[0];
        // Capitalize first letter
        userName.value = emailName[0].toUpperCase() + emailName.substring(1);
      }
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
