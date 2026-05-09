import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizResultController extends GetxController {
  // --- Data Profil & Statistik ---
  final userName = 'Bale'.obs;
  final score = 85.obs;
  final totalScore = 100.obs;
  final xpEarned = 12.obs;
  final dayStreak = 5.obs;
  final readinessLevel = 0.85.obs; // 85%

  // --- Data Recommended Focus ---
  final List<Map<String, dynamic>> recommendedFocus = [
    {
      'title': 'Quantum Physics',
      'description': 'Scores dropped 15% in recent quizzes. Read: "Advanced Quantum Mechanics" - Chapter 3: Wave Mechanics (pp. 45-62).',
      'buttonText': 'Start Review',
      'color': const Color(0xFF0056FF),
      'icon': Icons.lightbulb_outline,
    },
    {
      'title': 'Organic Chemistry',
      'description': 'Struggling with Reaction Mechanisms. Study: "Organic Principles" - Chapter 4: Reaction Pathways (pp. 88-102).',
      'buttonText': 'View Materials',
      'color': const Color(0xFFD84315), // Orange
      'icon': Icons.science_outlined,
    },
    {
      'title': 'Statistics',
      'description': 'Consistently missing Probability distributions. Review: "Statistical Analysis" - Chapter 2: Discrete Distributions (pp. 24-35).',
      'buttonText': 'View Materials',
      'color': const Color(0xFFD32F2F), // Merah
      'icon': Icons.show_chart,
    },
  ];

  // --- Data Incorrect Answers ---
  final List<Map<String, dynamic>> incorrectAnswers = [
    {
      'question': 'Q7: Calculate the probability of independent events A and B.',
      'reviewReq': 'Review Required: Chapter 4: Probability Distributions',
    },
    {
      'question': 'Q14: Explain the wave-particle duality of light in the double-slit experiment.',
      'reviewReq': 'Review Required: Chapter 6: Wave Mechanics',
    },
    {
      'question': 'Q22: Identify the functional group in the provided organic molecule.',
      'reviewReq': 'Review Required: Chapter 2: Functional Groups',
    },
  ];

  void backToDashboard() {
    // Menghapus semua riwayat halaman kuis dan kembali ke dashboard
    Get.offAllNamed('/home');
  }
}