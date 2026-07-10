import 'package:get/get.dart';
import 'package:quizzin/app/services/api_service.dart';
import 'package:flutter/material.dart';

class HistoryController extends GetxController {
  final ApiService _apiService = ApiService();
  final isLoading = true.obs;
  final historyList = <Map<String, dynamic>>[].obs;
  final hasError = false.obs;
  final selectedFilter = 0.obs; // 0: Semua, 1: Tinggi (>= 80), 2: Sedang (60 - 79), 3: Rendah (< 60)

  List<Map<String, dynamic>> get filteredHistoryList {
    if (selectedFilter.value == 0) return historyList;
    if (selectedFilter.value == 1) {
      return historyList.where((item) => (item['total_score'] ?? 0) >= 80).toList();
    }
    if (selectedFilter.value == 2) {
      return historyList.where((item) => (item['total_score'] ?? 0) >= 60 && (item['total_score'] ?? 0) < 80).toList();
    }
    return historyList.where((item) => (item['total_score'] ?? 0) < 60).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _apiService.dio.get('/quizzes/history');
      final data = response.data;
      
      if (data is Map && data['attempts'] is List) {
        historyList.assignAll(data['attempts'].cast<Map<String, dynamic>>());
      } else if (data is List) {
        historyList.assignAll(data.cast<Map<String, dynamic>>());
      } else {
        historyList.clear();
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
      historyList.clear();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToDetail(int attemptId) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFF0056FF))),
      barrierDismissible: false,
    );

    try {
      final response = await _apiService.dio.get('/quizzes/attempt/$attemptId');
      Get.back(); // Tutup loading
      
      final data = response.data;
      if (data != null) {
        Get.toNamed('/quiz-result', arguments: data);
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Gagal', 
        'Tidak dapat mengambil detail riwayat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
      );
    }
  }
}
