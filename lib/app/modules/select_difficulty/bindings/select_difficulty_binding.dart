import 'package:get/get.dart';
import '../controllers/select_difficulty_controller.dart';

class SelectDifficultyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectDifficultyController>(
      () => SelectDifficultyController(),
    );
  }
}