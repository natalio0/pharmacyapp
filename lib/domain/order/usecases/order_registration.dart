import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/data/order/models/order_registration_req.dart';
import 'package:pharmacyapp/domain/order/repository/order.dart';
import 'package:pharmacyapp/service_locator.dart';

class OrderRegistrationUseCase
    implements UseCase<Either, OrderRegistrationReq> {
  @override
  Future<Either> call({OrderRegistrationReq? params}) async {
    return sl<OrderRepository>().orderRegistration(params!);
  }
}
