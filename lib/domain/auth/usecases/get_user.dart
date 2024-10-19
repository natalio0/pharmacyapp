import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AuthRepository>().getUser();
  }
}
