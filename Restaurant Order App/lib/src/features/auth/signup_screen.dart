import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Sign Up'),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoFormSection.insetGrouped(
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: 'Email',
                  prefix: const Icon(CupertinoIcons.mail),
                  keyboardType: TextInputType.emailAddress,
                ),
                CupertinoTextFormFieldRow(
                  placeholder: 'Password',
                  prefix: const Icon(CupertinoIcons.lock),
                  obscureText: true,
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () {},
                  child: const Text('Sign Up'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
