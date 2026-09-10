import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class InstrukturPage extends StatelessWidget {
  const InstrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: 'Instruktur',
      titleIcon: Icons.school_outlined,
      themeColor: const Color(0xFF2F6FE0),
      primaryFieldKey: 'nama',
      secondaryFieldKey: 'keahlian',
      fields: const [
        CrudField(
          key: 'nama',
          label: 'Nama Instruktur',
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
          key: 'keahlian',
          label: 'Bidang Keahlian',
          icon: Icons.star_outline,
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
          'nama': 'Wahyu Dwi Atmoko',
          'jenisKelamin': 'Laki-laki',
          'ttl': 'Tegal, 12 Mei 1990',
          'alamat': 'Jl. Merdeka No. 10, Tegal',
          'pendidikan': 'S1 Teknik Informatika',
          'keahlian': 'Aplikasi Perkantoran',
          'telepon': '08167689546',
          'foto': null,
        },
        {
          'nama': 'Muhammad Maulana Yusuf',
          'jenisKelamin': 'Laki-laki',
          'ttl': 'Slawi, 03 Agustus 1988',
          'alamat': 'Jl. Diponegoro No. 22, Slawi',
          'pendidikan': 'S1 Sistem Informasi',
          'keahlian': 'Aplikasi Perkantoran',
          'telepon': '08123456789',
          'foto': null,
        },
        {
          'nama': 'Zulfikar',
          'jenisKelamin': 'Laki-laki',
          'ttl': 'Adiwerna, 20 Januari 1992',
          'alamat': 'Jl. Raya Adiwerna No. 5',
          'pendidikan': 'D3 Teknik Komputer',
          'keahlian': 'Teknisi Komputer',
          'telepon': '089875342187',
          'foto': null,
        },
      ],
    );
  }
}