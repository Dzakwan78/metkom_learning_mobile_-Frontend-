import 'package:flutter/material.dart';

class JadwalSayaPage extends StatelessWidget {
  const JadwalSayaPage({super.key});

  static const Color _themeColor = Color(0xFF2563EB);

  // Data dummy - nanti diganti jadwal asli milik peserta yang login
  static const List<Map<String, dynamic>> _jadwalList = [
    {
      'namaKelas': 'Kelas Jaringan Dasar',
      'program': 'Teknisi Komputer',
      'tanggal': '28',
      'bulan': 'AGT',
      'jam': '08.00 - 10.00 WIB',
      'instruktur': 'Budi Santoso',
      'selesai': false,
    },
    {
      'namaKelas': 'Konfigurasi Router',
      'program': 'Teknisi Komputer',
      'tanggal': '04',
      'bulan': 'SEP',
      'jam': '08.00 - 10.00 WIB',
      'instruktur': 'Budi Santoso',
      'selesai': false,
    },
    {
      'namaKelas': 'Pengenalan Jaringan',
      'program': 'Teknisi Komputer',
      'tanggal': '21',
      'bulan': 'AGT',
      'jam': '08.00 - 10.00 WIB',
      'instruktur': 'Budi Santoso',
      'selesai': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final akanDatang = _jadwalList.where((j) => j['selesai'] == false).toList();
    final selesai = _jadwalList.where((j) => j['selesai'] == true).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header dengan tombol back ====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 30),
            color: _themeColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal Saya',
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Jadwal kursus yang kamu ikuti',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==== Sheet putih melengkung berisi daftar jadwal ====
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akan Datang (${akanDatang.length})',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 12),
                      if (akanDatang.isEmpty)
                        _buildEmptyState('Tidak ada jadwal akan datang')
                      else
                        ...akanDatang.map((j) => _buildJadwalCard(j, isSelesai: false)),

                      const SizedBox(height: 24),
                      Text(
                        'Selesai (${selesai.length})',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 12),
                      if (selesai.isEmpty)
                        _buildEmptyState('Belum ada jadwal yang selesai')
                      else
                        ...selesai.map((j) => _buildJadwalCard(j, isSelesai: true)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5)),
      ),
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> j, {required bool isSelesai}) {
    final color = isSelesai ? Colors.grey.shade400 : _themeColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge tanggal
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  j['bulan'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600),
                ),
                Text(
                  j['tanggal'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        j['namaKelas'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1E293B)),
                      ),
                    ),
                    if (isSelesai)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Selesai',
                          style: TextStyle(fontSize: 9.5, color: Color(0xFF16A34A), fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  j['program'] as String,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(j['jam'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.school_outlined, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(j['instruktur'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}