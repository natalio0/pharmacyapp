import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacyapp/domain/product/entities/product.dart';

class ProductModel {
  final String categoryId;
  // final List<ProductColorModel> colors;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final String productId;
  final String descriptions;
  final int salesNumber;
  final String title;

  ProductModel(
      {required this.categoryId,
      // required this.colors,
      required this.createdDate,
      required this.discountedPrice,
      required this.gender,
      required this.images,
      required this.price,
      required this.productId,
      required this.descriptions,
      required this.salesNumber,
      required this.title});

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      categoryId: map['categoryId'] as String,
      // colors: List<ProductColorModel>.from(
      //     map['colors'].map((e) => ProductColorModel.fromMap(e))),
      createdDate: map['createdDate'] as Timestamp,
      discountedPrice: map['discountedPrice'] as num,
      gender: map['gender'] as int,
      images: List<String>.from(
        map['images'].map((e) => e.toString()),
      ),
      price: map['price'] as num,
      productId: map['productId'] as String,
      descriptions: map['descriptions'] as String,
      salesNumber: map['salesNumber'] as int,
      title: map['title'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      // 'colors': colors.map((e) => e.toMap()).toList(),
      'createdDate': createdDate,
      'discountedPrice': discountedPrice,
      'gender': gender,
      'images': images.map((e) => e.toString()).toList(),
      'price': price,
      'productId': productId,
      'descriptions': descriptions,
      'salesNumber': salesNumber,
      'title': title,
    };
  }
}

extension ProductXModel on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
        categoryId: categoryId,
        createdDate: createdDate,
        discountedPrice: discountedPrice,
        gender: gender,
        images: images,
        price: price,
        productId: productId,
        descriptions: descriptions,
        salesNumber: salesNumber,
        title: title);
  }
}

extension ProductXEntity on ProductEntity {
  ProductModel fromEntity() {
    return ProductModel(
        categoryId: categoryId,
        // colors: colors.map((e) => e.fromEntity()).toList(),
        createdDate: createdDate,
        discountedPrice: discountedPrice,
        gender: gender,
        images: images,
        price: price,
        productId: productId,
        descriptions: descriptions,
        salesNumber: salesNumber,
        title: title);
  }
}
