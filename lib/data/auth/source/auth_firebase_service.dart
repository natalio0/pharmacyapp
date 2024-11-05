import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';
import 'package:pharmacyapp/data/auth/models/admin_signin_req.dart';

import '../models/user_creation_req.dart';
import '../models/user_signin_req.dart';

abstract class AuthFirebaseService {
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

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Initialize your auth instance
  final Logger _logger = Logger(); // Initialize the logger

  // Logout method
  Future<void> logout() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
    } catch (e) {
      // Log the error using the logger
      _logger.e("Logout error: $e"); // Use .e() for error logging
    }
  }
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signup(UserCreationReq user) async {
    try {
      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedData.user!.uid)
          .set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'gender': user.gender,
        'age': user.age,
        'image': returnedData.user!.photoURL,
        'userId': returnedData.user!.uid
      });

      return const Right('Sign up was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> getAges() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Ages').get();
      return Right(returnedData.docs);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);
      return const Right('Sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'No user found for this email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for this user';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right('Password reset email is sent');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> adminSignup(AdminCreationReq admin) async {
    try {
      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: admin.email!, password: admin.password!);

      await FirebaseFirestore.instance
          .collection('Admins')
          .doc(returnedData.user!.uid)
          .set({
        'firstName': admin.firstName,
        'lastName': admin.lastName,
        'email': admin.email,
        'adminId': returnedData.user!.uid,
      });

      return const Right('Admin sign up was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> adminSignin(AdminSigninReq admin) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: admin.email!, password: admin.password!);
      return const Right('Admin sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'No admin found for this email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for this admin';
      }

      return Left(message);
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getAdmin() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Admins')
          .doc('adminId')
          .get(); // Use correct admin ID
      if (doc.exists) {
        return Right(doc.data() as Map<String, dynamic>);
      } else {
        return const Left('Admin not found');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
