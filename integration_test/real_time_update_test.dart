import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pharmacyapp/main.dart' as app;

void realTimeUpdateTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Real-time Update Tests', () {
    testWidgets('Real-time updates are reflected', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      final newProduct = find.text('Aspirin');
      final addProductButton = find.text('Add Product');

      // Simulate a product being added
      await tester.tap(addProductButton);
      await tester.pumpAndSettle();

      // Verify that the new product is displayed
      expect(newProduct, findsOneWidget);
    });
  });
}
