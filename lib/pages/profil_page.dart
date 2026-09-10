import 'package:flutter/material.dart';
import 'welcome_page.dart';

class ProfilPage extends StatefulWidget {
  final String username;

  const ProfilPage({super.key, required this.username});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late String _nama;
  String _email = 'admin@metkomlearning.com';
  String _telepon = '-';
  String _password = 'admin123'; // dummy, khusus validasi di halaman ini

  @override
  void initState() {
    super.initState();
    _nama = widget.username;
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomePage()),
                (route) => false,
              );
            },
            child: const Text('Keluar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  // ==== Form Edit Profil ====
  void _openEditProfil() {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: _nama);
    final emailController = TextEditingController(text: _email);
    final teleponController = TextEditingController(text: _telepon == '-' ? '' : _telepon);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const Text('Edit Profil',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 20),
              _buildField(namaController, 'Nama', Icons.person_outline),
              const SizedBox(height: 14),
              _buildField(emailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildField(teleponController, 'No. Telepon', Icons.phone_outlined,
                  keyboardType: TextInputType.phone, required: false),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3E9C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    setState(() {
                      _nama = namaController.text.trim();
                      _email = emailController.text.trim();
                      _telepon = teleponController.text.trim().isEmpty ? '-' : teleponController.text.trim();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil berhasil diperbarui')),
                    );
                  },
                  child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==== Form Ubah Password ====
  void _openUbahPassword() {
    final formKey = GlobalKey<FormState>();
    final lamaController = TextEditingController();
    final baruController = TextEditingController();
    final konfirmasiController = TextEditingController();
    bool obscureLama = true, obscureBaru = true, obscureKonfirmasi = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const Text('Ubah Password',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 20),
                _buildField(
                  lamaController,
                  'Password Lama',
                  Icons.lock_outline,
                  obscureText: obscureLama,
                  onToggleObscure: () => setSheetState(() => obscureLama = !obscureLama),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password lama wajib diisi';
                    if (value != _password) return 'Password lama tidak cocok';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildField(
                  baruController,
                  'Password Baru',
                  Icons.lock_outline,
                  obscureText: obscureBaru,
                  onToggleObscure: () => setSheetState(() => obscureBaru = !obscureBaru),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password baru wajib diisi';
                    if (value.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildField(
                  konfirmasiController,
                  'Konfirmasi Password Baru',
                  Icons.lock_outline,
                  obscureText: obscureKonfirmasi,
                  onToggleObscure: () => setSheetState(() => obscureKonfirmasi = !obscureKonfirmasi),
                  validator: (value) {
                    if (value != baruController.text) return 'Konfirmasi password tidak cocok';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A3E9C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      setState(() => _password = baruController.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password berhasil diubah')),
                      );
                    },
                    child: const Text('Ubah Password',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1A3E9C)),
        suffixIcon: onToggleObscure != null
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF4F6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1A3E9C), width: 1.4),
        ),
      ),
      validator: validator ??
          (value) {
            if (required && (value == null || value.trim().isEmpty)) return '$label wajib diisi';
            return null;
          },
    );
  }

  // ==== Halaman Tentang Aplikasi ====
  void _openTentangAplikasi() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: const Color(0xFFF3F5F9),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A3E9C),
            foregroundColor: Colors.white,
            title: const Text('Tentang Aplikasi'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A3E9C), Color(0xFF2F6FE0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.event_note_rounded, color: Colors.white, size: 44),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: 'METKOM', style: TextStyle(color: Color(0xFF1E293B))),
                      TextSpan(text: 'LEARNING', style: TextStyle(color: Color(0xFF1A3E9C))),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text('Versi 1.0.0', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Text(
                    'METKOM LEARNING adalah aplikasi untuk mengelola jadwal, '
                    'peserta, instruktur, program kursus, sertifikat, dan pembayaran dalam satu tempat — '
                    'baik untuk admin maupun peserta kursus.',
                    style: TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF334155)),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dikembangkan untuk keperluan internal instansi.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text('© 2026 METKOM LEARNING', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 20),

              // ==== Kartu identitas ====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A3E9C), Color(0xFF2F6FE0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        _nama.isNotEmpty ? _nama[0].toUpperCase() : '-',
                        style: const TextStyle(color: Color(0xFF1A3E9C), fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nama,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Administrator',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_email, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                          if (_telepon != '-') Text(_telepon, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              const Text(
                'Pengaturan Akun',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2563EB),
                iconBg: const Color(0xFFDBEAFE),
                label: 'Edit Profil',
                onTap: _openEditProfil,
              ),
              _ProfileMenuTile(
                icon: Icons.lock_outline_rounded,
                iconColor: const Color(0xFF9333EA),
                iconBg: const Color(0xFFF3E8FF),
                label: 'Ubah Password',
                onTap: _openUbahPassword,
              ),
              const SizedBox(height: 20),

              const Text(
                'Lainnya',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF0D9488),
                iconBg: const Color(0xFFCCFBF1),
                label: 'Tentang Aplikasi',
                onTap: _openTentangAplikasi,
              ),
              _ProfileMenuTile(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFDC2626),
                iconBg: const Color(0xFFFEE2E2),
                label: 'Keluar',
                labelColor: const Color(0xFFDC2626),
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(11)),
                  child: Icon(icon, color: iconColor, size: 19),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor ?? const Color(0xFF1E293B),
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}