import '../datasources/auth_data_source.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Implementation of AuthRepository
/// This uses the injected data source (can be Firebase, MongoDB, etc.)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthResultModel> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<AuthResultModel> signInWithEmailPassword(
    String email,
    String password,
  ) {
    return _dataSource.signInWithEmailPassword(email, password);
  }

  @override
  Future<AuthResultModel> signUpWithEmailPassword(
    String email,
    String password,
  ) {
    return _dataSource.signUpWithEmailPassword(email, password);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Future<bool> isAuthenticated() {
    return _dataSource.isAuthenticated();
  }

  @override
  Future<bool> updateUserProfile(UserModel user) {
    return _dataSource.updateUserProfile(user);
  }

  @override
  Future<bool> deleteAccount() {
    return _dataSource.deleteAccount();
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) {
    return _dataSource.sendPasswordResetEmail(email);
  }
}
