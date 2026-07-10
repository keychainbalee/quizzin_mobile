import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime dt = DateTime.parse(dateStr).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final day = dt.day.toString().padLeft(2, '0');
      final month = months[dt.month - 1];
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$day $month $year • $hour:$minute';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '--:--';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    }
    return '${remainingSeconds}s';
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color bgColor;
    Color textColor;
    String label;
    
    switch (difficulty.toLowerCase()) {
      case 'easy':
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        label = 'Mudah';
        break;
      case 'medium':
        bgColor = const Color(0xFFFFFBEB);
        textColor = const Color(0xFFD97706);
        label = 'Sedang';
        break;
      case 'hots':
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFDC2626);
        label = 'Sulit';
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
        label = difficulty.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildStatsDashboard(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    int total = items.length;
    double avg = items.map((e) => (e['total_score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) / total;
    double max = items.map((e) => (e['total_score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a > b ? a : b);
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056FF), Color(0xFF2FA2F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0056FF).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Kuis', total.toString(), Icons.assignment_turned_in_rounded),
          _buildStatDivider(),
          _buildStatItem('Rata-rata', '${avg.round()}', Icons.analytics_rounded),
          _buildStatDivider(),
          _buildStatItem('Skor Terbaik', '${max.round()}', Icons.emoji_events_rounded),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Skor Tinggi (≥80)', 'Sedang (60-79)', 'Rendah (<60)'];
    
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedFilter.value == index;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filters[index]),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    controller.selectedFilter.value = index;
                  }
                },
                selectedColor: const Color(0xFF0056FF),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : Colors.grey.shade200,
                  ),
                ),
                showCheckmark: false,
                elevation: isSelected ? 2 : 0,
                shadowColor: const Color(0xFF0056FF).withOpacity(0.2),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isFiltered) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered ? Icons.filter_list_off_rounded : Icons.history_toggle_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isFiltered ? 'Tidak ada riwayat untuk filter ini' : 'Belum ada riwayat kuis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered ? 'Coba ganti filter Anda' : 'Ayo mulai kuis pertamamu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final String docTitle = item['document_title'] ?? '';
    final String chTitle = item['chapter_title'] ?? 'Kuis';
    final score = (item['total_score'] as num?)?.toInt() ?? 0;
    final date = item['completed_at'] ?? '';
    final attemptId = (item['attempt_id'] as num?)?.toInt() ?? 0;
    final difficulty = item['difficulty'] ?? 'medium';
    final timeTakenSeconds = (item['time_taken_seconds'] as num?)?.toInt() ?? 0;

    Color bgColor;
    Color textColor;
    Color borderColor;
    
    if (score >= 80) {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF15803D);
      borderColor = const Color(0xFFBBF7D0);
    } else if (score >= 60) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFB45309);
      borderColor = const Color(0xFFFDE68A);
    } else {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFB91C1C);
      borderColor = const Color(0xFFFECACA);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (attemptId > 0) {
              controller.goToDetail(attemptId);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (docTitle.isNotEmpty)
                        Text(
                          docTitle.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0056FF),
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 2),
                      Text(
                        chTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildDifficultyChip(difficulty),
                          const SizedBox(width: 8),
                          Icon(Icons.timer_outlined, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Text(
                            _formatDuration(timeTakenSeconds),
                            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          ),
                          const Spacer(),
                          Text(
                            _formatDate(date.toString()),
                            style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ) : null,
        title: const Text(
          'Riwayat Kuis',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF0056FF)),
          );
        }

        if (controller.hasError.value) {
          return RefreshIndicator(
            onRefresh: () => controller.fetchHistory(),
            color: const Color(0xFF0056FF),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: _buildErrorState(),
                ),
              ],
            ),
          );
        }

        final filteredList = controller.filteredHistoryList;
        final hasFilters = controller.selectedFilter.value != 0;

        return RefreshIndicator(
          onRefresh: () => controller.fetchHistory(),
          color: const Color(0xFF0056FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Statistik
              _buildStatsDashboard(controller.historyList),
              
              // Filter Chips
              if (controller.historyList.isNotEmpty) _buildFilterChips(),
              
              // Konten Utama
              Expanded(
                child: filteredList.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 320,
                            child: _buildEmptyState(hasFilters),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return _buildHistoryCard(filteredList[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      }),
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
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Koneksi Bermasalah',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A365D),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Gagal terhubung ke server atau waktu tunggu habis. Silakan periksa internetmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => controller.fetchHistory(),
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Muat Ulang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0056FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
