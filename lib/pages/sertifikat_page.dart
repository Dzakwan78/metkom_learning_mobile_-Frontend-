import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class SertifikatPage extends StatelessWidget {
  const SertifikatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: 'Sertifikat',
      subtitle: 'Kelola sertifikat kelulusan peserta',
      titleIcon: Icons.workspace_premium_outlined,
      themeColor: const Color(0xFFCA8A04),
      primaryFieldKey: 'nama',
      secondaryFieldKey: 'program',
      fields: const [
        CrudField(
          key: 'nama',
          label: 'Nama Peserta',
          icon: Icons.person_outline,
        ),
        CrudField(
          key: 'program',
          label: 'Program Kursus',
          icon: Icons.menu_book_outlined,
        ),
        CrudField(
          key: 'noSertifikat',
          label: 'No. Sertifikat',
          icon: Icons.confirmation_number_outlined,
        ),
        CrudField(
          key: 'tanggalTerbit',
          label: 'Tanggal Terbit (contoh: 20/08/2026)',
          icon: Icons.calendar_today_outlined,
        ),
        CrudField(
          key: 'fileSertifikat',
          label: 'File Sertifikat (PDF/Gambar)',
          icon: Icons.upload_file_outlined,
          type: CrudFieldType.file,
          required: false,
        ),
      ],
      initialData: const [
        {
          'nama': 'Andi Pratama',
          'program': 'Jaringan Komputer',
          'noSertifikat': 'SIP/2026/001',
          'tanggalTerbit': '20/08/2026',
          'fileSertifikat': null,
        },
      ],
    );
  }
}