import '../data/models/auth_result_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

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
    return await _repository.updateUserProfile(user);
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
}
