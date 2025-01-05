import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pharmacyapp/main.dart' as app;

void checkoutTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Checkout Tests', () {
    testWidgets('User proceeds to checkout', (tester) async {
      app.main();

      await tester.pumpAndSettle();

      final cartButton = find.text('Cart');
      final checkoutButton = find.text('Checkout');

      await tester.tap(cartButton);
      await tester.pumpAndSettle();

      // Proceed to checkout
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Verify that the checkout page is displayed
      expect(find.text('Checkout'), findsOneWidget);
    });
  });
}
