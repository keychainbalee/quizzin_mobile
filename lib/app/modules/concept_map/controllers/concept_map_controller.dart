import 'package:get/get.dart';

class ConceptMapController extends GetxController {
  
  void continueToQuiz() {
    // Lanjut ke halaman pemilihan tingkat kesulitan
    Get.toNamed('/select-difficulty');
  }
}