import '../models/user_model.dart';
import '../models/auth_result_model.dart';

/// Abstract interface for authentication data source
/// This allows us to swap between Firebase, MongoDB, or any other backend
abstract class AuthDataSource {
  /// Sign in with Google
  Future<AuthResultModel> signInWithGoogle();

  /// Sign in with Email and Password
  Future<AuthResultModel> signInWithEmailPassword(
    String email,
    String password,
  );

  /// Sign up with Email and Password
  Future<AuthResultModel> signUpWithEmailPassword(
    String email,
    String password,
  );

  /// Sign out
  Future<void> signOut();

  /// Get current user
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Update user profile
  Future<bool> updateUserProfile(UserModel user);

  /// Delete user account
  Future<bool> deleteAccount();

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email);

  /// Send OTP to phone number (returns verificationId or error via result model)
  Future<OtpSendResult> sendPhoneOtp(String phoneNumber);

  /// Verify OTP code with stored verificationId
  Future<AuthResultModel> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  });
}

/// Result for sending OTP (kept lightweight to avoid coupling with AuthResultModel)
class OtpSendResult {
  final String? verificationId;
  final String? error;
  final bool isSuccess;

  OtpSendResult.success(this.verificationId)
      : error = null,
        isSuccess = true;
  OtpSendResult.failure(this.error)
      : verificationId = null,
        isSuccess = false;
}
