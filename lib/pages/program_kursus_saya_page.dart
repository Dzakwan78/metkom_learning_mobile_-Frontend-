import 'package:flutter/material.dart';
import 'program_detail_saya_page.dart';

class ProgramKursusSayaPage extends StatefulWidget {
  const ProgramKursusSayaPage({super.key});

  @override
  State<ProgramKursusSayaPage> createState() => _ProgramKursusSayaPageState();
}

class _ProgramKursusSayaPageState extends State<ProgramKursusSayaPage> {
  static const Color _themeColor = Color(0xFF9333EA);

  // Data dummy program kursus - nanti diganti data asli dari Admin
  final List<Map<String, dynamic>> _programs = [
    {
      'nama': 'Desain Grafis',
      'durasi': '2 Bulan',
      'kuota': '20',
      'icon': Icons.palette_outlined,
      'color': const Color(0xFF9333EA),
      'bgColor': const Color(0xFFF3E8FF),
      'sudahDiikuti': true,
      'deskripsi':
          'Belajar dasar-dasar desain grafis menggunakan software industri, mulai dari teori warna, tipografi, hingga pembuatan desain untuk kebutuhan digital dan cetak.',
      'benefits':
          'Portofolio desain siap pakai\nAkses software desain selama pelatihan\nSertifikat kelulusan\nKelas kecil, lebih fokus',
    },
    {
      'nama': 'Teknisi Komputer',
      'durasi': '3 Bulan',
      'kuota': '25',
      'icon': Icons.computer_outlined,
      'color': const Color(0xFF0D9488),
      'bgColor': const Color(0xFFCCFBF1),
      'sudahDiikuti': true,
      'deskripsi':
          'Program ini membekali peserta dengan kemampuan dasar hingga menengah dalam merakit, memperbaiki, dan merawat perangkat komputer serta jaringan.',
      'benefits':
          'Sertifikat resmi setelah lulus\nPraktik langsung dengan perangkat\nPendampingan instruktur berpengalaman',
    },
    {
      'nama': 'Aplikasi Perkantoran',
      'durasi': '2 Bulan',
      'kuota': '25',
      'icon': Icons.business_center_outlined,
      'color': const Color(0xFF4F46E5),
      'bgColor': const Color(0xFFE0E7FF),
      'sudahDiikuti': false,
      'deskripsi':
          'Kuasai penggunaan aplikasi perkantoran (Word, Excel, PowerPoint) untuk kebutuhan administrasi dan pekerjaan kantor sehari-hari.',
      'benefits': 'Sertifikat kelulusan\nModul praktik langsung\nCocok untuk pemula',
    },
    {
      'nama': 'AutoCad',
      'durasi': '3 Bulan',
      'kuota': '15',
      'icon': Icons.architecture_outlined,
      'color': const Color(0xFFD97706),
      'bgColor': const Color(0xFFFEF3C7),
      'sudahDiikuti': false,
      'deskripsi': 'Belajar menggambar teknik 2D dan 3D menggunakan AutoCad untuk kebutuhan desain bangunan dan produk.',
      'benefits': 'Sertifikat kelulusan\nLatihan proyek nyata\nPendampingan instruktur berpengalaman',
    },
    {
      'nama': 'Pemrograman',
      'durasi': '4 Bulan',
      'kuota': '20',
      'icon': Icons.code_outlined,
      'color': const Color(0xFF2563EB),
      'bgColor': const Color(0xFFDBEAFE),
      'sudahDiikuti': false,
      'deskripsi': 'Pelajari dasar-dasar pemrograman dan pengembangan aplikasi dari nol hingga siap membangun proyek sendiri.',
      'benefits': 'Sertifikat kelulusan\nProyek akhir portofolio\nBimbingan mentor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header dengan back ====
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
                          'Program Kursus',
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Lihat dan daftar program kursus',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==== Sheet putih melengkung berisi daftar program ====
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                  itemCount: _programs.length,
                  itemBuilder: (context, index) {
                    final program = _programs[index];
                    final sudahDiikuti = program['sudahDiikuti'] as bool;
                    final color = program['color'] as Color;
                    final bgColor = program['bgColor'] as Color;
                    final icon = program['icon'] as IconData;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProgramDetailSayaPage(
                                  program: program,
                                  themeColor: color,
                                  icon: icon,
                                  sudahDiikuti: sudahDiikuti,
                                  onDaftar: () => setState(() => program['sudahDiikuti'] = true),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
                                  child: Icon(icon, color: color, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        program['nama'] as String,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 14.5, color: Color(0xFF1E293B)),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${program['durasi']} • ${program['kuota']} kuota',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                if (sudahDiikuti)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Diikuti',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF16A34A), fontWeight: FontWeight.w700),
                                    ),
                                  )
                                else
                                  Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}