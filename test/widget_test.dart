import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopiv/main.dart'; // Dosya yolunun doğru olduğundan emin olun

void main() {
  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(ShopiVApp());

    // Verify if the login screen appears.
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Enter username and password.
    await tester.enterText(find.byType(TextField).first, 'taha');
    await tester.enterText(find.byType(TextField).last, '123456');

    // Tap the login button.
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Verify if the home screen appears after login.
    expect(find.text('Categories'), findsOneWidget);
  });
}
