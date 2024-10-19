import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/order/repository/order.dart';
import 'package:pharmacyapp/service_locator.dart';

class RemoveCartProductUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<OrderRepository>().removeCartProduct(params!);
  }
}
