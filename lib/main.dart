import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CorinaApp());
}

class CorinaApp extends StatelessWidget {
  const CorinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Perrita Corina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const LoginScreen(), 
    );
  }
}