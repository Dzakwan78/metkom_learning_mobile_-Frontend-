import 'package:flutter/material.dart';

/// Format angka jadi format rupiah dengan titik pemisah ribuan, misal 1250000 -> 1.250.000
String _formatRupiah(int amount) {
  final str = amount.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i != 0 && (str.length - i) % 3 == 0) buffer.write('.');
    buffer.write(str[i]);
  }
  return (amount < 0 ? '-Rp ' : 'Rp ') + buffer.toString();
}

class KelolaPembayaranPage extends StatefulWidget {
  const KelolaPembayaranPage({super.key});

  @override
  State<KelolaPembayaranPage> createState() => _KelolaPembayaranPageState();
}

class _KelolaPembayaranPageState extends State<KelolaPembayaranPage> {
  final Color themeColor = const Color(0xFF1A3E9C);

  bool _showSearch = false;
  String _searchQuery = '';
  String _statusFilter = 'Semua'; // Semua, Lunas, Cicilan, Belum Bayar
  final TextEditingController _searchController = TextEditingController();

  // Setiap item: nama, program, totalHarga (int), riwayat (List<{tanggal, jumlah}>)
  final List<Map<String, dynamic>> _items = [
    {
      'nama': 'Budi Santoso',
      'program': 'Aplikasi Perkantoran Admin Pro',
      'totalHarga': 849900,
      'riwayat': [
        {'tanggal': '12 Mei 2025', 'jumlah': 849900},
      ],
    },
    {
      'nama': 'Siti Aminah',
      'program': 'Aplikasi Perkantoran, 1 kelas 1 peserta',
      'totalHarga': 1250000,
      'riwayat': [
        {'tanggal': '10 Mei 2025', 'jumlah': 500000},
      ],
    },
    {
      'nama': 'Andi Wijaya',
      'program': 'Aplikasi Perkantoran Admin',
      'totalHarga': 1250000,
      'riwayat': [
        {'tanggal': '09 Mei 2025', 'jumlah': 1250000},
      ],
    },
    {
      'nama': 'Dewi Lestari',
      'program': 'Teknisi Komputer, 1 kelas 1 peserta',
      'totalHarga': 2700000,
      'riwayat': [
        {'tanggal': '08 Mei 2025', 'jumlah': 2700000},
      ],
    },
    {
      'nama': 'Eka Dzakwan',
      'program': 'AutoCad, 1 kelas 1 peserta',
      'totalHarga': 2250000,
      'riwayat': [],
    },
    {
      'nama': 'Eka Venarindra',
      'program': 'Desain Grafis, 1 kelas 1 peserta',
      'totalHarga': 1850000,
      'riwayat': [
        {'tanggal': '05 Mei 2025', 'jumlah': 1850000},
      ],
    },
  ];

  int _sudahBayar(Map<String, dynamic> item) {
    final riwayat = (item['riwayat'] as List).cast<Map<String, dynamic>>();
    return riwayat.fold<int>(0, (sum, r) => sum + (r['jumlah'] as int));
  }

  int _sisaBayar(Map<String, dynamic> item) => (item['totalHarga'] as int) - _sudahBayar(item);

