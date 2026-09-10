import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bungkus halaman utama (Home/Dashboard) dengan widget ini supaya
/// tombol back sistem butuh ditekan 2x dalam 2 detik untuk keluar aplikasi.
///
/// Cara pakai:
/// return ExitConfirmationWrapper(
///   child: Scaffold( ... ),
/// );
class ExitConfirmationWrapper extends StatefulWidget {
  final Widget child;

  const ExitConfirmationWrapper({super.key, required this.child});

  @override
  State<ExitConfirmationWrapper> createState() => _ExitConfirmationWrapperState();
}

class _ExitConfirmationWrapperState extends State<ExitConfirmationWrapper> {
  DateTime? _lastBackPressTime;

  Future<void> _handleBackPress() async {
    final now = DateTime.now();
    final isFirstPressOrExpired = _lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2);

    if (isFirstPressOrExpired) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tekan sekali lagi untuk keluar'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      SystemNavigator.pop(); // benar-benar keluar dari aplikasi
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: widget.child,
    );
  }
}