import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class PesertaPage extends StatelessWidget {
  const PesertaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: 'Peserta',
      titleIcon: Icons.people_alt_outlined,
      themeColor: const Color(0xFF00A896),
      primaryFieldKey: 'nama',
      secondaryFieldKey: 'program',
      fields: const [
        CrudField(
          key: 'nama',
          label: 'Nama Peserta',
          icon: Icons.person_outline,
        ),
        CrudField(
          key: 'jenisKelamin',
          label: 'Jenis Kelamin',
          icon: Icons.wc_outlined,
          type: CrudFieldType.dropdown,
          options: ['Laki-laki', 'Perempuan'],
        ),
        CrudField(
          key: 'ttl',
          label: 'Tempat, Tanggal Lahir',
          icon: Icons.cake_outlined,
        ),
        CrudField(
          key: 'alamat',
          label: 'Alamat Rumah',
          icon: Icons.home_outlined,
          keyboardType: TextInputType.multiline,
        ),
        CrudField(
          key: 'pendidikan',
          label: 'Pendidikan Terakhir',
          icon: Icons.school_outlined,
        ),
        CrudField(
          key: 'program',
          label: 'Program Kursus Diikuti',
          icon: Icons.menu_book_outlined,
        ),
        CrudField(
          key: 'telepon',
          label: 'No. Telepon',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        CrudField(
          key: 'foto',
          label: 'Foto',
          icon: Icons.camera_alt_outlined,
          type: CrudFieldType.photo,
          required: false,
        ),
      ],
      initialData: const [
        {
          'nama': 'Andi Pratama',
          'jenisKelamin': 'Laki-laki',
          'ttl': 'Tegal, 15 Juni 2001',
          'alamat': 'Jl. Kartini No. 8, Tegal',
          'pendidikan': 'SMA',
          'program': 'Jaringan Komputer',
          'telepon': '0812xxxxxxx',
          'foto': '',
        },
      ],
    );
  }
}