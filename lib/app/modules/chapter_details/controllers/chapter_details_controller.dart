import 'package:get/get.dart';

class ChapterDetailsController extends GetxController {
  // Data dokumen
  final documentTitle = 'ADVANCED CALCULUS.PDF'.obs;

  // Data list chapter
  final List<Map<String, dynamic>> chapters = [
    {
      'chapter': 'CHAPTER 1',
      'title': 'Limits and Continuity',
      'mastery': 1.0, // 100%
      'status': 'mastered', 
    },
    {
      'chapter': 'CHAPTER 2',
      'title': 'Derivatives and Rates of Change',
      'mastery': 0.65, // 65%
      'status': 'in_progress',
    },
    {
      'chapter': 'CHAPTER 3',
      'title': 'Applications of Differentiation',
      'mastery': 0.0, // 0%
      'status': 'locked',
    },
    {
      'chapter': 'CHAPTER 4',
      'title': 'Integrals and Fundamental Theorem',
      'mastery': 0.0,
      'status': 'locked',
    },
    {
      'chapter': 'CHAPTER 5',
      'title': 'Techniques of Integration',
      'mastery': 0.0,
      'status': 'locked',
    },
  ];

  void goToConceptMap() {
    Get.toNamed('/concept-map'); 
  }
}