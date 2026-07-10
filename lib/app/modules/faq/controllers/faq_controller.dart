import 'package:get/get.dart';

class FaqController extends GetxController {
  final faqs = <Map<String, String>>[
    {
      'q': 'Apa itu Quizzin?',
      'a': 'Quizzin adalah aplikasi belajar interaktif yang membantu Anda menguji pemahaman materi sekolah menggunakan kuis berbasis AI. Anda dapat membuat kuis secara instan dari dokumen atau catatan Anda.'
    },
    {
      'q': 'Bagaimana cara menggunakan fitur Scan QR?',
      'a': 'Pilih menu "Scan" di bar navigasi utama, berikan izin akses kamera, lalu arahkan kamera ke QR Code kuis atau dokumen yang dibagikan oleh teman atau pengajar Anda.'
    },
    {
      'q': 'Bagaimana cara menambahkan materi pelajaran baru?',
      'a': 'Anda dapat mengunggah dokumen (seperti PDF atau file teks) di halaman Materi. AI kami akan memproses dokumen tersebut dan membaginya menjadi beberapa bab kuis secara otomatis.'
    },
    {
      'q': 'Bagaimana sistem penilaian skor dihitung?',
      'a': 'Skor dihitung berdasarkan jumlah jawaban yang benar saat Anda mengerjakan kuis. Setiap kuis yang diselesaikan dengan skor tinggi akan memberi Anda XP Points dan meningkatkan Streak harian Anda.'
    },
    {
      'q': 'Apakah aplikasi ini memerlukan koneksi internet?',
      'a': 'Ya, Quizzin memerlukan koneksi internet aktif karena pembuatan kuis dan analisis dokumen diproses di server AI kami secara real-time.'
    },
  ].obs;
}
