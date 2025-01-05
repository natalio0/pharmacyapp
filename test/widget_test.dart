import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FutureBuilder displays data when future completes',
      (WidgetTester tester) async {
    // Arrange: Create a mock future that completes with a list of items
    final future = Future.delayed(
        Duration(seconds: 1), () => ['Item 1', 'Item 2', 'Item 3']);

    // Act: Build the widget tree with the FutureBuilder
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<String>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: snapshot.data!
                    .map((item) => ListTile(title: Text(item)))
                    .toList(),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    ));

    // Wait for the future to complete
    await tester.pumpAndSettle();

    // Assert: Verify that the items are displayed after the future completes
    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 3'), findsOneWidget);
  });
}
