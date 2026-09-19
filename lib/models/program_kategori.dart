import 'package:flutter/material.dart';

class ProgramKategori {
  final String nama;
  final IconData icon;
  final Color color;

  const ProgramKategori({
    required this.nama,
    required this.icon,
    required this.color,
  });
}

const List<ProgramKategori> daftarProgramKategori = [
  ProgramKategori(
    nama: 'Aplikasi Perkantoran',
    icon: Icons.description_outlined,
    color: Color(0xFF2F6FE0),
  ),
  ProgramKategori(
    nama: 'Desain Grafis',
    icon: Icons.brush_outlined,
    color: Color(0xFFE0468B),
  ),
  ProgramKategori(
    nama: 'Auto CAD',
    icon: Icons.architecture_outlined,
    color: Color(0xFFCDA400),
  ),
  ProgramKategori(
    nama: 'Teknisi Komputer',
    icon: Icons.build_outlined,
    color: Color(0xFF00A896),
  ),
  ProgramKategori(
    nama: 'Pemrograman',
    icon: Icons.code_rounded,
    color: Color(0xFF7C3AED),
  ),
];