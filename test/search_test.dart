import 'package:flutter_test/flutter_test.dart';

// The searchProducts function remains the same
List<String> searchProducts(String query, List<String> products) {
  return products
      .where((product) => product.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

void main() {
  test('Product search returns matching results', () {
    final products = ['Paracetamol', 'Aspirin', 'Ibuprofen'];
    final results = searchProducts('Para', products);

    // Expect that the result contains 'Paracetamol'
    expect(results, contains('Paracetamol'));

    // Expect that only 1 item matches the query
    expect(results.length, 1);
  });

  test('Product search returns empty if no match', () {
    final products = ['Paracetamol', 'Aspirin', 'Ibuprofen'];
    final results = searchProducts('Vitamin', products);

    // Expect that the result is empty because 'Vitamin' doesn't match any product
    expect(results, isEmpty);
  });

  test('Product search is case insensitive', () {
    final products = ['Paracetamol', 'Aspirin', 'Ibuprofen'];
    final results = searchProducts('para', products);

    // Expect that the search is case-insensitive and returns 'Paracetamol'
    expect(results, contains('Paracetamol'));
  });

  test('Product search returns multiple matches', () {
    final products = ['Paracetamol', 'Aspirin', 'Paracetamol Extra'];
    final results = searchProducts('Para', products);

    // Expect that 'Paracetamol' and 'Paracetamol Extra' match the query
    expect(results, contains('Paracetamol'));
    expect(results, contains('Paracetamol Extra'));

    // Expect that the length of the result is 2
    expect(results.length, 2);
  });
}
