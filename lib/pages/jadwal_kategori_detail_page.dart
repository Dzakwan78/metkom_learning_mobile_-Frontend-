import 'package:flutter/material.dart';
import '../models/jadwal_kursus_item.dart';

class JadwalKategoriDetailPage extends StatefulWidget {
  final String nama;
  final IconData icon;
  final Color color;
  final List<JadwalKursusItem> initialData;

  const JadwalKategoriDetailPage({
    super.key,
    required this.nama,
    required this.icon,
    required this.color,
    this.initialData = const [],
  });

  @override
  State<JadwalKategoriDetailPage> createState() =>
      _JadwalKategoriDetailPageState();
}

class _JadwalKategoriDetailPageState extends State<JadwalKategoriDetailPage> {
  late List<JadwalKursusItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialData);
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, size: 20, color: widget.color),
    filled: true,
    fillColor: const Color(0xFFF4F6FB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: widget.color, width: 1.4),
    ),
  );

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _openForm({JadwalKursusItem? existing, int? index}) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(
      text: existing?.namaKelas ?? '',
    );
    final jamController = TextEditingController(text: existing?.jam ?? '');
    final instrukturController = TextEditingController(
      text: existing?.instruktur ?? '',
    );
    final pesertaController = TextEditingController(
      text: existing?.peserta ?? '',
    );

    // Tanggal yang sudah dipilih sebelumnya (kalau edit), beserta status selesainya
    List<DateTime> tanggalTerpilih = existing != null
        ? existing.sesiList.map((s) => s.tanggal).toList()
        : <DateTime>[];
    Map<DateTime, bool> statusSelesaiLama = existing != null
        ? {
            for (final s in existing.sesiList)
              DateTime(s.tanggal.year, s.tanggal.month, s.tanggal.day):
                  s.selesai,
          }
        : {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> openCalendar() async {
              final result = await showDialog<List<DateTime>>(
                context: context,
                builder: (context) => _MultiDateCalendarDialog(
                  themeColor: widget.color,
                  initialSelected: tanggalTerpilih,
                ),
              );
              if (result != null) {
                setSheetState(() => tanggalTerpilih = result);
              }
            }

            void hapusTanggal(DateTime tgl) {
              setSheetState(
                () => tanggalTerpilih.removeWhere((t) => _isSameDay(t, tgl)),
              );
            }

            final sortedTanggal = List<DateTime>.from(tanggalTerpilih)..sort();

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        existing == null
                            ? 'Tambah Jadwal Kelas'
                            : 'Edit Jadwal Kelas',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: namaController,
                        decoration: _dec('Nama Kelas', Icons.class_outlined),
                        validator: _req,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: jamController,
                        decoration: _dec(
                          'Jam (contoh: 08.00 - 10.00)',
                          Icons.access_time_outlined,
                        ),
                        validator: _req,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: instrukturController,
                        decoration: _dec('Instruktur', Icons.school_outlined),
                        validator: _req,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: pesertaController,
                        decoration: _dec(
                          'Peserta (pisahkan dengan koma)',
                          Icons.people_alt_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ==== Tombol buka kalender pilih tanggal manual ====
                      Text(
                        'Tanggal Pertemuan',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: openCalendar,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: widget.color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: widget.color,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  sortedTanggal.isEmpty
                                      ? 'Pilih tanggal pertemuan di kalender'
                                      : '${sortedTanggal.length} tanggal dipilih',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: widget.color,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: widget.color,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ==== Daftar tanggal terpilih (bisa dihapus satu-satu) ====
                      if (sortedTanggal.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: sortedTanggal.map((tgl) {
                            return Chip(
                              label: Text(
                                '${tgl.day}/${tgl.month}/${tgl.year}',
                                style: const TextStyle(fontSize: 11.5),
                              ),
                              backgroundColor: widget.color.withValues(
                                alpha: 0.1,
                              ),
                              deleteIcon: const Icon(
                                Icons.close_rounded,
                                size: 16,
                              ),
                              onDeleted: () => hapusTanggal(tgl),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            if (tanggalTerpilih.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Pilih minimal 1 tanggal pertemuan',
                                  ),
                                ),
                              );
                              return;
                            }

                            final sortedFinal = List<DateTime>.from(
                              tanggalTerpilih,
                            )..sort();
                            final sesiList = sortedFinal.map((tgl) {
                              final key = DateTime(
                                tgl.year,
                                tgl.month,
                                tgl.day,
                              );
                              final selesaiLama =
                                  statusSelesaiLama[key] ?? false;
                              return SesiPertemuan(
                                tanggal: tgl,
                                selesai: selesaiLama,
                              );
                            }).toList();

                            final newItem = JadwalKursusItem(
                              namaKelas: namaController.text.trim(),
                              jam: jamController.text.trim(),
                              instruktur: instrukturController.text.trim(),
                              peserta: pesertaController.text.trim(),
                              sesiList: sesiList,
                            );

                            setState(() {
                              if (index != null) {
                                _items[index] = newItem;
                              } else {
                                _items.add(newItem);
                              }
                            });

                            Navigator.pop(context);
                          },
                          child: Text(
                            existing == null ? 'Simpan' : 'Update',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleSesi(int itemIndex, int sesiIndex) {
    setState(() {
      final sesi = _items[itemIndex].sesiList[sesiIndex];
      sesi.selesai = !sesi.selesai;
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Jadwal'),
        content: Text('Yakin ingin menghapus ${_items[index].namaKelas}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _items.removeAt(index));
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 50, 20, 30),
            color: widget.color,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Kelola jadwal & peserta ${widget.nama}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
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
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: widget.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.color,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '${_items.length}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Total Kelas ${widget.nama}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _items.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: widget.color.withValues(
                                        alpha: 0.08,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      widget.icon,
                                      size: 48,
                                      color: widget.color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Belum ada jadwal ${widget.nama}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tekan tombol + untuk menambahkan',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                final selesaiSemua =
                                    item.totalSelesai == item.totalPertemuan &&
                                    item.totalPertemuan > 0;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 22,
                                            backgroundColor: widget.color
                                                .withValues(alpha: 0.12),
                                            child: Text(
                                              item.namaKelas.isNotEmpty
                                                  ? item.namaKelas[0]
                                                        .toUpperCase()
                                                  : '-',
                                              style: TextStyle(
                                                color: widget.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.namaKelas,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${item.jam} • ${item.instruktur}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                if (item
                                                    .peserta
                                                    .isNotEmpty) ...[
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Peserta: ${item.peserta}',
                                                    style: TextStyle(
                                                      fontSize: 11.5,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.more_vert_rounded,
                                              color: Colors.grey.shade500,
                                              size: 20,
                                            ),
                                            onSelected: (v) {
                                              if (v == 'edit') {
                                                _openForm(
                                                  existing: item,
                                                  index: index,
                                                );
                                              } else if (v == 'hapus') {
                                                _confirmDelete(index);
                                              }
                                            },
                                            itemBuilder: (context) => const [
                                              PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              PopupMenuItem(
                                                value: 'hapus',
                                                child: Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Progres Pertemuan',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          Text(
                                            '${item.totalSelesai}/${item.totalPertemuan} selesai',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: selesaiSemua
                                                  ? const Color(0xFF16A34A)
                                                  : widget.color,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: List.generate(
                                          item.sesiList.length,
                                          (sesiIndex) {
                                            final sesi =
                                                item.sesiList[sesiIndex];
                                            final selesai = sesi.selesai;
                                            return InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () =>
                                                  _toggleSesi(index, sesiIndex),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: selesai
                                                      ? const Color(0xFF16A34A)
                                                      : const Color(0xFFF4F6FB),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: selesai
                                                        ? const Color(
                                                            0xFF16A34A,
                                                          )
                                                        : Colors.grey.shade300,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    if (selesai)
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              right: 3,
                                                            ),
                                                        child: Icon(
                                                          Icons.check_rounded,
                                                          size: 11,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    Text(
                                                      '${sesi.tanggal.day}/${sesi.tanggal.month}',
                                                      style: TextStyle(
                                                        fontSize: 10.5,
                                                        color: selesai
                                                            ? Colors.white
                                                            : Colors
                                                                  .grey
                                                                  .shade700,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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
        backgroundColor: widget.color,
        shape: const CircleBorder(),
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}

/// Dialog kalender kustom untuk memilih BANYAK tanggal sekaligus (multi-select).
/// Bisa navigasi antar bulan, tap tanggal untuk toggle pilih/batal.
/// Area navigasi bulan + grid tanggal dibuat scrollable (Flexible +
/// SingleChildScrollView) dan tinggi dialog dibatasi (ConstrainedBox) agar
/// tidak overflow pada bulan dengan 6 baris tanggal atau layar kecil.
class _MultiDateCalendarDialog extends StatefulWidget {
  final Color themeColor;
  final List<DateTime> initialSelected;

  const _MultiDateCalendarDialog({
    required this.themeColor,
    required this.initialSelected,
  });

  @override
  State<_MultiDateCalendarDialog> createState() =>
      _MultiDateCalendarDialogState();
}

class _MultiDateCalendarDialogState extends State<_MultiDateCalendarDialog> {
  late DateTime _displayedMonth;
  late Set<DateTime> _selected;

  static const List<String> _hariLabel = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];
  static const List<String> _bulanLabel = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = widget.initialSelected.isNotEmpty
        ? DateTime(
            widget.initialSelected.first.year,
            widget.initialSelected.first.month,
          )
        : DateTime(now.year, now.month);
    _selected = widget.initialSelected
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
      );
    });
  }

  void _toggleDate(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final leadingBlanks = firstDayOfMonth.weekday - 1; // Senin = 1 -> 0 blank

    final sortedSelected = _selected.toList()..sort();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: judul + subjudul (selalu terlihat, di luar area scroll)
              Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    color: widget.themeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Pilih Tanggal Pertemuan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Tap tanggal untuk memilih atau membatalkan',
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 10),

              // ==== Bagian yang bisa di-scroll: navigasi bulan + grid tanggal ====
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Navigasi bulan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => _changeMonth(-1),
                            icon: const Icon(Icons.chevron_left_rounded),
                            color: widget.themeColor,
                          ),
                          Text(
                            '${_bulanLabel[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _changeMonth(1),
                            icon: const Icon(Icons.chevron_right_rounded),
                            color: widget.themeColor,
                          ),
                        ],
                      ),

                      // Label hari
                      Row(
                        children: _hariLabel
                            .map(
                              (h) => Expanded(
                                child: Center(
                                  child: Text(
                                    h,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 6),

                      // Grid tanggal
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              childAspectRatio: 1,
                            ),
                        itemCount: leadingBlanks + daysInMonth,
                        itemBuilder: (context, index) {
                          if (index < leadingBlanks) return const SizedBox();

                          final day = index - leadingBlanks + 1;
                          final date = DateTime(
                            _displayedMonth.year,
                            _displayedMonth.month,
                            day,
                          );
                          final key = DateTime(date.year, date.month, date.day);
                          final isSelected = _selected.contains(key);

                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _toggleDate(date),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? widget.themeColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isSelected
                                      ? null
                                      : Border.all(color: Colors.grey.shade200),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Ringkasan jumlah terpilih (selalu terlihat, di luar area scroll)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: widget.themeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sortedSelected.isEmpty
                      ? 'Belum ada tanggal dipilih'
                      : '${sortedSelected.length} tanggal dipilih',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: widget.themeColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 14),

              // Tombol Batal & OK (selalu terlihat, di luar area scroll)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, sortedSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.themeColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}