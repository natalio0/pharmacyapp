import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/data/order/models/add_to_cart_req.dart';
import 'package:pharmacyapp/domain/order/repository/order.dart';
import 'package:pharmacyapp/service_locator.dart';

class AddToCartUseCase implements UseCase<Either, AddToCartReq> {
  @override
  Future<Either> call({AddToCartReq? params}) async {
    return sl<OrderRepository>().addToCart(params!);
  }
}
