import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_pkg;
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/face_service.dart';

class FaceLoginDialog extends StatefulWidget {
  const FaceLoginDialog({Key? key}) : super(key: key);

  @override
  State<FaceLoginDialog> createState() => _FaceLoginDialogState();
}

class _FaceLoginDialogState extends State<FaceLoginDialog> {
  CameraController? _cameraController;
  final FaceService _faceService = FaceService();
  final ApiService _apiService = ApiService();
  final AuthService _authService = Get.find<AuthService>();

  bool _isCameraInitialized = false;
  bool _isScanning = false;
  bool _isSuccess = false;
  String _statusMessage = 'Mempersiapkan kamera...';
  String _errorMessage = '';
  CameraDescription? _frontCamera;
  Timer? _timeoutTimer;
  bool _isDetectingLoopActive = false;

  @override
  void initState() {
    super.initState();
    _initScanner();
  }

  Future<void> _initScanner() async {
    try {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = false;
        _isScanning = false;
        _isSuccess = false;
        _statusMessage = 'Menginisialisasi kamera depan...';
        _errorMessage = '';
      });

      final cameras = await availableCameras();
      _frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _faceService.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _statusMessage = 'Posisikan wajah Anda di dalam lingkaran...';
        });

        // Mulai pencarian wajah realtime di background
        _startFaceDetectionLoop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal mengakses kamera: $e';
          _statusMessage = 'Kamera tidak dapat diakses';
        });
      }
    }
  }

  void _startFaceDetectionLoop() {
    if (_isDetectingLoopActive) return;
    _isDetectingLoopActive = true;
    _runDetectionCycle();
  }

  Future<void> _runDetectionCycle() async {
    while (mounted && _isCameraInitialized && !_isScanning && !_isSuccess && _isDetectingLoopActive) {
      try {
        if (_cameraController == null || !_cameraController!.value.isInitialized) {
          await Future.delayed(const Duration(milliseconds: 500));
          continue;
        }

        // Ambil gambar secara cepat di background untuk dideteksi
        final XFile file = await _cameraController!.takePicture();
        
        if (!mounted || !_isDetectingLoopActive) {
          _deleteTempFile(file.path);
          break;
        }

        final faceRect = await _faceService.detectFaceInFile(file.path);
        _deleteTempFile(file.path);

        if (faceRect != null) {
          _isDetectingLoopActive = false;
          _triggerTahanSebentarSequence();
          break;
        }
      } catch (e) {
        debugPrint('Error in face detection loop: $e');
      }

      // Tunggu 800ms sebelum memeriksa wajah lagi
      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  void _deleteTempFile(String path) {
    try {
      final file = io.File(path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  }

  Future<void> _triggerTahanSebentarSequence() async {
    if (!mounted) return;

    setState(() {
      _statusMessage = 'Tahan sebentar...';
      _isScanning = true;
    });

    // Mulai timer untuk keseluruhan proses pencocokan data
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_isSuccess) {
        _cameraController?.dispose();
        _cameraController = null;
        Get.back(); 
        Get.snackbar(
          'Face ID Gagal',
          'Wajah tidak terdeteksi atau tidak dikenali di database',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 4),
        );
      }
    });

    try {
      // Tunggu 1.5 - 2 detik untuk memastikan posisi wajah stabil
      await Future.delayed(const Duration(milliseconds: 1800));

      if (!mounted) return;

      setState(() {
        _statusMessage = 'Mengambil gambar wajah...';
      });

      // Ambil gambar final setelah pengguna menahan posisi
      final photoFile = await _cameraController!.takePicture();
      
      if (!mounted) {
        _deleteTempFile(photoFile.path);
        return;
      }

      setState(() {
        _statusMessage = 'Mencocokkan dengan database...';
      });

      // Deteksi wajah dari gambar stabil final
      final faceRect = await _faceService.detectFaceInFile(photoFile.path);
      if (faceRect == null) {
        _deleteTempFile(photoFile.path);
        throw Exception('Wajah bergeser. Silakan posisikan wajah Anda kembali.');
      }

      // Potong wajah & generate embedding
      final croppedFace = await _faceService.cropFaceFromFile(photoFile.path, faceRect);
      final embedding = _faceService.generateEmbedding(croppedFace);
      _deleteTempFile(photoFile.path);

      // Kirim embedding ke server
      final response = await _apiService.dio.post(
        '/auth/login-face',
        data: {'embedding': embedding},
      );

      final accessToken = response.data['access_token'] as String;

      await _authService.saveToken(accessToken);
      _apiService.setAuthToken(accessToken);

      // Sukses! Matikan timer timeout
      _timeoutTimer?.cancel();

      if (mounted) {
        setState(() {
          _isScanning = false;
          _isSuccess = true;
          _statusMessage = 'Login Berhasil!';
        });

        // Tunggu 1 detik agar animasi sukses terlihat, kemudian navigasi
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          Get.offAllNamed('/main-navigation');
        }
      }
    } catch (e) {
      _timeoutTimer?.cancel();
      
      if (mounted) {
        String errorMsg = 'Wajah tidak dikenali atau terjadi kesalahan.';
        if (e is dio_pkg.DioException) {
          final statusCode = e.response?.statusCode;
          final detail = e.response?.data?['detail'];
          if (statusCode == 401) {
            errorMsg = 'Wajah tidak dikenali. Silakan daftarkan wajah Anda terlebih dahulu.';
          } else if (detail != null && detail is String) {
            errorMsg = detail;
          }
        } else if (e.toString().contains('Wajah tidak terdeteksi') || e.toString().contains('Wajah bergeser')) {
          errorMsg = e.toString().replaceAll('Exception: ', '').replaceAll('value', '');
        }

        setState(() {
          _isScanning = false;
          _errorMessage = errorMsg;
          _statusMessage = 'Pemindaian Gagal';
        });
      }
    }
  }

  void _retryScanner() {
    if (!mounted) return;
    setState(() {
      _errorMessage = '';
      _isScanning = false;
      _isSuccess = false;
      _statusMessage = 'Posisikan wajah Anda di dalam lingkaran...';
    });
    _startFaceDetectionLoop();
  }

  @override
  void dispose() {
    _isDetectingLoopActive = false;
    _timeoutTimer?.cancel();
    _cameraController?.dispose();
    _faceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0056FF);
    final size = MediaQuery.of(context).size;

    Color currentBorderColor = primaryColor;
    if (_isSuccess) {
      currentBorderColor = Colors.green;
    } else if (_errorMessage.isNotEmpty) {
      currentBorderColor = Colors.red;
    } else if (_statusMessage == 'Tahan sebentar...') {
      currentBorderColor = Colors.orange;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 16,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: size.width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Face ID Login',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
            const SizedBox(height: 20),
            
            // Kamera Preview Circular
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: currentBorderColor,
                  width: 4
                ),
                boxShadow: [
                  BoxShadow(
                    color: currentBorderColor.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2
                  )
                ],
              ),
              child: ClipOval(
                child: !_isCameraInitialized 
                    ? const Center(child: CircularProgressIndicator(color: primaryColor))
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _cameraController!.value.previewSize?.height ?? 1,
                                height: _cameraController!.value.previewSize?.width ?? 1,
                                child: CameraPreview(_cameraController!),
                              ),
                            ),
                          ),
                          if (_isScanning)
                            Positioned.fill(
                              child: Container(
                                color: (_statusMessage == 'Tahan sebentar...')
                                    ? Colors.orange.withOpacity(0.2)
                                    : primaryColor.withOpacity(0.3),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                      if (_statusMessage == 'Tahan sebentar...') ...[
                                        const SizedBox(height: 12),
                                        const Icon(
                                          Icons.face_unlock_outlined,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (_isSuccess)
                            Positioned.fill(
                              child: Container(
                                color: Colors.green.withOpacity(0.4),
                                child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 60),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Status message
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.w600,
                color: _isSuccess 
                    ? Colors.green.shade700 
                    : (_errorMessage.isNotEmpty 
                        ? Colors.red.shade700 
                        : (_statusMessage == 'Tahan sebentar...' ? Colors.orange.shade800 : Colors.black87))
              ),
            ),
            
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _retryScanner,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ] else if (!_isSuccess && _isCameraInitialized && !_isScanning) ...[
              const SizedBox(height: 14),
              const Text(
                'Mencari wajah Anda...',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
