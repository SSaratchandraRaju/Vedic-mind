import 'package:get/get.dart';
import '../data/datasources/auth_data_source.dart';
import '../data/datasources/remote/firebase_auth_data_source.dart';
// import '../data/datasources/remote/mongo_auth_data_source.dart'; // Uncomment to use MongoDB
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../services/auth_service.dart';
import '../services/tts_service.dart';
import '../controllers/global_progress_controller.dart';

/// Application bindings for dependency injection
/// This is where you configure which backend to use
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ========================================
    // CONFIGURE YOUR BACKEND HERE
    // ========================================

    // OPTION 1: Use Firebase (Default)
    Get.lazyPut<AuthDataSource>(() => FirebaseAuthDataSource());

    // OPTION 2: Use MongoDB (Uncomment to switch)
    // Get.lazyPut<AuthDataSource>(() => MongoAuthDataSource());

    // OPTION 3: Use REST API (Create your own implementation)
    // Get.lazyPut<AuthDataSource>(() => RestApiAuthDataSource());

    // ========================================
    // Repository and Service (Same for all backends)
    // ========================================
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut<AuthService>(() => AuthService(Get.find()));

    // Text-to-Speech Service
    Get.put(TtsService(), permanent: true);

    // Global Progress Controller
    Get.put(GlobalProgressController(), permanent: true);
  }
}

/*
 * HOW TO SWITCH BACKENDS:
 * 
 * To switch from Firebase to MongoDB:
 * 1. Comment out: Get.lazyPut<AuthDataSource>(() => FirebaseAuthDataSource());
 * 2. Uncomment: Get.lazyPut<AuthDataSource>(() => MongoAuthDataSource());
 * 3. Implement the MongoDB methods in mongo_auth_data_source.dart
 * 4. No other code changes needed!
 * 
 * To add a new backend (e.g., Supabase, AWS, REST API):
 * 1. Create a new file: supabase_auth_data_source.dart
 * 2. Implement AuthDataSource interface
 * 3. Inject it here: Get.lazyPut<AuthDataSource>(() => SupabaseAuthDataSource());
 * 4. That's it!
 */
