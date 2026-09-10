import 'package:flutter/material.dart';
import '../pages/admin_page.dart';
import '../pages/instruktur_page.dart';
import '../pages/peserta_page.dart';
import '../pages/jadwal_page.dart';
import '../pages/program_kursus_page.dart';
import '../pages/kelola_pembayaran_page.dart';

class MenuGridItem {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const MenuGridItem({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}

class MenuGridSection extends StatelessWidget {
  final List<MenuGridItem> items;

  const MenuGridSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==== Daftar menu SIPJADO dengan navigasi asli ====
// Cara pakai di halaman kakak: MenuGridSection(items: sipjadoMenuItems(context))
List<MenuGridItem> sipjadoMenuItems(BuildContext context) {
  void goTo(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  return [
    MenuGridItem(
      icon: Icons.admin_panel_settings_rounded,
      label: 'Admin',
      bgColor: const Color(0xFFE0E7FF),
      iconColor: const Color(0xFF4F46E5),
      onTap: () => goTo(const AdminPage()),
    ),
    MenuGridItem(
      icon: Icons.school_rounded,
      label: 'Instruktur',
      bgColor: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFD97706),
      onTap: () => goTo(const InstrukturPage()),
    ),
    MenuGridItem(
      icon: Icons.groups_rounded,
      label: 'Peserta',
      bgColor: const Color(0xFFCCFBF1),
      iconColor: const Color(0xFF0D9488),
      onTap: () => goTo(const PesertaPage()),
    ),
    MenuGridItem(
      icon: Icons.calendar_month_rounded,
      label: 'Jadwal',
      bgColor: const Color(0xFFDBEAFE),
      iconColor: const Color(0xFF2563EB),
      onTap: () => goTo(const JadwalPage()),
    ),
    MenuGridItem(
      icon: Icons.menu_book_rounded,
      label: 'Program Kursus',
      bgColor: const Color(0xFFF3E8FF),
      iconColor: const Color(0xFF9333EA),
      onTap: () => goTo(const ProgramKursusPage()),
    ),
    MenuGridItem(
      icon: Icons.payments_rounded,
      label: 'Pembayaran',
      bgColor: const Color(0xFFDCFCE7),
      iconColor: const Color(0xFF16A34A),
      onTap: () => goTo(const KelolaPembayaranPage()),
    ),
  ];
}