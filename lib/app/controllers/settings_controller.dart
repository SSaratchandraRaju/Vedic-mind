import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import '../widgets/common/alert_dialog_util.dart';

class SettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Observable variables
  final isDarkMode = false.obs;
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;
  final profileImage = Rx<File?>(null);
  final profileName = ''.obs;
  final profileEmail = ''.obs;
  final isLoading = false.obs;
  final userType = 'Adult'.obs;

  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      pushNotifications.value = prefs.getBool('pushNotifications') ?? true;
      emailNotifications.value = prefs.getBool('emailNotifications') ?? true;
      userType.value = prefs.getString('userType') ?? 'Adult';
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Load user profile data
  Future<void> _loadUserProfile() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        profileName.value = user.displayName ?? 'User';
        profileEmail.value = user.email;
        nameController.text = profileName.value;
        
        // Load saved profile image path from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final savedImagePath = prefs.getString('profileImagePath');
        if (savedImagePath != null && savedImagePath.isNotEmpty) {
          profileImage.value = File(savedImagePath);
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    try {
      isDarkMode.value = !isDarkMode.value;
      
      // Update app theme
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDarkMode.value);
      
      Get.snackbar(
        'Theme Updated',
        'Theme changed to ${isDarkMode.value ? 'Dark' : 'Light'} mode',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error toggling theme: $e');
    }
  }

  // Toggle push notifications
  Future<void> togglePushNotifications(bool value) async {
    try {
      pushNotifications.value = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pushNotifications', value);
    } catch (e) {
      debugPrint('Error toggling push notifications: $e');
    }
  }

  // Toggle email notifications
  Future<void> toggleEmailNotifications(bool value) async {
    try {
      emailNotifications.value = value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('emailNotifications', value);
    } catch (e) {
      debugPrint('Error toggling email notifications: $e');
    }
  }

  // Pick profile image from gallery
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        
        // Save image path to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', image.path);
        
        Get.snackbar(
          'Success',
          'Profile image updated',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Update profile name
  Future<void> updateProfileName() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Update user profile using AuthService
      final user = await _authService.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(displayName: nameController.text.trim());
        final success = await _authService.updateUserProfile(updatedUser);
        
        if (success) {
          profileName.value = nameController.text.trim();
          
          Get.back(); // Close dialog
          Get.snackbar(
            'Success',
            'Profile name updated',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to update name',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update name: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show edit profile dialog
  void showEditProfileDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: pickProfileImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Change Profile Picture'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value ? null : updateProfileName,
                child: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              )),
        ],
      ),
    );
  }

  // Navigate to edit profile screen
  void navigateToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  // Set user type
  Future<void> setUserType(String type) async {
    try {
      userType.value = type;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', type);
    } catch (e) {
      debugPrint('Error setting user type: $e');
    }
  }

  // Save profile
  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // Update user profile using AuthService
      final user = await _authService.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(
          displayName: nameController.text.trim(),
          ageCategory: userType.value.toLowerCase(),
        );
        final success = await _authService.updateUserProfile(updatedUser);
        
        if (success) {
          profileName.value = nameController.text.trim();
          
          // Save user type
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userType', userType.value);
          
          Get.back(); // Close edit profile screen
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to update profile',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await AlertDialogUtil.showConfirmation(
        title: 'Sign Out',
        message: 'Are you sure you want to sign out?',
        confirmText: 'Sign Out',
        cancelText: 'Cancel',
        isDestructive: true,
        onConfirm: () async {
          isLoading.value = true;
          await _authService.signOut();
          isLoading.value = false;
          
          // Navigate to login screen and clear navigation stack
          Get.offAllNamed(Routes.LOGIN);
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