  String _statusOf(Map<String, dynamic> item) {
    final sisa = _sisaBayar(item);
    final sudah = _sudahBayar(item);
    if (sisa <= 0) return 'Lunas';
    if (sudah > 0) return 'Cicilan';
    return 'Belum Bayar';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _items.where((item) {
      final matchSearch = _searchQuery.isEmpty ||
          (item['nama'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item['program'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatus = _statusFilter == 'Semua' || _statusOf(item) == _statusFilter;
      return matchSearch && matchStatus;
    }).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Lunas':
        return const Color(0xFF16A34A);
      case 'Cicilan':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFFDC2626);
    }
  }

  Color _statusBg(String status) {
    switch (status) {
      case 'Lunas':
        return const Color(0xFFDCFCE7);
      case 'Cicilan':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFFEE2E2);
    }
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

  void _openFilterSheet() {
    final options = ['Semua', 'Lunas', 'Cicilan', 'Belum Bayar'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.filter_list_rounded, color: themeColor),
                  const SizedBox(width: 10),
                  const Text('Filter Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
            ...options.map((status) => ListTile(
                  onTap: () {
                    setState(() => _statusFilter = status);
                    Navigator.pop(context);
                  },
                  leading: Icon(
                    _statusFilter == status ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: _statusFilter == status ? themeColor : Colors.grey.shade400,
                  ),
                  title: Text(status),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ==== Form tambah data pembayaran baru ====
  void _openAddPaymentForm() {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController();
    final programController = TextEditingController();
    final totalController = TextEditingController();
    final bayarAwalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
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
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const Text('Tambah Pembayaran',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 20),
              _buildField(namaController, 'Nama Peserta', Icons.person_outline),
              const SizedBox(height: 14),
              _buildField(programController, 'Program Kursus', Icons.menu_book_outlined),
              const SizedBox(height: 14),
              _buildField(totalController, 'Total Harga (angka saja)', Icons.payments_outlined,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 14),
              _buildField(
                bayarAwalController,
                'Bayar Pertama (opsional, angka saja)',
                Icons.account_balance_wallet_outlined,
                keyboardType: TextInputType.number,
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
                    final total = int.tryParse(totalController.text.trim()) ?? 0;
                    final bayarAwal = int.tryParse(bayarAwalController.text.trim()) ?? 0;
                    setState(() {
                      _items.add({
                        'nama': namaController.text.trim(),
                        'program': programController.text.trim(),
                        'totalHarga': total,
                        'riwayat': bayarAwal > 0
                            ? [
                                {'tanggal': 'Hari ini', 'jumlah': bayarAwal}
                              ]
                            : [],
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Form tambah cicilan baru untuk item tertentu ====
  void _openCicilanForm(int index) {
    final item = _items[index];
    final sisa = _sisaBayar(item);
    final formKey = GlobalKey<FormState>();
    final jumlahController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
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
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              Text('Bayar Cicilan — ${item['nama']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Text('Sisa tagihan: ${_formatRupiah(sisa)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 18),
              _buildField(jumlahController, 'Jumlah Bayar (angka saja)', Icons.payments_outlined,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final jumlah = int.tryParse(jumlahController.text.trim()) ?? 0;
                    if (jumlah <= 0) return;
                    setState(() {
                      (_items[index]['riwayat'] as List).add({'tanggal': 'Hari ini', 'jumlah': jumlah});
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Catat Pembayaran',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  void _showItemMenu(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payments_outlined, color: Color(0xFF16A34A)),
              title: const Text('Bayar Cicilan'),
              onTap: () {
                Navigator.pop(context);
                _openCicilanForm(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _items.removeAt(index));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;
    final totalTagihan = _items.fold<int>(0, (sum, i) => sum + (i['totalHarga'] as int));
    final totalMasuk = _items.fold<int>(0, (sum, i) => sum + _sudahBayar(i));
    final totalSisa = totalTagihan - totalMasuk;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header biru dengan back, judul, search & filter ====
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Kelola Pembayaran',
                            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Lacak cicilan & tagihan peserta', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _toggleSearch,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded,
                              color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _openFilterSheet,
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.filter_list_rounded, color: Colors.white, size: 22),
                            ),
                            if (_statusFilter != 'Semua')
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Color(0xFFFACC15), shape: BoxShape.circle),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
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
                                onChanged: (value) => setState(() => _searchQuery = value),
                                decoration: InputDecoration(
                                  hintText: 'Cari nama atau program...',
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

                    if (_statusFilter != 'Semua')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text('Status: $_statusFilter'),
                            backgroundColor: themeColor.withValues(alpha: 0.1),
                            labelStyle: TextStyle(color: themeColor, fontSize: 12, fontWeight: FontWeight.w600),
                            deleteIcon: Icon(Icons.close_rounded, size: 16, color: themeColor),
                            onDeleted: () => setState(() => _statusFilter = 'Semua'),
                            side: BorderSide.none,
                          ),
                        ),
                      ),

                    // ==== Ringkasan uang masuk & sisa tagihan ====
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Tagihan', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              Text(_formatRupiah(totalTagihan),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: totalTagihan > 0 ? totalMasuk / totalTagihan : 0,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFFEE2E2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sudah Masuk', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                                          Text(_formatRupiah(totalMasuk),
                                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sisa / Kurang', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                                          Text(_formatRupiah(totalSisa),
                                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text('Tidak ada data ditemukan', style: TextStyle(color: Colors.grey.shade600)),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final item = filtered[i];
                                final index = _items.indexOf(item);
                                final status = _statusOf(item);
                                final total = item['totalHarga'] as int;
                                final sudah = _sudahBayar(item);
                                final sisa = _sisaBayar(item);
                                final progress = total > 0 ? sudah / total : 0.0;
                                final nama = item['nama'] as String;
                                final initial = nama.isNotEmpty ? nama[0].toUpperCase() : '-';

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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: themeColor.withValues(alpha: 0.1),
                                            child: Text(initial,
                                                style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 14)),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(nama,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1E293B))),
                                                const SizedBox(height: 2),
                                                Text(item['program'] as String,
                                                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration:
                                                BoxDecoration(color: _statusBg(status), borderRadius: BorderRadius.circular(20)),
                                            child: Text(status,
                                                style: TextStyle(color: _statusColor(status), fontSize: 11, fontWeight: FontWeight.w700)),
                                          ),
                                          InkWell(
                                            onTap: () => _showItemMenu(index),
                                            borderRadius: BorderRadius.circular(14),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 4),
                                              child: Icon(Icons.more_vert_rounded, color: Colors.grey.shade500, size: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0, 1),
                                          minHeight: 6,
                                          backgroundColor: const Color(0xFFF3F5F9),
                                          valueColor: AlwaysStoppedAnimation<Color>(_statusColor(status)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${_formatRupiah(sudah)} / ${_formatRupiah(total)}',
                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                          Text(
                                            sisa > 0 ? 'Sisa ${_formatRupiah(sisa)}' : 'Lunas',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: sisa > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (sisa > 0) ...[
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 36,
                                          child: OutlinedButton.icon(
                                            onPressed: () => _openCicilanForm(index),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: themeColor.withValues(alpha: 0.4)),
                                              foregroundColor: themeColor,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                            icon: const Icon(Icons.add_rounded, size: 16),
                                            label: const Text('Catat Cicilan', style: TextStyle(fontSize: 12.5)),
                                          ),
                                        ),
                                      ],
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
        backgroundColor: const Color(0xFF16A34A),
        shape: const CircleBorder(),
        onPressed: _openAddPaymentForm,
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}