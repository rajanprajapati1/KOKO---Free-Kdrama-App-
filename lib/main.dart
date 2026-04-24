import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'theme/koko_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const KokoApp());
}

class KokoApp extends StatefulWidget {
  const KokoApp({super.key});

  /// Access the nearest KokoApp state to toggle theme
  static _KokoAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_KokoAppState>()!;
  }

  @override
  State<KokoApp> createState() => _KokoAppState();
}

class _KokoAppState extends State<KokoApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  bool get isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koko',
      debugShowCheckedModeBanner: false,
      theme: KokoTheme.lightTheme,
      darkTheme: KokoTheme.darkTheme,
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
