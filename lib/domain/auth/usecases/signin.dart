import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/data/auth/models/user_signin_req.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class SigninUseCase implements UseCase<Either, UserSigninReq> {
  @override
  Future<Either> call({UserSigninReq? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}
