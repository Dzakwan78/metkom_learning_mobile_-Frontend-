import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/info_event.dart';

class InfoEventSection extends StatefulWidget {
  const InfoEventSection({super.key});

  @override
  State<InfoEventSection> createState() => _InfoEventSectionState();
}

class _InfoEventSectionState extends State<InfoEventSection> {
  final List<InfoEvent> _events = [
    InfoEvent(
      title: 'Pembukaan Pendaftaran Batch Baru',
      description:
          'Pendaftaran peserta kursus batch berikutnya resmi dibuka. Segera daftarkan diri Anda sebelum kuota penuh.',
      youtubeLink: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  void _openForm({InfoEvent? existing, int? index}) {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final youtubeController = TextEditingController(
      text: existing?.youtubeLink ?? '',
    );
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    String? pickedImagePath = existing?.imagePath;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage(ImageSource source) async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: source,
                imageQuality: 80,
              );
              if (picked != null) {
                setModalState(() => pickedImagePath = picked.path);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        existing == null
                            ? 'Tambah Informasi/Event'
                            : 'Edit Informasi/Event',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3E9C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // PREVIEW & PILIH FOTO
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_library_outlined,
                                  ),
                                  title: const Text('Pilih dari Galeri'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickImage(ImageSource.gallery);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.photo_camera_outlined,
                                  ),
                                  title: const Text('Ambil Foto'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    pickImage(ImageSource.camera);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: pickedImagePath != null
                              ? Image.file(
                                  File(pickedImagePath!),
                                  fit: BoxFit.cover,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.grey.shade500,
                                      size: 30,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Ketuk untuk tambah foto',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Judul Informasi/Event',
                          prefixIcon: const Icon(
                            Icons.title_outlined,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: youtubeController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: 'Link Video YouTube (opsional)',
                          hintText: 'https://youtube.com/watch?v=...',
                          prefixIcon: const Icon(
                            Icons.ondemand_video_outlined,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final valid =
                                value.contains('youtube.com') ||
                                value.contains('youtu.be');
                            if (!valid) return 'Link YouTube tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: descController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(
                            Icons.description_outlined,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3E9C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final newEvent = InfoEvent(
                              title: titleController.text.trim(),
                              imagePath: pickedImagePath,
                              youtubeLink: youtubeController.text.trim(),
                              description: descController.text.trim(),
                            );

                            setState(() {
                              if (index != null) {
                                _events[index] = newEvent;
                              } else {
                                _events.add(newEvent);
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

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Informasi/Event'),
        content: Text('Yakin ingin menghapus "${_events[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _events.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openYoutubeLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka link video')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Informasi & Event',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add, size: 18, color: Color(0xFF1A3E9C)),
              label: const Text(
                'Tambah',
                style: TextStyle(
                  color: Color(0xFF1A3E9C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_events.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 44,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  'Belum ada informasi/event',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _events.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final event = _events[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.imagePath != null)
                      Image.file(
                        File(event.imagePath!),
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: const Color(0xFFF3F5F9),
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.grey.shade400,
                          size: 36,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            event.description,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                          if (event.youtubeLink.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => _openYoutubeLink(event.youtubeLink),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Tonton Video',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _openForm(existing: event, index: index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _confirmDelete(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
