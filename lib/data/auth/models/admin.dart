// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pharmacyapp/domain/auth/entity/admins.dart';

class AdminModel {
  final String adminId;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final int gender;

  AdminModel(
      {required this.adminId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.image,
      required this.gender});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adminId': adminId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'gender': gender,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminId: map['adminId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      image: map['image'] ?? '',
      gender: map['gender'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdminModel.fromJson(String source) =>
      AdminModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension AdminXModel on AdminModel {
  AdminEntity toEntity() {
    return AdminEntity(
        adminId: adminId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        image: image,
        gender: gender);
  }
}
