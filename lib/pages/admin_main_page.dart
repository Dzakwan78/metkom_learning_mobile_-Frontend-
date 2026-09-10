import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'sertifikat_page.dart';
import 'profil_page.dart';
import '../widgets/exit_confirmation_wrapper.dart';

class AdminMainPage extends StatefulWidget {
  final String username;

  const AdminMainPage({super.key, required this.username});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _index = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(username: widget.username),
      const SertifikatPage(),
      ProfilPage(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationWrapper(
      child: Scaffold(
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
      ),
    );
  }
}