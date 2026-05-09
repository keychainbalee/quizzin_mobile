import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPlayController extends GetxController {
  // Toggle untuk berpindah antara UI Essay dan MCQ (Hanya untuk testing UI)
  final isEssayMode = false.obs;

  // State untuk MCQ
  final selectedOption = 'B'.obs; // Default terpilih B sesuai desain

  // State untuk Essay
  final essayAnswerController = TextEditingController();

  void toggleMode() {
    isEssayMode.value = !isEssayMode.value;
  }

  void selectOption(String option) {
    selectedOption.value = option;
  }
  
  void submitQuiz() {
    
    print('Jawaban MCQ yang dipilih: ${selectedOption.value}');
    print('Jawaban Essay: ${essayAnswerController.text}');
    
    Get.offNamed('/quiz-result'); 
  }
  
  @override
  void onClose() {
    essayAnswerController.dispose();
    super.onClose();
  }
}