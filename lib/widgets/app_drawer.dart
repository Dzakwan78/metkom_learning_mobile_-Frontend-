import 'package:flutter/material.dart';
import '../pages/admin_page.dart';
import '../pages/instruktur_page.dart';
import '../pages/peserta_page.dart';
import '../pages/jadwal_page.dart';
import '../pages/program_kursus_page.dart';
import '../pages/login_page.dart';

class AppDrawer extends StatelessWidget {
  final String username;

  const AppDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A3E9C), Color(0xFF2F6FE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 34, color: Color(0xFF1A3E9C)),
                ),
                const SizedBox(height: 12),
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$username@sipjado.com',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _drawerItem(
                  context,
                  icon: Icons.home_outlined,
                  label: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _drawerItem(
                  context,
                  icon: Icons.admin_panel_settings_outlined,
                  label: 'Admin',
                  page: const AdminPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.school_outlined,
                  label: 'Instruktur',
                  page: const InstrukturPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.people_alt_outlined,
                  label: 'Peserta',
                  page: const PesertaPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.calendar_month_outlined,
                  label: 'Jadwal',
                  page: const JadwalPage(),
                ),
                _drawerItem(
                  context,
                  icon: Icons.menu_book_outlined,
                  label: 'Program Kursus',
                  page: const ProgramKursusPage(),
                ),
                const Divider(height: 24),
                _drawerItem(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
    Color iconColor = const Color(0xFF1A3E9C),
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(context); // tutup drawer dulu
            if (page != null) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => page));
            }
          },
    );
  }

  void _confirmLogout(BuildContext context) {
    Navigator.pop(context); // tutup drawer dulu
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
