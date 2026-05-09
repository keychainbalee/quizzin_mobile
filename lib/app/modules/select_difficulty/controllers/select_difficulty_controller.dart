import 'package:get/get.dart';

class SelectDifficultyController extends GetxController {
  // State untuk menyimpan level yang dipilih (default: medium)
  final selectedDifficulty = 'medium'.obs; 

  void selectLevel(String level) {
    selectedDifficulty.value = level;
  }

  void startQuiz() {
    // Logika ketika tombol Start Quiz ditekan
    // Nanti akan diarahkan ke halaman kuis
    print('Memulai quiz dengan level: ${selectedDifficulty.value}');
    // Get.toNamed('/quiz-play');
  }
}