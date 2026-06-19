import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/theme/theme.dart';
import 'package:veins/src/features/auth/login_page.dart';
import 'package:veins/src/core/models/user.dart';
import 'package:veins/src/features/home/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  User? _user;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onLogin(User user) {
    setState(() {
      _user = user;
    });
    setState(() {
      _isDarkMode = _user?.theme != 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Veins',
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: LoginPage(toggleTheme: _toggleTheme, onLogin: _onLogin)
    );
  }
}
