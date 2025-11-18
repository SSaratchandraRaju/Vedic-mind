import 'package:get/get.dart';
import '../data/models/user_progress_model.dart';

class ProgressController extends GetxController {
  final progress = UserProgressModel().obs;
  final isLoading = false.obs;
}
