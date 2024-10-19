import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/order/repository/order.dart';
import 'package:pharmacyapp/service_locator.dart';

class GetOrdersUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<OrderRepository>().getOrders();
  }
}
