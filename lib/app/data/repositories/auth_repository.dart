import '../models/user_model.dart';
import '../models/auth_result_model.dart';

/// Repository interface for authentication
/// This acts as a contract that can be implemented by any backend
abstract class AuthRepository {
  Future<AuthResultModel> signInWithGoogle();
  Future<AuthResultModel> signInWithEmailPassword(String email, String password);
  Future<AuthResultModel> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<bool> updateUserProfile(UserModel user);
  Future<bool> deleteAccount();
  Future<bool> sendPasswordResetEmail(String email);
}
