import 'package:veins/src/features/auth/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:veins/src/features/home/home_page.dart';
import 'package:veins/src/core/models/user.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final Function(User) onLogin;

  const LoginPage({super.key, required this.toggleTheme, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isLoading = false;
  final bool _obscure = true;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final String response = await rootBundle.loadString('users.json');
    final data = await json.decode(response) as List;
    final users = data.map((i) => User.fromJson(i)).toList();

    try {
      final user = users.firstWhere(
        (u) => u.username == _username && u.password == _password,
      );

      widget.onLogin(user);

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (_) =>
                HomePage(user: user, toggleTheme: widget.toggleTheme)),
      );
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: CupertinoFormSection.insetGrouped(
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: 'Username',
                    prefix: const Icon(CupertinoIcons.person),
                    autocorrect: false,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      return null;
                    },
                    onSaved: (v) => _username = v!.trim(),
                  ),
                  CupertinoTextFormFieldRow(
                    placeholder: 'Password',
                    prefix: const Icon(CupertinoIcons.lock),
                    obscureText: _obscure,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      return null;
                    },
                    onSaved: (v) => _password = v!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const SignUpScreen()),
                );
              },
              child: const Text('Not a user? Sign up'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : const Text('Log In'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
