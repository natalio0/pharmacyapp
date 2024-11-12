import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/data/auth/models/admin.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';
import 'package:pharmacyapp/data/auth/models/admin_signin_req.dart';
import 'package:pharmacyapp/data/auth/models/user.dart';
import 'package:pharmacyapp/data/auth/models/user_creation_req.dart';
import 'package:pharmacyapp/data/auth/models/user_signin_req.dart';
import 'package:pharmacyapp/data/auth/source/auth_firebase_service.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(UserCreationReq user) async {
    return await sl<AuthFirebaseService>().signup(user);
  }

  @override
  Future<Either> getAges() async {
    return await sl<AuthFirebaseService>().getAges();
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    return await sl<AuthFirebaseService>().signin(user);
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    return await sl<AuthFirebaseService>().sendPasswordResetEmail(email);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthFirebaseService>().getUser();
    return user.fold((error) {
      return Left(error);
    }, (data) {
      return Right(UserModel.fromMap(data).toEntity());
    });
  }

  @override
  Future<Either> getAdmin() async {
    var admin = await sl<AuthFirebaseService>().getAdmin();
    return admin.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        // Return an error if data is null
        return const Left('Admin not found');
      }
      return Right(AdminModel.fromMap(data).toEntity());
    });
  }

  @override
  Future<Either> adminSignin(AdminSigninReq admin) async {
    var result = await sl<AuthFirebaseService>().adminSignin(admin);
    return result.fold((error) {
      return Left(error);
    }, (data) {
      return Right(AdminModel.fromMap(data).toEntity());
    });
  }

  @override
  Future<Either> adminSignup(AdminCreationReq admin) async {
    var result = await sl<AuthFirebaseService>().adminSignup(admin);
    return result.fold((error) {
      return Left(error);
    }, (data) {
      return Right(AdminModel.fromMap(data).toEntity());
    });
  }
}
