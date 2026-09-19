import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class ProgramKursusPage extends StatelessWidget {
  const ProgramKursusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: 'Program Kursus',
      titleIcon: Icons.menu_book_outlined,
      themeColor: const Color.fromARGB(255, 74, 166, 232),
      primaryFieldKey: 'nama',
      secondaryFieldKey: 'durasi',
      fields: const [
        CrudField(
          key: 'nama',
          label: 'Nama Program',
          icon: Icons.book_outlined,
        ),
        CrudField(
          key: 'durasi',
          label: 'Durasi (mis. 3 bulan)',
          icon: Icons.timelapse_outlined,
        ),
        CrudField(
          key: 'kuota',
          label: 'Kuota Peserta',
          icon: Icons.groups_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
      initialData: const [
        {'nama': 'Jaringan Komputer', 'durasi': '3 Bulan', 'kuota': '25'},
        {'nama': 'Desain Grafis', 'durasi': '2 Bulan', 'kuota': '20'},
      ],
    );
  }
}