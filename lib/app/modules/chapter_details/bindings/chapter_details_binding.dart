import 'package:get/get.dart';
import 'package:quizzin/app/modules/chapter_details/controllers/chapter_details_controller.dart';

class ChapterDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChapterDetailsController>(
      () => ChapterDetailsController(),
    );
  }
}