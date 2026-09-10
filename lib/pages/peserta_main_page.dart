import 'package:flutter/material.dart';
import 'peserta_dashboard_page.dart';
import 'sertifikat_saya_page.dart';
import 'profil_peserta_page.dart';

class PesertaMainPage extends StatefulWidget {
  final String username;

  const PesertaMainPage({super.key, required this.username});

  @override
  State<PesertaMainPage> createState() => _PesertaMainPageState();
}

class _PesertaMainPageState extends State<PesertaMainPage> {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      PesertaDashboardPage(username: widget.username),
      const SertifikatSayaPage(),
      ProfilPesertaPage(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1A3E9C).withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF1A3E9C)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            selectedIcon: Icon(Icons.workspace_premium_rounded, color: Color(0xFF1A3E9C)),
            label: 'Sertifikat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF1A3E9C)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}