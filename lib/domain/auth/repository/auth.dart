import 'package:dartz/dartz.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';
import 'package:pharmacyapp/data/auth/models/admin_signin_req.dart';
import 'package:pharmacyapp/data/auth/models/user_creation_req.dart';

import '../../../data/auth/models/user_signin_req.dart';

abstract class AuthRepository {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
  Future<Either> adminSignup(AdminCreationReq admin);
  Future<Either> adminSignin(AdminSigninReq admin);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
  Future<Either> getUser();
  Future<Either> getAdmin();
}
