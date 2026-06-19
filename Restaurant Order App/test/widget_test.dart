// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veins/src/app.dart';
import 'package:veins/src/features/auth/login_page.dart';

void main() {
  testWidgets('Renders LoginPage on startup', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginPage is present.
    expect(find.byType(LoginPage), findsOneWidget);
    
    // Verify that a login button is present.
    expect(find.widgetWithText(CupertinoButton, 'Log In'), findsOneWidget);
  });
}