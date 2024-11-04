import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';
import 'package:pharmacyapp/data/auth/models/user_creation_req.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class SignupUseCase implements UseCase<Either, UserCreationReq> {
  @override
  Future<Either> call({UserCreationReq? params}) async {
    return await sl<AuthRepository>().signup(params!);
  }
}

class AdminSignupUseCase implements UseCase<Either, AdminCreationReq> {
  @override
   Future<Either> call({AdminCreationReq? params}) async {
    return await sl<AuthRepository>().adminSignup(params!);
  }
}

 
