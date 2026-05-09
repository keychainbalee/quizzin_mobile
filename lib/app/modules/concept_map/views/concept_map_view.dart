import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzin/app/modules/concept_map/controllers/concept_map_controller.dart';

class ConceptMapView extends GetView<ConceptMapController> {
  const ConceptMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: const [
            Text('CHAPTER 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0)),
            SizedBox(height: 2),
            Text('Derivatives Base', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Text(
                'Review the conceptual map before proceeding to the assessment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
              ),
            ),
            
            // --- AREA MINDMAP RESPONSIF ---
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // FittedBox akan memastikan kanvas ini tidak pernah overflow di layar HP manapun
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 360, // Lebar virtual kanvas
                      height: 520, // Tinggi virtual kanvas
                      child: Stack(
                        children: [
                          // Layer 1: Garis penghubung putus-putus (berada di bawah)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MindMapLinesPainter(),
                            ),
                          ),
                          
                          // Layer 2: Node Concept Map
                          // Core Concept (Tengah Atas)
                          const Align(
                            alignment: Alignment(0.0, -0.85),
                            child: CoreNodeCard(),
                          ),
                          // Sub Concept 1: Rates of Change (Kiri)
                          const Align(
                            alignment: Alignment(-0.8, -0.1),
                            child: SubNodeCard(title: 'Rates of\nChange', module: 'Module 4.1', icon: Icons.trending_up),
                          ),
                          // Sub Concept 2: Slopes (Kanan)
                          const Align(
                            alignment: Alignment(0.8, 0.4),
                            child: SubNodeCard(title: 'Slopes', module: 'Module 4.2', icon: Icons.show_chart),
                          ),
                          // Sub Concept 3: Applications (Bawah Tengah-Kiri)
                          const Align(
                            alignment: Alignment(-0.3, 0.95),
                            child: SubNodeCard(title: 'Applications', module: 'Module 4.3', icon: Icons.ads_click),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Tombol Continue to Quiz
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.continueToQuiz(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Continue to Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
}

// --- WIDGET UNTUK KARTU CORE (BIRU UTAMA) ---
class CoreNodeCard extends StatelessWidget {
  const CoreNodeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0056FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF0056FF).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_tree_outlined, color: Colors.white, size: 36),
          const SizedBox(height: 12),
          const Text('Derivatives', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Core Concept', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// --- WIDGET UNTUK KARTU SUB (PUTIH) ---
class SubNodeCard extends StatelessWidget {
  final String title;
  final String module;
  final IconData icon;

  const SubNodeCard({Key? key, required this.title, required this.module, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: const Color(0xFF1A365D)),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.2)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
            child: Text(module, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
          )
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER UNTUK GARIS PUTUS-PUTUS ---
class MindMapLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Koordinat ini dikalkulasi persis mengikuti nilai Alignment di atas 
    // agar garis selalu ditarik tepat dari titik tengah masing-masing kartu.
    
    // Core Alignment(0.0, -0.85) -> (0.5, 0.075)
    final Offset coreCenter = Offset(size.width * 0.5, size.height * 0.075);

    // Sub 1 Alignment(-0.8, -0.1) -> (0.1, 0.45)
    final Offset sub1Center = Offset(size.width * 0.1, size.height * 0.45);
    
    // Sub 2 Alignment(0.8, 0.4) -> (0.9, 0.7)
    final Offset sub2Center = Offset(size.width * 0.9, size.height * 0.7);
    
    // Sub 3 Alignment(-0.3, 0.95) -> (0.35, 0.975)
    final Offset sub3Center = Offset(size.width * 0.35, size.height * 0.975);

    // Menggambar garis
    _drawDashedLine(canvas, coreCenter, sub1Center, paint);
    _drawDashedLine(canvas, coreCenter, sub2Center, paint);
    _drawDashedLine(canvas, coreCenter, sub3Center, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const int dashWidth = 5;
    const int dashSpace = 5;
    double distance = (p2 - p1).distance;
    double dx = (p2.dx - p1.dx) / distance;
    double dy = (p2.dy - p1.dy) / distance;
    double startX = p1.dx;
    double startY = p1.dy;

    while (distance >= 0) {
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + dx * dashWidth, startY + dy * dashWidth),
        paint,
      );
      startX += dx * (dashWidth + dashSpace);
      startY += dy * (dashWidth + dashSpace);
      distance -= (dashWidth + dashSpace);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}