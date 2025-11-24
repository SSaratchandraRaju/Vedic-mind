import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repositories/firestore_user_settings_repository.dart';
import '../services/auth_service.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final FirestoreUserSettingsRepository _settingsRepo = FirestoreUserSettingsRepository();
  AuthService? _authService;
  String? _userId;

  final List<Map<String, String>> _queuedNotifications = [];

  @override
  void onInit() {
    super.onInit();
    _initAuthAndListen();
  }

  Future<void> _initAuthAndListen() async {
    try {
      _authService = Get.find<AuthService>();
      final user = await _authService!.getCurrentUser();
      _userId = user?.id;
    } catch (_) {}
    if (_userId != null) {
      _settingsRepo.watch(_userId!).listen((settings) {
        final newMode = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
        if (themeMode.value != newMode) {
          themeMode.value = newMode;
          Get.changeThemeMode(newMode);
        }
      });
    }
  }

  void toggleTheme() {
    final newMode = themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = newMode;
    Get.changeThemeMode(newMode);
    if (_userId != null) {
      _settingsRepo.toggleDarkMode(_userId!, newMode == ThemeMode.dark);
    }
  }

  void queueNotification(String title, String body) {
    _queuedNotifications.add({'title': title, 'body': body});
  }

  List<Map<String, String>> takeQueuedNotifications() {
    final copy = List<Map<String, String>>.from(_queuedNotifications);
    _queuedNotifications.clear();
    return copy;
  }
}
