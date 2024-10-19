import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/product/entities/product.dart';
import 'package:pharmacyapp/domain/product/repository/product.dart';
import 'package:pharmacyapp/service_locator.dart';

class AddOrRemoveFavoriteProductUseCase
    implements UseCase<Either, ProductEntity> {
  @override
  Future<Either> call({ProductEntity? params}) async {
    return await sl<ProductRepository>().addOrRemoveFavoriteProduct(params!);
  }
}
