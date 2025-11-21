import 'user_model.dart';

class AuthResultModel {
  final UserModel? user;
  final String? error;
  final bool isSuccess;

  AuthResultModel({this.user, this.error, required this.isSuccess});

  factory AuthResultModel.success(UserModel user) {
    return AuthResultModel(user: user, isSuccess: true);
  }

  factory AuthResultModel.failure(String error) {
    return AuthResultModel(error: error, isSuccess: false);
  }
}
