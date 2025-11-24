import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/datasources/remote/firebase_auth_data_source.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../services/auth_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure Auth dependencies exist here too (Edit Profile may be opened directly)
    if (!Get.isRegistered<AuthDataSource>()) {
      Get.lazyPut<AuthDataSource>(() => FirebaseAuthDataSource());
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    }
    if (!Get.isRegistered<AuthService>()) {
      Get.lazyPut<AuthService>(() => AuthService(Get.find()));
    }
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
