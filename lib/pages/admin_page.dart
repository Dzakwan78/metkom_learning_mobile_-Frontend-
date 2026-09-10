import 'package:flutter/material.dart';
import '../widgets/crud_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CrudPage(
      title: 'Admin',
      titleIcon: Icons.admin_panel_settings_outlined,
      themeColor: const Color(0xFF1A3E9C),
      primaryFieldKey: 'nama',
      secondaryFieldKey: 'email',
      fields: const [
        CrudField(key: 'nama', label: 'Nama Admin', icon: Icons.person_outline),
        CrudField(
          key: 'email',
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        CrudField(
          key: 'username',
          label: 'Username',
          icon: Icons.alternate_email,
        ),
      ],
      initialData: const [
        {
          'nama': 'Mark Wijaya',
          'email': 'mark@sipjado.com',
          'username': 'mark_admin',
        },
      ],
    );
  }
}
