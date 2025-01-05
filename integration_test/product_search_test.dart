import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pharmacyapp/main.dart' as app;

void productSearchTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Product Search Tests', () {
    testWidgets('User searches for a product', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      final searchField = find.byType(TextField).first;
      final searchButton = find.text('Search');

      await tester.enterText(searchField, 'Paracetamol');
      await tester.tap(searchButton);

      await tester.pumpAndSettle();

      // Verify that the product is displayed in the search results
      expect(find.text('Paracetamol'), findsOneWidget);
    });
  });
}
