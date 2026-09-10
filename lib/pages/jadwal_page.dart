import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({super.key});

  static const Color _themeColor = Color(0xFFDC2626);

  // ==== Data 5 kategori program kursus ====
  static final List<_KategoriJadwal> _kategoriList = [
    _KategoriJadwal(
      nama: 'Aplikasi Perkantoran',
      icon: Icons.business_center_outlined,
      color: const Color(0xFF4F46E5),
      bgColor: const Color(0xFFE0E7FF),
      initialData: const [],
    ),
    _KategoriJadwal(
      nama: 'Desain Grafis',
      icon: Icons.palette_outlined,
      color: const Color(0xFF9333EA),
      bgColor: const Color(0xFFF3E8FF),
      initialData: const [],
    ),
    _KategoriJadwal(
      nama: 'AutoCad',
      icon: Icons.architecture_outlined,
      color: const Color(0xFFD97706),
      bgColor: const Color(0xFFFEF3C7),
      initialData: const [],
    ),
    _KategoriJadwal(
      nama: 'Teknisi Komputer',
      icon: Icons.computer_outlined,
      color: const Color(0xFF0D9488),
      bgColor: const Color(0xFFCCFBF1),
      initialData: const [
        {
          'namaKelas': 'Kelas Jaringan Dasar',
          'tanggal': '15/08/2026',
          'jam': '08.00 - 10.00',
          'instruktur': 'Budi Santoso',
          'peserta': 'Andi Pratama',
          'status': 'Terjadwal',
        },
      ],
    ),
    _KategoriJadwal(
      nama: 'Pemrograman',
      icon: Icons.code_outlined,
      color: const Color(0xFF2563EB),
      bgColor: const Color(0xFFDBEAFE),
      initialData: const [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header merah dengan back, judul ====
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
                          'Jadwal',
                          style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Pilih kategori program kursus',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==== Sheet putih melengkung berisi daftar kategori ====
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
                  itemCount: _kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = _kategoriList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CrudPage(
                                  title: kategori.nama,
                                  subtitle: 'Kelola jadwal & peserta ${kategori.nama}',
                                  titleIcon: kategori.icon,
                                  themeColor: kategori.color,
                                  primaryFieldKey: 'namaKelas',
                                  secondaryFieldKey: 'tanggal',
                                  fields: const [
                                    CrudField(
                                      key: 'namaKelas',
                                      label: 'Nama Kelas/Jadwal',
                                      icon: Icons.class_outlined,
                                    ),
                                    CrudField(
                                      key: 'tanggal',
                                      label: 'Tanggal (contoh: 15/08/2026)',
                                      icon: Icons.calendar_today_outlined,
                                    ),
                                    CrudField(
                                      key: 'jam',
                                      label: 'Jam (contoh: 08.00 - 10.00)',
                                      icon: Icons.access_time_outlined,
                                    ),
                                    CrudField(
                                      key: 'instruktur',
                                      label: 'Instruktur',
                                      icon: Icons.school_outlined,
                                    ),
                                    CrudField(
                                      key: 'peserta',
                                      label: 'Peserta (pisahkan dengan koma)',
                                      icon: Icons.people_alt_outlined,
                                      keyboardType: TextInputType.multiline,
                                      required: false,
                                    ),
                                    CrudField(
                                      key: 'status',
                                      label: 'Status',
                                      icon: Icons.flag_outlined,
                                      type: CrudFieldType.dropdown,
                                      options: ['Terjadwal', 'Selesai'],
                                    ),
                                  ],
                                  initialData: kategori.initialData,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: kategori.bgColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(kategori.icon, color: kategori.color, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kategori.nama,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.5,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${kategori.initialData.length} jadwal aktif',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
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

class _KategoriJadwal {
  final String nama;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<Map<String, dynamic>> initialData;

  const _KategoriJadwal({
    required this.nama,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.initialData,
  });
}