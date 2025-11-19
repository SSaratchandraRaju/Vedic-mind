import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/datasources/remote/firebase_auth_data_source.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../services/auth_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthService dependencies are available
    if (!Get.isRegistered<AuthDataSource>()) {
      Get.lazyPut<AuthDataSource>(() => FirebaseAuthDataSource());
    }
    if (!Get.isRegistered<AuthRepository>()) {
      Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    }
    if (!Get.isRegistered<AuthService>()) {
      Get.lazyPut<AuthService>(() => AuthService(Get.find()));
    }
    
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
