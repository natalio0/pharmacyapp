import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/product/repository/product.dart';
import 'package:pharmacyapp/service_locator.dart';

class GetProductsByTitleUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ProductRepository>().getProductsByTitle(params!);
  }
}
