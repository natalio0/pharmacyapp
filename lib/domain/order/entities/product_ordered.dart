class ProductOrderedEntity {
  final String productId;
  final String productTitle;
  final int productQuantity;
  final double productPrice;
  final double totalPrice;
  final String productImage;
  final String createdDate;
  final String id;

  ProductOrderedEntity(
      {required this.productId,
      required this.productTitle,
      required this.productQuantity,
      required this.productPrice,
      required this.totalPrice,
      required this.productImage,
      required this.createdDate,
      required this.id});
}
