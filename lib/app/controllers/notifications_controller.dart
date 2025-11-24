import 'package:get/get.dart';
import '../data/repositories/firestore_notifications_repository.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime timestamp;
  NotificationItem({required this.title, required this.body, required this.timestamp});

  static NotificationItem fromJson(Map<String, dynamic> json) => NotificationItem(
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
}

class NotificationsController extends GetxController {
  final currentNavIndex = 2.obs; // History tab index
  final notifications = <NotificationItem>[].obs;
  final FirestoreNotificationsRepository _repo = FirestoreNotificationsRepository();
  AuthService? _authService;
  String? _userId;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      _authService = Get.find<AuthService>();
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
      if (_userId != null) {
        _repo.watchUser(_userId!).listen((list) {
          notifications.assignAll(list.map((r) => NotificationItem(
                title: r.title,
                body: r.body,
                timestamp: r.timestamp,
              )));
        });
      }
    } catch (e) {
      // Auth not ready; notifications will remain empty
    }
  }

  // Called externally when new FCM arrives
  void addNotification({required String title, required String body, bool background = false}) {
    notifications.insert(0, NotificationItem(title: title, body: body, timestamp: DateTime.now()));
    if (_userId != null) {
      _repo.addNotification(
        userId: _userId!,
        title: title,
        body: body,
        background: background,
      );
    }
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
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
