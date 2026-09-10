import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentIndex < _slides.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel(); // berhenti otomatis di slide terakhir
      }
    });
  }

  final List<_OnboardData> _slides = const [
    _OnboardData(
      icon: Icons.error_outline_rounded,
      title: 'Atur Jadwal Masih Manual?',
      description: 'Catat jadwal kursus masih menggunaka kertas atau Excel sering bikin bentrok jadwal dan data instruktur berantakan.',
    ),
    _OnboardData(
      icon: Icons.check_circle_outline_rounded,
      title: 'Metkom Learning Solusinya',
      description: 'Semua jadwal, data petugas, dan laporan terkelola otomatis dalam satu aplikasi — rapi dan minim salah.',
    ),
    _OnboardData(
      icon: Icons.playlist_add_check_rounded,
      title: 'Cara Kerjanya Mudah',
      description: 'Masuk ke akun, admin atur jadwal & instruktur, lalu instruktur bisa cek jadwal dan informasi lainnya langsung lewat aplikasi.',
    ),
  ];

  void _goToWelcome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  }

  void _next() {
    if (_currentIndex == _slides.length - 1) {
      _goToWelcome();
    } else {
      _autoSlideTimer?.cancel();
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentIndex == _slides.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3E9C), Color(0xFF2F6FE0)],
          ),
        ),
        child: Stack(
          children: [
            // Lingkaran dekoratif transparan di background
            Positioned(
              top: -60,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: -70,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // Tombol lewati
                  if (!isLast)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                        child: TextButton(
                          onPressed: _goToWelcome,
                          child: Text(
                            'Lewati',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),

                  // Slide yang bisa di-swipe
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _slides.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                        _autoSlideTimer?.cancel();
                        _startAutoSlide();
                      },
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon dengan lapisan lingkaran dekoratif
                              SizedBox(
                                width: 190,
                                height: 190,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                    Container(
                                      width: 148,
                                      height: 148,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.14),
                                      ),
                                    ),
                                    Container(
                                      width: 108,
                                      height: 108,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Icon(slide.icon, size: 52, color: const Color(0xFF1A3E9C)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 44),
                              Text(
                                slide.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                slide.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Kartu putih melengkung di bawah: indikator + tombol
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Indikator titik
                        Row(
                          children: List.generate(
                            _slides.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 6),
                              width: _currentIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? const Color(0xFF1A3E9C)
                                    : const Color(0xFFDCE3F7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        // Tombol lanjut: lingkaran biasa, atau pill "Mulai" di slide terakhir
                        isLast
                            ? ElevatedButton(
                                onPressed: _next,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A3E9C),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Mulai',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: _next,
                                borderRadius: BorderRadius.circular(28),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1A3E9C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardData({
    required this.icon,
    required this.title,
    required this.description,
  });
}