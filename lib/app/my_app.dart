import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/art_spin_screen.dart';
import '../services/data_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize DataService
    DataService().init();

    return MaterialApp(
      title: 'ArtStyle Factory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const ArtSpinScreen(),
    );
  }
}
