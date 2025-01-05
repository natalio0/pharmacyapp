import '../../../domain/order/entities/product_ordered.dart';

class CartHelper {
  static double calculateCartSubtotal(List<ProductOrderedEntity> products) {
    double subtotalPrice = 0;
    for (var item in products) {
      // Membulatkan harga total setiap item sebelum menambahkan ke subtotal
      subtotalPrice += (item.totalPrice * 100).roundToDouble() / 100;
    }
    return subtotalPrice;
  }
}
