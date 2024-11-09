import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addProduct(Map<String, dynamic> userInfoMap, String categoryname) async{
  return await FirebaseFirestore.instance
  .collection(categoryname)
  .add(userInfoMap);
 }
}