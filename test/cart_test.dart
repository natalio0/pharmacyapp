import 'package:flutter_test/flutter_test.dart';

class Cart {
  final List<String> _items = [];

  void addItem(String item) {
    _items.add(item);
  }

  void removeItem(String item) {
    _items.remove(item);
  }

  List<String> get items => _items;

  void clearCart() {
    _items.clear();
  }
}

void main() {
  late Cart cart;

  setUp(() {
    cart = Cart();
  });

  test('Add item to cart', () {
    cart.addItem('Paracetamol');
    // Expect that 'Paracetamol' is in the cart
    expect(cart.items, contains('Paracetamol'));
  });

  test('Remove item from cart', () {
    cart.addItem('Aspirin');
    cart.removeItem('Aspirin');
    // Expect that 'Aspirin' is not in the cart after removal
    expect(cart.items, isNot(contains('Aspirin')));
  });

  test('Cart is empty initially', () {
    // Expect that the cart is empty when first created
    expect(cart.items, isEmpty);
  });

  test('Clear all items in cart', () {
    cart.addItem('Paracetamol');
    cart.addItem('Aspirin');
    cart.clearCart();
    // Expect that the cart is empty after clearing
    expect(cart.items, isEmpty);
  });

  test('Cart contains multiple items', () {
    cart.addItem('Paracetamol');
    cart.addItem('Ibuprofen');
    // Expect that the cart contains 2 items
    expect(cart.items.length, 2);
    // Expect that the cart contains both items
    expect(cart.items, containsAll(['Paracetamol', 'Ibuprofen']));
  });
}
