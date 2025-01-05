import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pharmacyapp/main.dart' as app;

void errorHandlingTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Error Handling Tests', () {
    testWidgets('Display error message for invalid login', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final loginButton = find.text('Login');

      await tester.enterText(emailField, 'wronguser@example.com');
      await tester.enterText(passwordField, 'wrongpassword');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that the error message is displayed
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
