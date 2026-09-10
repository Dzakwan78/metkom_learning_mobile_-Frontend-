import 'package:flutter/material.dart';
import 'program_detail_page.dart';

class ProgramKursusPage extends StatefulWidget {
  const ProgramKursusPage({super.key});

  @override
  State<ProgramKursusPage> createState() => _ProgramKursusPageState();
}

class _ProgramKursusPageState extends State<ProgramKursusPage> {
  final Color themeColor = const Color.fromARGB(255, 74, 166, 232);

  final List<Map<String, dynamic>> _programs = [
    {
      'nama': 'AutoCad',
      'durasi': '3 Bulan',
      'kuota': '25',
      'deskripsi':
          'Program ini membekali peserta dengan kemampuan dasar hingga menengah dalam merancang, membangun, dan mengelola jaringan komputer, termasuk konfigurasi router, switch, dan troubleshooting jaringan.',
      'benefits':
          'Sertifikat resmi setelah lulus\nPraktik langsung dengan perangkat jaringan\nPendampingan instruktur berpengalaman\nMateri sesuai kebutuhan industri',
    },
    {
      'nama': 'Desain Grafis',
      'durasi': '2 Bulan',
      'kuota': '20',
      'deskripsi':
          'Belajar dasar-dasar desain grafis menggunakan software industri, mulai dari teori warna, tipografi, hingga pembuatan desain untuk kebutuhan digital dan cetak.',
      'benefits':
          'Portofolio desain siap pakai\nAkses software desain selama pelatihan\nSertifikat kelulusan\nKelas kecil, lebih fokus',
    },
  ];

  bool _showSearch = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPrograms {
    if (_searchQuery.isEmpty) return _programs;
    return _programs
        .where((p) => (p['nama'] as String).toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _openForm({Map<String, dynamic>? existing, int? index}) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: existing?['nama'] ?? '');
    final durasiController = TextEditingController(text: existing?['durasi'] ?? '');
    final kuotaController = TextEditingController(text: existing?['kuota'] ?? '');
    final deskripsiController = TextEditingController(text: existing?['deskripsi'] ?? '');
    final benefitsController = TextEditingController(text: existing?['benefits'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Text(
                      existing == null ? 'Tambah Program Kursus' : 'Edit Program Kursus',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(namaController, 'Nama Program', Icons.book_outlined),
                    const SizedBox(height: 14),
                    _buildTextField(durasiController, 'Durasi (mis. 3 Bulan)', Icons.timelapse_outlined),
                    const SizedBox(height: 14),
                    _buildTextField(kuotaController, 'Kuota Peserta', Icons.groups_outlined,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 14),
                    _buildTextField(deskripsiController, 'Deskripsi Program', Icons.description_outlined,
                        maxLines: 4, required: false),
                    const SizedBox(height: 14),
                    _buildTextField(
                      benefitsController,
                      'Benefit (1 baris = 1 benefit)',
                      Icons.star_outline,
                      maxLines: 4,
                      required: false,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;
                          final newProgram = {
                            'nama': namaController.text.trim(),
                            'durasi': durasiController.text.trim(),
                            'kuota': kuotaController.text.trim(),
                            'deskripsi': deskripsiController.text.trim(),
                            'benefits': benefitsController.text.trim(),
                          };
                          setState(() {
                            if (index != null) {
                              _programs[index] = newProgram;
                            } else {
                              _programs.add(newProgram);
                            }
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          existing == null ? 'Simpan' : 'Update',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: themeColor),
        filled: true,
        fillColor: const Color(0xFFF4F6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: themeColor, width: 1.4),
        ),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) return '$label wajib diisi';
        return null;
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Hapus Program'),
        content: Text('Yakin ingin menghapus "${_programs[index]['nama']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() => _programs.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPrograms;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 30),
            color: themeColor,
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
                        Text('Program Kursus',
                            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Kelola semua program kursus',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: _toggleSearch,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _showSearch
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                onChanged: (v) => setState(() => _searchQuery = v),
                                decoration: InputDecoration(
                                  hintText: 'Cari program kursus...',
                                  prefixIcon: Icon(Icons.search_rounded, color: themeColor, size: 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                'Belum ada program kursus',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final program = filtered[i];
                                final index = _programs.indexOf(program);
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 12,
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
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ProgramDetailPage(
                                              program: program,
                                              themeColor: themeColor,
                                              onEdit: () => _openForm(existing: program, index: index),
                                              onDelete: () => _confirmDelete(index),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: themeColor.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Icon(Icons.menu_book_rounded, color: themeColor, size: 22),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    program['nama'] as String? ?? '-',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Color(0xFF1E293B)),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    '${program['durasi'] ?? '-'} \u00b7 ${program['kuota'] ?? '-'} kuota',
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        shape: const CircleBorder(),
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}