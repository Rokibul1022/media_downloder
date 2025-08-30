import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Assume this file exists with your Firebase config
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/platform_grid_screen.dart';
import 'screens/download_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Downloader',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return PlatformGridScreen(
              toggleTheme: _toggleTheme,
              isDarkMode: _isDarkMode,
            );
          }
          return HomeScreen(
            toggleTheme: _toggleTheme,
            isDarkMode: _isDarkMode,
          );
        },
      ),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/platforms': (context) => PlatformGridScreen(
              toggleTheme: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
        '/download': (context) => const DownloadScreen(),
        '/history': (context) => HistoryScreen(
              toggleTheme: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
      },
    );
  }
}