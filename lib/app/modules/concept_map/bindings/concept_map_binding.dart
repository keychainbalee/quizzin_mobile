import 'package:get/get.dart';
import 'package:quizzin/app/modules/concept_map/controllers/concept_map_controller.dart';

class ConceptMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConceptMapController>(
      () => ConceptMapController(),
    );
  }
}
