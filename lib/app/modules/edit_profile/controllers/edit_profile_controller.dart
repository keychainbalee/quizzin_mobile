import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:quizzin/app/services/api_service.dart';
import 'package:quizzin/app/modules/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final levelController = TextEditingController();
  final majorController = TextEditingController();

  final isLoading = false.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      nameController.text = profileCtrl.userData['full_name'] ?? '';
      levelController.text = profileCtrl.userData['academic_level'] ?? '';
      majorController.text = profileCtrl.userData['major'] ?? '';
    }
  }

  Future<void> saveChanges() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Nama lengkap tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 100));

    isLoading.value = true;
    try {
      await _apiService.dio.put(
        '/profile',
        data: {
          "full_name": nameController.text.trim(),
          "academic_level": levelController.text.trim(),
          "major": majorController.text.trim(),
        },
      );

      _showSuccessDialog('Profil Anda berhasil diperbarui!');
    } on dio_pkg.DioException catch (e) {
      _showErrorSnackbar('Gagal Memperbarui Profil', e);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, dio_pkg.DioException error) {
    String message = error.response?.data?['detail'] ?? 'Terjadi kesalahan jaringan, silakan coba lagi';
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
    );
  }

  void _showSuccessDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF10B981),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Berhasil Disimpan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to main profile page
                    if (Get.isRegistered<ProfileController>()) {
                      Get.find<ProfileController>().fetchProfile(); // Refresh profile info
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    levelController.dispose();
    majorController.dispose();
    super.onClose();
  }
}
