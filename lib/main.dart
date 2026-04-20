import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'theme/koko_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const KokoApp());
}

class KokoApp extends StatelessWidget {
  const KokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koko',
      debugShowCheckedModeBanner: false,
      theme: KokoTheme.theme,
      home: const SplashScreen(),
    );
  }
}
