import 'package:flutter/material.dart';
import 'pages/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'METKOM LEARNING',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A3E9C),
        fontFamily: 'Roboto',
      ),
      home: const OnboardingPage(),
    );
  }
}