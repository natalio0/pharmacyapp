import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows home screen', (WidgetTester tester) async {
    // Build the widget tree (replace with actual widget)
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Welcome'), // Ensure this text is shown
        ),
      ),
    ));

    // Check if the "Welcome" text is displayed
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('Tapping button navigates to next screen',
      (WidgetTester tester) async {
    // Build the widget tree with a button
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          onPressed: () {
            // Replace with actual navigation logic
            Navigator.push(
              tester.element(find.byType(ElevatedButton)),
              MaterialPageRoute(builder: (context) => NextScreen()),
            );
          },
          child: Text('Go to next screen'),
        ),
      ),
    ));

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify if the next screen is displayed (check for a unique widget)
    expect(find.text('Next Screen'), findsOneWidget);
  });
}

// Define the next screen for navigation test
class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Next Screen')),
    );
  }
}
