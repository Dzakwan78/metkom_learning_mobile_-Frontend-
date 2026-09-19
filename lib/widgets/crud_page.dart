import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// Tipe input untuk sebuah field form
enum CrudFieldType { text, dropdown, photo, file }

/// Definisi satu field form (dipakai untuk generate form tambah/edit otomatis)
class CrudField {
  final String key;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final bool required;
  final CrudFieldType type;
  final List<String>? options; // wajib diisi kalau type == dropdown

  const CrudField({
    required this.key,
    required this.label,
    this.icon = Icons.edit_outlined,
    this.keyboardType = TextInputType.text,
    this.required = true,
    this.type = CrudFieldType.text,
    this.options,
  });
}

/// Warna pill untuk nilai dropdown yang mirip "status". Kembalikan null
/// kalau nilainya bukan status yang dikenali (biar tetap pakai gaya chip biasa).
Color? _statusPillColor(String value) {
  switch (value) {
    case 'Selesai':
    case 'Lunas':
    case 'Aktif':
      return const Color(0xFF16A34A);
    case 'Terjadwal':
    case 'Pending':
    case 'Proses':
      return const Color(0xFFD97706);
    case 'Belum Bayar':
    case 'Batal':
    case 'Nonaktif':
      return const Color(0xFFDC2626);
    default:
      return null;
  }
}

Color _statusPillBg(String value) {
  switch (value) {
    case 'Selesai':
    case 'Lunas':
    case 'Aktif':
      return const Color(0xFFDCFCE7);
    case 'Terjadwal':
    case 'Pending':
    case 'Proses':
      return const Color(0xFFFEF3C7);
    default:
      return const Color(0xFFFEE2E2);
  }
}

