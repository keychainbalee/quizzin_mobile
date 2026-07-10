import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_settings_controller.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Obx(
                  () => _buildToggleTile(
                    icon: Icons.alarm_rounded,
                    title: 'Pengingat Belajar Harian',
                    subtitle: 'Ingatkan saya untuk belajar dan mengerjakan kuis setiap hari.',
                    value: controller.isDailyReminderEnabled.value,
                    onChanged: (val) => controller.toggleDailyReminder(val),
                  ),
                ),
                Divider(color: Colors.grey.shade100, height: 1),
                Obx(
                  () => _buildToggleTile(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Pemberitahuan Streak',
                    subtitle: 'Dapatkan pemberitahuan untuk mempertahankan streak harian Anda.',
                    value: controller.isStreakAlertEnabled.value,
                    onChanged: (val) => controller.toggleStreakAlert(val),
                  ),
                ),
                Divider(color: Colors.grey.shade100, height: 1),
                Obx(
                  () => _buildToggleTile(
                    icon: Icons.menu_book_rounded,
                    title: 'Materi Baru Tersedia',
                    subtitle: 'Beritahu saya saat dokumen yang diproses siap dijadikan kuis.',
                    value: controller.isNewMaterialAlertEnabled.value,
                    onChanged: (val) => controller.toggleNewMaterialAlert(val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0056FF), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0056FF),
          ),
        ],
      ),
    );
  }
}
