import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_log_controller.dart';

class ActivityLogView extends GetView<ActivityLogController> {
  const ActivityLogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0056FF);

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
          'Log Aktivitas',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchActivities(),
        color: primaryColor,
        child: Obx(() {
          if (controller.isFetchingActivities.value) {
            return _buildSkeletonUI();
          }

          if (controller.hasActivitiesError.value) {
            return _buildErrorState();
          }

          if (controller.activities.isEmpty) {
            return _buildEmptyState();
          }

          return _buildActivitiesList(primaryColor);
        }),
      ),
    );
  }

  Widget _buildActivitiesList(Color primaryColor) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      itemCount: controller.activities.length,
      itemBuilder: (context, index) {
        final activity = controller.activities[index];
        final String action = activity['action'] ?? 'unknown';
        final String description = activity['description'] ?? '-';
        final String detail = activity['detail'] ?? '';
        final String timestamp = activity['timestamp'] ?? '';

        return _buildActivityCard(action, description, detail, timestamp, primaryColor);
      },
    );
  }

  Widget _buildActivityCard(
    String action,
    String description,
    String detail,
    String timestamp,
    Color primaryColor,
  ) {
    IconData iconData = Icons.info_outline_rounded;
    Color statusColor = Colors.blue;
    String actionTitle = action.toUpperCase();

    if (action.toLowerCase().contains('login')) {
      iconData = Icons.login_rounded;
      statusColor = const Color(0xFF10B981);
      actionTitle = 'Masuk Akun';
    } else if (action.toLowerCase().contains('logout')) {
      iconData = Icons.logout_rounded;
      statusColor = const Color(0xFFF59E0B);
      actionTitle = 'Keluar Akun';
    } else if (action.toLowerCase().contains('profile') || action.toLowerCase().contains('avatar') || action.toLowerCase().contains('update')) {
      iconData = Icons.person_outline_rounded;
      statusColor = primaryColor;
      actionTitle = 'Perbarui Profil';
    } else if (action.toLowerCase().contains('password')) {
      iconData = Icons.lock_outline_rounded;
      statusColor = const Color(0xFFEF4444);
      actionTitle = 'Ubah Kata Sandi';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        actionTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        _formatTimestamp(timestamp),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  _buildDetailSection(detail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(timestamp);
      
      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 
        'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      
      final String day = parsed.day.toString().padLeft(2, '0');
      final String month = months[parsed.month - 1];
      final String hour = parsed.hour.toString().padLeft(2, '0');
      final String minute = parsed.minute.toString().padLeft(2, '0');
      
      return '$day $month, $hour:$minute';
    } catch (e) {
      return timestamp;
    }
  }

  Widget _buildDetailSection(String detail) {
    if (detail.isEmpty) return const SizedBox.shrink();

    final Map<String, String> pairs = {};
    final List<String> parts = detail.split(RegExp(r'[&\n,]'));
    
    for (var part in parts) {
      final kv = part.split('=');
      if (kv.length == 2) {
        pairs[kv[0].trim()] = kv[1].trim();
      } else if (part.trim().isNotEmpty) {
        pairs[part.trim()] = '';
      }
    }

    if (pairs.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          detail,
          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: pairs.entries.map((entry) {
          return _buildDetailItem(entry.key, entry.value);
        }).toList(),
      ),
    );
  }

  Widget _buildDetailItem(String key, String value) {
    IconData icon = Icons.info_outline_rounded;
    Color color = const Color(0xFF64748B);
    String displayLabel = key;
    String displayValue = value;

    final String lowKey = key.toLowerCase();
    if (lowKey == 'email') {
      icon = Icons.email_outlined;
      color = const Color(0xFF0056FF);
      displayLabel = 'Email';
      displayValue = ''; // Hapus isi nilai email yang panjang
    } else if (lowKey == 'score' || lowKey == 'nilai') {
      icon = Icons.emoji_events_outlined;
      color = const Color(0xFFF59E0B);
      displayLabel = 'Score';
      // Tetap tampilkan score/nilai karena singkat (misal: 0.7 atau 0,7)
    } else if (lowKey == 'ip' || lowKey == 'ip_address' || lowKey == 'device') {
      icon = Icons.devices_rounded;
      color = const Color(0xFF8B5CF6);
      displayLabel = 'Device';
      displayValue = ''; // Hapus informasi perangkat/IP yang panjang
    } else if (lowKey == 'id' || lowKey == 'user_id') {
      icon = Icons.tag_rounded;
      color = const Color(0xFF0EA5E9);
      displayLabel = 'ID';
      displayValue = ''; // Hapus ID
    } else if (lowKey == 'status') {
      icon = Icons.check_circle_outline_rounded;
      color = const Color(0xFF10B981);
      displayLabel = 'Status';
      if (displayValue.length > 10) {
        displayValue = ''; // Hapus jika status terlalu panjang
      }
    }

    if (displayLabel.isNotEmpty) {
      displayLabel = displayLabel[0].toUpperCase() + displayLabel.substring(1);
    }

    final String textToShow = displayValue.isNotEmpty ? '$displayLabel: $displayValue' : displayLabel;

    return Container(
      constraints: const BoxConstraints(maxWidth: 160), // Batasi lebar maks untuk mencegah overflow
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.12), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              textToShow,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 64,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Aktivitas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Semua riwayat aktivitas akun Anda akan tercatat di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Gagal Memuat Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Terjadi kesalahan saat mengambil riwayat aktivitas Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.fetchActivities(),
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0056FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonUI() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 14,
                          color: Colors.grey.shade100,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.grey.shade100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