/// Halaman CRUD generik: bisa dipakai untuk Admin, Instruktur, Peserta,
/// Jadwal, Program Kursus, dll — cukup beda [fields] dan [initialData].
class CrudPage extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Color themeColor;
  final IconData titleIcon;
  final List<CrudField> fields;
  final List<Map<String, dynamic>> initialData;
  final String primaryFieldKey; // field yang ditampilkan sebagai judul kartu
  final String secondaryFieldKey; // field yang ditampilkan sebagai subjudul

  const CrudPage({
    super.key,
    required this.title,
    required this.fields,
    required this.primaryFieldKey,
    required this.secondaryFieldKey,
    this.themeColor = const Color(0xFF1A3E9C),
    this.titleIcon = Icons.list_alt,
    this.initialData = const [],
    this.subtitle,
  });

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  late List<Map<String, dynamic>> _items;

  bool _showSearch = false;
  String _searchQuery = '';
  bool? _sortAscending; // null = urutan asli, true = A-Z, false = Z-A
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    var list = _items.where((item) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final primary = (item[widget.primaryFieldKey] as String? ?? '')
          .toLowerCase();
      final secondary = (item[widget.secondaryFieldKey] as String? ?? '')
          .toLowerCase();
      return primary.contains(query) || secondary.contains(query);
    }).toList();

    if (_sortAscending != null) {
      list.sort((a, b) {
        final cmp = (a[widget.primaryFieldKey] as String? ?? '')
            .toLowerCase()
            .compareTo(
              (b[widget.primaryFieldKey] as String? ?? '').toLowerCase(),
            );
        return _sortAscending! ? cmp : -cmp;
      });
    }
    return list;
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
                  Icon(Icons.filter_list_rounded, color: widget.themeColor),
                  const SizedBox(width: 10),
                  const Text(
                    'Urutkan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
            _filterOptionTile(
              context,
              label: 'Default (urutan ditambahkan)',
              selected: _sortAscending == null,
              onTap: () {
                setState(() => _sortAscending = null);
                Navigator.pop(context);
              },
            ),
            _filterOptionTile(
              context,
              label: 'Nama A - Z',
              selected: _sortAscending == true,
              onTap: () {
                setState(() => _sortAscending = true);
                Navigator.pop(context);
              },
            ),
            _filterOptionTile(
              context,
              label: 'Nama Z - A',
              selected: _sortAscending == false,
              onTap: () {
                setState(() => _sortAscending = false);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _filterOptionTile(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_off_rounded,
        color: selected ? widget.themeColor : Colors.grey.shade400,
      ),
      title: Text(label),
    );
  }

  void _openForm({Map<String, dynamic>? existing, int? index}) {
    final formKey = GlobalKey<FormState>();
    final textFields = widget.fields.where(
      (f) => f.type != CrudFieldType.photo && f.type != CrudFieldType.file,
    );
    final photoFields = widget.fields.where(
      (f) => f.type == CrudFieldType.photo,
    );
    final fileFields = widget.fields.where((f) => f.type == CrudFieldType.file);

    final controllers = {
      for (final field in textFields)
        field.key: TextEditingController(
          text: existing?[field.key] as String? ?? '',
        ),
    };
    final dropdownValues = {
      for (final field in textFields.where(
        (f) => f.type == CrudFieldType.dropdown,
      ))
        field.key: (existing?[field.key] as String?)?.isNotEmpty == true
            ? existing![field.key] as String?
            : null,
    };
    final photoBytes = <String, Uint8List?>{
      for (final field in photoFields)
        field.key: (existing?[field.key] is Uint8List)
            ? existing![field.key] as Uint8List
            : null,
    };
    final fileData = <String, Map<String, dynamic>?>{
      for (final field in fileFields)
        field.key: (existing?[field.key] is Map)
            ? Map<String, dynamic>.from(existing![field.key] as Map)
            : null,
    };

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
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.themeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                widget.titleIcon,
                                color: widget.themeColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              existing == null
                                  ? 'Tambah ${widget.title}'
                                  : 'Edit ${widget.title}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),

                        // ==== Field foto (kalau ada), ditaruh paling atas & di tengah ====
                        ...photoFields.map(
                          (field) => Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final picked = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 75,
                                  );
                                  if (picked == null) return;
                                  final bytes = await picked.readAsBytes();
                                  setSheetState(
                                    () => photoBytes[field.key] = bytes,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F6FB),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: widget.themeColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1.5,
                                        ),
                                        image: photoBytes[field.key] != null
                                            ? DecorationImage(
                                                image: MemoryImage(
                                                  photoBytes[field.key]!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: photoBytes[field.key] == null
                                          ? Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 34,
                                              color: widget.themeColor
                                                  .withValues(alpha: 0.6),
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: widget.themeColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ==== Field upload file (PDF/Gambar) ====
                        ...fileFields.map(
                          (field) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                final result = await FilePicker.platform
                                    .pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'pdf',
                                        'jpg',
                                        'jpeg',
                                        'png',
                                      ],
                                      withData: true,
                                    );
                                if (result == null || result.files.isEmpty) {
                                  return;
                                }
                                final picked = result.files.single;
                                setSheetState(
                                  () => fileData[field.key] = {
                                    'name': picked.name,
                                    'bytes': picked.bytes,
                                  },
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: widget.themeColor.withValues(
                                      alpha: 0.25,
                                    ),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      fileData[field.key] != null
                                          ? Icons.description_rounded
                                          : Icons.upload_file_rounded,
                                      color: widget.themeColor,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            field.label,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            fileData[field.key]?['name']
                                                    as String? ??
                                                'Belum ada file dipilih',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: fileData[field.key] != null
                                                  ? const Color(0xFF1E293B)
                                                  : Colors.grey.shade500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (fileData[field.key] != null)
                                      InkWell(
                                        onTap: () => setSheetState(
                                          () => fileData[field.key] = null,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.close_rounded,
                                            size: 18,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      )
                                    else
                                      Text(
                                        'Pilih',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: widget.themeColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ==== Field teks & dropdown ====
                        ...textFields.map((field) {
                          if (field.type == CrudFieldType.dropdown) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: DropdownButtonFormField<String>(
                                initialValue: dropdownValues[field.key],
                                decoration: InputDecoration(
                                  labelText: field.label,
                                  prefixIcon: Icon(
                                    field.icon,
                                    size: 20,
                                    color: widget.themeColor,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF4F6FB),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: widget.themeColor,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                items: (field.options ?? [])
                                    .map(
                                      (opt) => DropdownMenuItem(
                                        value: opt,
                                        child: Text(opt),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setSheetState(
                                  () => dropdownValues[field.key] = value,
                                ),
                                validator: (value) {
                                  if (field.required &&
                                      (value == null || value.isEmpty)) {
                                    return '${field.label} wajib dipilih';
                                  }
                                  return null;
                                },
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: TextFormField(
                              controller: controllers[field.key],
                              keyboardType: field.keyboardType,
                              maxLines:
                                  field.keyboardType == TextInputType.multiline
                                  ? 3
                                  : 1,
                              decoration: InputDecoration(
                                labelText: field.label,
                                prefixIcon: Icon(
                                  field.icon,
                                  size: 20,
                                  color: widget.themeColor,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF4F6FB),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: widget.themeColor,
                                    width: 1.4,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (field.required &&
                                    (value == null || value.trim().isEmpty)) {
                                  return '${field.label} wajib diisi';
                                }
                                return null;
                              },
                            ),
                          );
                        }),

                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.themeColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;

                              final newItem = <String, dynamic>{
                                for (final field in textFields)
                                  field.key:
                                      field.type == CrudFieldType.dropdown
                                      ? (dropdownValues[field.key] ?? '')
                                      : controllers[field.key]!.text.trim(),
                                for (final field in photoFields)
                                  field.key: photoBytes[field.key],
                                for (final field in fileFields)
                                  field.key: fileData[field.key],
                              };

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
                                fontSize: 15,
                              ),
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
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Hapus Data'),
        content: Text(
          'Yakin ingin menghapus ${_items[index][widget.primaryFieldKey]}?',
        ),
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
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: Column(
        children: [
          // ==== Header biru dengan back, judul, search & filter ====
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
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.subtitle ??
                              'Kelola semua data ${widget.title.toLowerCase()}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
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
                          child: Icon(
                            _showSearch
                                ? Icons.close_rounded
                                : Icons.search_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _openFilterSheet,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.filter_list_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==== Sheet putih melengkung menutupi bagian bawah header ====
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

                    // Kotak pencarian (muncul kalau ikon search ditekan)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _showSearch
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                onChanged: (value) =>
                                    setState(() => _searchQuery = value),
                                decoration: InputDecoration(
                                  hintText:
                                      'Cari ${widget.title.toLowerCase()}...',
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: widget.themeColor,
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Kartu ringkasan total data
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
                              color: widget.themeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.titleIcon,
                              color: widget.themeColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            '${filtered.length}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Total ${widget.title}'
                                : 'Hasil pencarian ${widget.title}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (_sortAscending != null) ...[
                            const Spacer(),
                            Icon(
                              _sortAscending!
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 16,
                              color: widget.themeColor,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: widget.themeColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _searchQuery.isEmpty
                                          ? widget.titleIcon
                                          : Icons.search_off_rounded,
                                      size: 48,
                                      color: widget.themeColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? 'Belum ada data ${widget.title}'
                                        : 'Tidak ditemukan "$_searchQuery"',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _searchQuery.isEmpty
                                        ? 'Tekan tombol + untuk menambahkan'
                                        : 'Coba kata kunci lain',
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
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final item = filtered[i];
                                final index = _items.indexOf(item);
                                final initial =
                                    (item[widget.primaryFieldKey] as String? ??
                                            '-')
                                        .trim();
                                final extraFields = widget.fields.where(
                                  (f) =>
                                      f.key != widget.primaryFieldKey &&
                                      f.key != widget.secondaryFieldKey &&
                                      f.type != CrudFieldType.photo,
                                );
                                final photoKeys = widget.fields
                                    .where((f) => f.type == CrudFieldType.photo)
                                    .map((f) => f.key);
                                final photoField = photoKeys.isNotEmpty
                                    ? photoKeys.first
                                    : null;
                                final photoBytes =
                                    (photoField != null &&
                                        item[photoField] is Uint8List)
                                    ? item[photoField] as Uint8List
                                    : null;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundColor: widget.themeColor
                                            .withValues(alpha: 0.12),
                                        backgroundImage: photoBytes != null
                                            ? MemoryImage(photoBytes)
                                            : null,
                                        child: photoBytes == null
                                            ? Text(
                                                initial.isNotEmpty
                                                    ? initial[0].toUpperCase()
                                                    : '-',
                                                style: TextStyle(
                                                  color: widget.themeColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item[widget.primaryFieldKey]
                                                      as String? ??
                                                  '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              item[widget.secondaryFieldKey]
                                                      as String? ??
                                                  '-',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            if (extraFields.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Wrap(
                                                spacing: 6,
                                                runSpacing: 6,
                                                children: extraFields.map((f) {
                                                  String val;
                                                  if (f.type ==
                                                      CrudFieldType.file) {
                                                    final fileVal = item[f.key];
                                                    if (fileVal is! Map ||
                                                        fileVal['name'] ==
                                                            null) {
                                                      return const SizedBox.shrink();
                                                    }
                                                    val =
                                                        fileVal['name']
                                                            as String;
                                                  } else {
                                                    val =
                                                        item[f.key]
                                                            as String? ??
                                                        '';
                                                  }
                                                  if (val.isEmpty) {
                                                    return const SizedBox.shrink();
                                                  }

                                                  // Kalau nilainya kata-kata status yang dikenali,
                                                  // tampilkan sebagai pill berwarna, bukan chip biasa.
                                                  final statusColor =
                                                      _statusPillColor(val);
                                                  if (statusColor != null) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: _statusPillBg(
                                                          val,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        val,
                                                        style: TextStyle(
                                                          fontSize: 10.5,
                                                          color: statusColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 9,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: widget.themeColor
                                                          .withValues(
                                                            alpha: 0.07,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          f.icon,
                                                          size: 11,
                                                          color:
                                                              widget.themeColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          val,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: widget
                                                                .themeColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _openForm(
                                              existing: item,
                                              index: index,
                                            );
                                          } else if (value == 'hapus') {
                                            _confirmDelete(index);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_outlined,
                                                  size: 18,
                                                  color: Color(0xFFD97706),
                                                ),
                                                SizedBox(width: 10),
                                                Text('Edit'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'hapus',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_outline,
                                                  size: 18,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 10),
                                                Text('Hapus'),
                                              ],
                                            ),
                                          ),
                                        ],
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
        backgroundColor: widget.themeColor,
        shape: const CircleBorder(),
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 26),
      ),
    );
  }
}