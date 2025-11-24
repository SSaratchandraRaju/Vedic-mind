import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsModel {
  final bool onboardingCompleted;
  final bool isDarkMode;
  final bool pushNotifications;
  final bool emailNotifications;
  final String userType; // 'adult' | 'kid'
  final String? profileImagePath;

  UserSettingsModel({
    required this.onboardingCompleted,
    required this.isDarkMode,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.userType,
    this.profileImagePath,
  });

  factory UserSettingsModel.defaultValues() => UserSettingsModel(
        onboardingCompleted: false,
        isDarkMode: false,
        pushNotifications: true,
        emailNotifications: true,
        userType: 'adult',
      );

  factory UserSettingsModel.fromMap(Map<String, dynamic>? data) {
    if (data == null) return UserSettingsModel.defaultValues();
    return UserSettingsModel(
      onboardingCompleted: data['onboardingCompleted'] ?? false,
      isDarkMode: data['isDarkMode'] ?? false,
      pushNotifications: data['pushNotifications'] ?? true,
      emailNotifications: data['emailNotifications'] ?? true,
      userType: (data['userType'] ?? 'adult') as String,
      profileImagePath: data['profileImagePath'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'onboardingCompleted': onboardingCompleted,
        'isDarkMode': isDarkMode,
        'pushNotifications': pushNotifications,
        'emailNotifications': emailNotifications,
        'userType': userType,
        'profileImagePath': profileImagePath,
        'updatedAt': FieldValue.serverTimestamp(),
      }..removeWhere((k, v) => v == null);

  UserSettingsModel copyWith({
    bool? onboardingCompleted,
    bool? isDarkMode,
    bool? pushNotifications,
    bool? emailNotifications,
    String? userType,
    String? profileImagePath,
  }) {
    return UserSettingsModel(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      userType: userType ?? this.userType,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}

class FirestoreUserSettingsRepository {
  final FirebaseFirestore _firestore;
  FirestoreUserSettingsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String userId) =>
      _firestore.collection('user_settings').doc(userId);

  Stream<UserSettingsModel> watch(String userId) {
    return _doc(userId).snapshots().map((snap) =>
        UserSettingsModel.fromMap(snap.data()));
  }

  Future<UserSettingsModel> fetch(String userId) async {
    final snap = await _doc(userId).get();
    return UserSettingsModel.fromMap(snap.data());
  }

  Future<void> setAll(String userId, UserSettingsModel settings) async {
    await _doc(userId).set(settings.toMap(), SetOptions(merge: true));
  }

  Future<void> updateFields(String userId, Map<String, dynamic> fields) async {
    await _doc(userId).set({...fields, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  Future<void> markOnboardingCompleted(String userId) =>
      updateFields(userId, {'onboardingCompleted': true});

  Future<void> toggleDarkMode(String userId, bool value) =>
      updateFields(userId, {'isDarkMode': value});

  Future<void> setUserType(String userId, String type) =>
      updateFields(userId, {'userType': type});

  Future<void> saveProfileImagePath(String userId, String path) =>
      updateFields(userId, {'profileImagePath': path});

  Future<void> setNotificationPrefs(String userId,
      {bool? push, bool? email}) => updateFields(userId, {
        if (push != null) 'pushNotifications': push,
        if (email != null) 'emailNotifications': email,
      });
}
