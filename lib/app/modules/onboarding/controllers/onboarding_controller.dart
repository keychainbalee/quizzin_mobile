import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;
  final _authService = Get.find<AuthService>();

  final slides = [
    {
      'title': 'Pendidikan Penting',
      'description': 'Pendidikan adalah investasi terbaik untuk masa depan. Quizzin siap menjadi teman setia perjalanan belajar akademismu.',
      'image': 'assets/images/logos/slidepicture2.png',
      'gradient': [Color(0xFF1E60E8), Color(0xFF0A349E)],
    },
    {
      'title': 'Latihan Soal Mandiri',
      'description': 'Mengasah kemampuan secara aktif lewat metode latihan soal terbukti ampuh memperkuat daya ingat dan mempercepat pemahaman.',
      'image': 'assets/images/logos/slidepicture1.png',
      'gradient': [Color(0xFF00B4DB), Color(0xFF0083B0)],
    },
    {
      'title': 'Memulai Aplikasi',
      'description': 'Mari bergabung bersama ribuan pembelajar hebat lainnya. Siapkan dirimu dan mulai kuis pertamamu bersama Quizzin sekarang!',
      'image': 'assets/images/logos/logoblue.png',
      'gradient': [Color(0xFF1E60E8), Color(0xFF0A349E)],
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() async {
    await _authService.completeOnboarding();
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
