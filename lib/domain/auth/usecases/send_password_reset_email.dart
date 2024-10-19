import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class SendPasswordResetEmailUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().sendPasswordResetEmail(params!);
  }
}
