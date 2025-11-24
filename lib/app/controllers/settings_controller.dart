import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/repositories/firestore_user_settings_repository.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import 'package:vedicmind/app/ui/widgets/alert_dialog_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

class SettingsController extends GetxController {
  // Acquire AuthService lazily in onInit to avoid construction-time Get.find errors
  AuthService? _authService;
  final ImagePicker _imagePicker = ImagePicker();

  // Observable variables
  final isDarkMode = false.obs;
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;
  final profileImage = Rx<File?>(null);
  final profileName = ''.obs;
  final profileEmail = ''.obs;
  final profilePhotoUrl = ''.obs;
  final isLoading = false.obs;
  final userType = 'Adult'.obs;

  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _safeInitAuthService();
    _loadSettings();
    _loadUserProfile();
  }

  void _safeInitAuthService() {
    try {
      _authService = Get.find<AuthService>();
    } catch (e) {
      debugPrint('AuthService not available yet: $e');
    }
  }

  @override
  void onClose() {
    _userDocSub?.cancel();
    nameController.dispose();
    super.onClose();
  }

  final FirestoreUserSettingsRepository _settingsRepo = FirestoreUserSettingsRepository();
  String? _userId;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userDocSub;

  Future<void> _ensureUserId() async {
    if (_authService == null) return;
    if (_userId != null) return;
    final u = await _authService!.getCurrentUser();
    _userId = u?.id;
  }

  // Load saved settings from Firestore user_settings
  Future<void> _loadSettings() async {
    try {
      await _ensureUserId();
      if (_userId == null) return;
      _settingsRepo.watch(_userId!).listen((settings) {
        isDarkMode.value = settings.isDarkMode;
        pushNotifications.value = settings.pushNotifications;
        emailNotifications.value = settings.emailNotifications;
        userType.value = settings.userType[0].toUpperCase() + settings.userType.substring(1);
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Load user profile data
  Future<void> _loadUserProfile() async {
    if (_authService == null) return; // Graceful skip if auth not ready
    try {
      final user = await _authService!.getCurrentUser();
      if (user != null) {
        // Email stays from auth (not editable here)
        profileEmail.value = user.email;

        await _ensureUserId();
        if (_userId != null) {
          _subscribeUserDoc();
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  void _subscribeUserDoc() {
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
        profileName.value = dn;
        nameController.text = dn;
      }
      if (pu is String && pu.isNotEmpty) {
        profilePhotoUrl.value = pu;
      }
    }, onError: (e) {
      debugPrint('User doc stream error: $e');
    });
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    try {
      isDarkMode.value = !isDarkMode.value;

      // Update app theme
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

      await _ensureUserId();
      if (_userId != null) {
        await _settingsRepo.toggleDarkMode(_userId!, isDarkMode.value);
      }

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
      await _ensureUserId();
      if (_userId != null) {
        await _settingsRepo.setNotificationPrefs(_userId!, push: value);
      }
    } catch (e) {
      debugPrint('Error toggling push notifications: $e');
    }
  }

  // Toggle email notifications
  Future<void> toggleEmailNotifications(bool value) async {
    try {
      emailNotifications.value = value;
      await _ensureUserId();
      if (_userId != null) {
        await _settingsRepo.setNotificationPrefs(_userId!, email: value);
      }
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
    if (_authService == null) {
      Get.snackbar('Auth', 'Auth not initialized', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // Update user profile using AuthService
      final user = await _authService!.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(
          displayName: nameController.text.trim(),
        );
        final success = await _authService!.updateUserProfile(updatedUser);

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
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(
            () => ElevatedButton(
              onPressed: isLoading.value ? null : updateProfileName,
              child: isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
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
      await _ensureUserId();
      if (_userId != null) {
        await _settingsRepo.setUserType(_userId!, type.toLowerCase());
      }
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
    if (_authService == null) {
      Get.snackbar('Auth', 'Auth not initialized', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // Update user profile using AuthService
      final user = await _authService!.getCurrentUser();
      if (user != null) {
        // 1) If a new image is selected, upload to Firebase Storage and get HTTPS URL
        String? uploadedPhotoUrl;
        if (profileImage.value != null) {
          try {
            await _ensureUserId();
            final uid = _userId ?? user.id;
              final storage = FirebaseStorage.instance;
              final ref = storage.ref().child('profile_photos').child('$uid.jpg');
              await ref.putFile(profileImage.value!);
              uploadedPhotoUrl = await ref.getDownloadURL();
          } catch (e) {
            debugPrint('Photo upload failed: $e');
          }
        }

        final updatedUser = user.copyWith(
          displayName: nameController.text.trim(),
          ageCategory: userType.value.toLowerCase(),
          photoUrl: uploadedPhotoUrl ?? user.photoUrl,
        );
        final success = await _authService!.updateUserProfile(updatedUser);

        if (success) {
          profileName.value = nameController.text.trim();

          // Save user type and keep local image path (optional)
          await _ensureUserId();
          if (_userId != null) {
            await _settingsRepo.setUserType(_userId!, userType.value.toLowerCase());
          }

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
    if (_authService == null) {
      Get.snackbar('Auth', 'Auth not initialized', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await AlertDialogUtil.showConfirmation(
        title: 'Sign Out',
        message: 'Are you sure you want to sign out?',
        confirmText: 'Sign Out',
        cancelText: 'Cancel',
        isDestructive: true,
        onConfirm: () async {
          isLoading.value = true;
          await _authService!.signOut();
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
