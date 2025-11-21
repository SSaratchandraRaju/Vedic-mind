import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'global_progress_controller.dart';

class HistoryController extends GetxController {
  final currentNavIndex = 2.obs; // History is at index 2

  // Search state
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<ProgressHistoryEntry> filtered = <ProgressHistoryEntry>[].obs;
  final RxBool isSearching = false.obs;

  late GlobalProgressController _global;

  @override
  void onInit() {
    super.onInit();
    _global = Get.find<GlobalProgressController>();
    _bindSearchListener();
  }

  void _bindSearchListener() {
    searchController.addListener(() {
      final q = searchController.text.trim();
      performSearch(q);
    });
  }

  void performSearch(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      isSearching.value = false;
      filtered.clear();
      return;
    }
    isSearching.value = true;
    final lower = query.toLowerCase();
    filtered.assignAll(_global.progressHistory.where((e) {
      return e.section.toLowerCase().contains(lower) ||
          e.description.toLowerCase().contains(lower) ||
          e.type.toLowerCase().contains(lower) ||
          e.points.toString() == lower;
    }));
  }

  void clearSearch() {
    searchController.clear();
    performSearch('');
  }

  void onNavTap(int index) {
    if (currentNavIndex.value == index) return; // Prevent navigation to same page

    currentNavIndex.value = index;

    switch (index) {
      case 0:
        Get.offAllNamed(Routes.LEADERBOARD);
        break;
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        // Already on history
        break;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
