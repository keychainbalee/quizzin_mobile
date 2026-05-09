import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzin/app/modules/quiz_play/controllers/quiz_play_controller.dart';

class QuizPlayView extends GetView<QuizPlayController> {
  const QuizPlayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.isEssayMode.value ? 'Question 4 of 10' : 'Smart Quiz',
            style: TextStyle(
              color: controller.isEssayMode.value
                  ? Colors.black54
                  : const Color(0xFF0056FF),
              fontWeight: FontWeight.bold,
              fontSize: controller.isEssayMode.value ? 14 : 18,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          // Timer Chip
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: Color(0xFF0056FF),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '12:45',
                    style: TextStyle(
                      color: Color(0xFF0056FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tombol sementara untuk testing ubah UI
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.grey),
            onPressed: () => controller.toggleMode(),
            tooltip: 'Switch UI Mode',
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          return controller.isEssayMode.value
              ? _buildEssayView()
              : _buildMCQView();
        }),
      ),
    );
  }

  // ==========================================
  // 1. TAMPILAN PILIHAN GANDA (MCQ)
  // ==========================================
  Widget _buildMCQView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar Area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUESTION 5 OF 10',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.access_time, size: 14, color: Color(0xFFD32F2F)),
                  SizedBox(width: 4),
                  Text(
                    '08:45',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF008A27)),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 32),

          // Pertanyaan
          const Text(
            'Which of the following is a key property of a derivative?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          // Pilihan Jawaban
          _buildOptionCard('A', 'It represents the area under a curve.'),
          const SizedBox(height: 12),
          _buildOptionCard(
            'B',
            'It measures the instantaneous rate of change.',
          ),
          const SizedBox(height: 12),
          _buildOptionCard('C', 'It is only applicable to linear functions.'),
          const SizedBox(height: 12),
          _buildOptionCard('D', 'It defines the total sum of a sequence.'),
          const SizedBox(height: 24),

          // Hint Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFB9D5FF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF0056FF),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Think about what happens as the interval between two points on a curve approaches zero.',
                    style: TextStyle(
                      color: Color(0xFF1A365D),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () =>
                  controller.submitQuiz(), // <-- Panggil fungsi dari controller
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056FF),
                // ... (styling lainnya tetap sama)
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String letter, String text) {
    return Obx(() {
      bool isSelected = controller.selectedOption.value == letter;

      return GestureDetector(
        onTap: () => controller.selectOption(letter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1F5F9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF0056FF)
                  : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0056FF) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0056FF)
                        : Colors.grey.shade400,
                  ),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF0056FF),
                ),
            ],
          ),
        ),
      );
    });
  }

  // ==========================================
  // 2. TAMPILAN ISIAN / ESSAY
  // ==========================================
  Widget _buildEssayView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Natural Language Processing',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A365D),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Explain the concept of Semantic Similarity in your own words.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Provide an example of how it might be used in a real-world application, such as a search engine or a recommendation system.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Answer Text Area
          Container(
            height: 250,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller.essayAnswerController,
              maxLines: null, // Membiarkan text field meluas ke bawah
              expands: true, // Memenuhi tinggi container
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Type your answer here...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // AI Analyzing Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.smart_toy_outlined, color: Color(0xFF0056FF)),
                SizedBox(width: 12),
                Text(
                  'AI is analyzing for conceptual accuracy...',
                  style: TextStyle(
                    color: Color(0xFF0056FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button (Right Aligned)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => controller.submitQuiz(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056FF),
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
