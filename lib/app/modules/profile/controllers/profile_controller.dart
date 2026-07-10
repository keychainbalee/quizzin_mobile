import 'dart:async';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quizzin/app/services/api_service.dart';
import 'package:quizzin/app/services/auth_service.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final levelController = TextEditingController();
  final majorController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isFetchingProfile = true.obs;
  final hasError = false.obs;
  final isLoading = false.obs;

  final isDailyReminderEnabled = true.obs;
  final isStreakAlertEnabled = true.obs;
  final isNewMaterialAlertEnabled = true.obs;

  final profilePicUrl = ''.obs;
  final userData = <String, dynamic>{}.obs;

  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    fetchProfile();
    loadNotificationSettings();
  }

  Future<void> loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDailyReminderEnabled.value = prefs.getBool('daily_reminder') ?? true;
      isStreakAlertEnabled.value = prefs.getBool('streak_alert') ?? true;
      isNewMaterialAlertEnabled.value = prefs.getBool('new_material_alert') ?? true;
    } catch (e) {
      debugPrint('Error loading notification settings: $e');
    }
  }

  Future<void> toggleDailyReminder(bool value) async {
    isDailyReminderEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
  }

  Future<void> toggleStreakAlert(bool value) async {
    isStreakAlertEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streak_alert', value);
  }

  Future<void> toggleNewMaterialAlert(bool value) async {
    isNewMaterialAlertEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('new_material_alert', value);
  }

  Future<void> fetchProfile() async {
    isFetchingProfile.value = true;
    hasError.value = false;

    try {
      final response = await _apiService.dio
          .get('/profile')
          .timeout(const Duration(seconds: 5));
      userData.value = response.data as Map<String, dynamic>;

      nameController.text = userData['full_name'] ?? '';
      emailController.text = userData['email'] ?? '';
      levelController.text = userData['academic_level'] ?? '';
      majorController.text = userData['major'] ?? '';

      profilePicUrl.value =
          userData['avatar_url'] ??
          'https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png';
    } catch (e) {
      hasError.value = true;
      if (e is TimeoutException) {
        Get.snackbar(
          'Waktu Habis',
          'Server terlalu lama merespons. Silakan coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      } else if (e is dio_pkg.DioException) {
        _showErrorSnackbar('Gagal Memuat Profil', e);
      }
    } finally {
      isFetchingProfile.value = false;
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
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); 

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

  Future<void> changePassword() async {
    final currentPw = currentPasswordController.text;
    final newPw = newPasswordController.text;
    final confirmPw = confirmPasswordController.text;

    if (currentPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Semua kolom password wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    if (newPw != confirmPw) {
      Get.snackbar(
        'Validasi Gagal',
        'Password baru dan konfirmasi tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
      );
      return;
    }

    isLoading.value = true;
    try {
      await _apiService.dio.put(
        '/profile/change-password',
        data: {"current_password": currentPw, "new_password": newPw},
      );

      clearPasswordFields();
      _showSuccessDialog('Kata sandi Anda berhasil diperbarui!');
    } on dio_pkg.DioException catch (e) {
      _showErrorSnackbar('Gagal Mengubah Password', e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearPasswordFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> updatePhoto(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        imageQuality: 90,
      );
      if (pickedFile == null) return;

      // Crop image using image_cropper package
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto Profil',
            toolbarColor: const Color(0xFF0056FF),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            cropStyle: CropStyle.circle, // Circular crop
          ),
          IOSUiSettings(
            title: 'Crop Foto Profil',
            cropStyle: CropStyle.circle, // Circular crop
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return;
      final String croppedPath = croppedFile.path;

      isLoading.value = true;
      String fileName = croppedPath.split('/').last;
      dio_pkg.FormData formData = dio_pkg.FormData.fromMap({
        "file": await dio_pkg.MultipartFile.fromFile(
          croppedPath,
          filename: fileName,
        ),
      });

      await _apiService.dio.put('/profile/avatar', data: formData);
      Get.snackbar(
        'Foto Diperbarui',
        'Foto profil baru berhasil diunggah!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0056FF),
        colorText: Colors.white,
      );

      fetchProfile();
    } on dio_pkg.DioException catch (e) {
      _showErrorSnackbar('Gagal Mengunggah Foto', e);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _authService.clearAuth();
    _apiService.clearAuthToken();
    Get.offAllNamed('/login');
  }

  void _showErrorSnackbar(String title, dio_pkg.DioException error) {
    String message =
        error.response?.data?['detail'] ??
        'Terjadi kesalahan jaringan, silakan coba lagi';
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
                    fetchProfile(); // Refresh profile info
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

}
