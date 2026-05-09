import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzin/app/modules/select_difficulty/controllers/select_difficulty_controller.dart';

class SelectDifficultyView extends GetView<SelectDifficultyController> {
  const SelectDifficultyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Get.back()),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Center(child: Text('Intellect', style: TextStyle(color: Color(0xFF0056FF), fontWeight: FontWeight.bold, fontSize: 16))),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Select Difficulty', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose the challenge level that best matches your current academic goals for this module.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    
                    // List Kartu Kesulitan
                    _buildDifficultyCard(
                      id: 'easy',
                      title: 'Easy',
                      description: 'Focuses on foundational concepts and straightforward recall. Ideal for warming up.',
                      estTime: 'EST. 5 MINS',
                      icon: Icons.sentiment_satisfied_alt,
                      iconBgColor: const Color(0xFFE8F1FF),
                      iconColor: const Color(0xFF0056FF),
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyCard(
                      id: 'medium',
                      title: 'Medium',
                      description: 'Requires applying concepts to standard problems. Balances speed and accuracy.',
                      estTime: 'EST. 10 MINS',
                      icon: Icons.bar_chart,
                      iconBgColor: const Color(0xFF0056FF),
                      iconColor: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    _buildDifficultyCard(
                      id: 'hots',
                      title: 'HOTS',
                      description: 'Higher Order Thinking Skills. Complex problem solving, synthesis, and critical analysis.',
                      estTime: 'EST. 20+ MINS',
                      icon: Icons.psychology_outlined,
                      iconBgColor: const Color(0xFFFFE0CC), 
                      iconColor: const Color(0xFFD84315), 
                    ),
                  ],
                ),
              ),
            ),
            
            // Tombol Start Quiz di bagian bawah
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.startQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Start Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Komponen Kartu Level yang Reaktif
  Widget _buildDifficultyCard({
    required String id, required String title, required String description, 
    required String estTime, required IconData icon, required Color iconBgColor, required Color iconColor
  }) {
    // Obx digunakan di sini agar hanya kartu ini yang di-rebuild saat state berubah
    return Obx(() {
      bool isSelected = controller.selectedDifficulty.value == id;
      
      return GestureDetector(
        onTap: () => controller.selectLevel(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0056FF) : Colors.grey.shade200,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected 
                ? [BoxShadow(color: const Color(0xFF0056FF).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_outline, color: Color(0xFF0056FF), size: 24),
                ],
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
              const SizedBox(height: 20),
              Text(estTime, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF0056FF) : Colors.grey)),
            ],
          ),
        ),
      );
    });
  }
}