import 'package:flutter/material.dart';

class ProgramDetailSayaPage extends StatefulWidget {
  final Map<String, dynamic> program;
  final Color themeColor;
  final IconData icon;
  final bool sudahDiikuti;
  final VoidCallback onDaftar;

  const ProgramDetailSayaPage({
    super.key,
    required this.program,
    required this.themeColor,
    required this.icon,
    required this.sudahDiikuti,
    required this.onDaftar,
  });

  @override
  State<ProgramDetailSayaPage> createState() => _ProgramDetailSayaPageState();
}

class _ProgramDetailSayaPageState extends State<ProgramDetailSayaPage> {
  late bool _sudahDiikuti;

  @override
  void initState() {
    super.initState();
    _sudahDiikuti = widget.sudahDiikuti;
  }

  void _confirmDaftar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Daftar Kursus'),
        content: Text('Yakin ingin mendaftar ke program "${widget.program['nama']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sudahDiikuti = true);
              widget.onDaftar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pendaftaran berhasil diajukan, menunggu konfirmasi Admin')),
              );
            },
            child: Text('Daftar', style: TextStyle(color: widget.themeColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String nama = widget.program['nama'] as String? ?? '-';
    final String durasi = widget.program['durasi'] as String? ?? '-';
    final String kuota = widget.program['kuota'] as String? ?? '-';
    final String deskripsi = widget.program['deskripsi'] as String? ?? '';
    final List<String> benefits = (widget.program['benefits'] as String? ?? '')
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header dengan back ====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 30),
            color: widget.themeColor,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      nama,
                      style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==== Sheet putih melengkung berisi detail ====
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
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _InfoBadge(icon: Icons.timelapse_outlined, label: durasi, color: widget.themeColor),
                          const SizedBox(width: 10),
                          _InfoBadge(icon: Icons.groups_outlined, label: '$kuota Peserta', color: widget.themeColor),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Deskripsi',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Text(
                          deskripsi.isNotEmpty ? deskripsi : 'Belum ada deskripsi untuk program ini.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: deskripsi.isNotEmpty ? const Color(0xFF334155) : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Benefit / Keunggulan',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 10),
                      if (benefits.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Text('Belum ada benefit ditambahkan.', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                        )
                      else
                        ...benefits.map((b) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: widget.themeColor.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check_rounded, size: 14, color: widget.themeColor),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(b, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4)),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // ==== Tombol daftar mengambang di bawah ====
      floatingActionButton: null,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: _sudahDiikuti
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                        SizedBox(width: 8),
                        Text('Sedang Diikuti', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: _confirmDaftar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.themeColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Daftar Sekarang',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}