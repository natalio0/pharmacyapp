import 'package:pharmacyapp/domain/product/entities/product.dart';

abstract class TopSellingDisplayState {}

class ProductLoading extends TopSellingDisplayState {}

class ProductLoaded extends TopSellingDisplayState {
  final List<ProductEntity> products;
  ProductLoaded({required this.products});
}

class LoadProductFailure extends TopSellingDisplayState {}
