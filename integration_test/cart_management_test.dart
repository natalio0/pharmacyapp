import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pharmacyapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Management Tests', () {
    testWidgets('User adds a product to the cart', (tester) async {
      app.main();
      await tester
          .pumpAndSettle(); // Ensure all frames are settled before starting.

      final productItem = find.text('Paracetamol');
      final addToCartButton = find.text('Add to Cart');
      final cartButton = find.text('Cart');

      // Ensure the product is available before tapping
      expect(productItem, findsOneWidget);

      await tester.tap(productItem);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify that the cart contains the added product
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      expect(find.text('Paracetamol'), findsOneWidget);
    });
  });
}
