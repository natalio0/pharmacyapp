import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/product/repository/product.dart';
import 'package:pharmacyapp/service_locator.dart';

class GetNewInUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<ProductRepository>().getNewIn();
  }
}
