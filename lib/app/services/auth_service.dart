import '../data/models/auth_result_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/repositories/firestore_progress_repository.dart';

/// Authentication Service
/// This handles business logic and uses the repository
class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  /// Sign in with Google
  Future<AuthResultModel> signInWithGoogle() async {
    return await _repository.signInWithGoogle();
  }

  /// Sign in with email and password
  Future<AuthResultModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Add validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResultModel.failure('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      return AuthResultModel.failure('Invalid email format');
    }

    return await _repository.signInWithEmailPassword(email, password);
  }

  /// Sign up with email and password
  Future<AuthResultModel> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // Add validation
    if (email.isEmpty || password.isEmpty) {
      return AuthResultModel.failure('Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      return AuthResultModel.failure('Invalid email format');
    }

    if (password.length < 6) {
      return AuthResultModel.failure('Password must be at least 6 characters');
    }

    return await _repository.signUpWithEmailPassword(email, password);
  }

  /// Send phone OTP
  Future<OtpSendResult> sendPhoneOtp(String phoneNumber) async {
    final normalized = phoneNumber.trim();
    if (normalized.isEmpty) {
      return OtpSendResult.failure('Phone number is required');
    }
    if (!_isLikelyPhone(normalized)) {
      return OtpSendResult.failure('Invalid phone number format');
    }
    return await _repository.sendPhoneOtp(normalized);
  }

  /// Verify phone OTP
  Future<AuthResultModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (verificationId.isEmpty) {
      return AuthResultModel.failure('Missing verification session');
    }
    if (smsCode.trim().length < 4) { // allow variable length (4-6)
      return AuthResultModel.failure('OTP code too short');
    }
    return await _repository.verifyPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _repository.signOut();
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _repository.isAuthenticated();
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserModel user) async {
    final ok = await _repository.updateUserProfile(user);
    if (ok) {
      try {
        await FirestoreProgressRepository().updateUserCore(
          userId: user.id,
          displayName: user.displayName,
          photoUrl: user.photoUrl,
        );
      } catch (e) {
        // ignore: avoid_print
        print('[auth_service] user_core update failed: $e');
      }
    }
    return ok;
  }

  /// Update age category
  Future<bool> updateAgeCategory(String ageCategory) async {
    final user = await getCurrentUser();
    if (user == null) return false;

    final updatedUser = user.copyWith(ageCategory: ageCategory);
    return await updateUserProfile(updatedUser);
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    return await _repository.deleteAccount();
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    if (!_isValidEmail(email)) {
      return false;
    }

    return await _repository.sendPasswordResetEmail(email);
  }

  /// Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isLikelyPhone(String phone) {
    // Basic heuristic: digits plus optional +, length between 7 and 15 digits
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 7 && digits.length <= 15;
  }
}
