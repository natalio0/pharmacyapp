import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacyapp/common/helper/images/image_display.dart';

// Example for Products Page
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchProductsFromFirebase() async {
    try {
      log("Fetching products from Firestore...");
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      log("Fetched ${querySnapshot.docs.length} products");

      if (querySnapshot.docs.isEmpty) {
        log("No products found in Firestore");
      }

      // Konversi data menjadi list of map
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        log("Product data: $data"); // Log setiap dokumen
        return {
          'title': data['title'] ?? 'No Title',
          'price': data['price'] ?? 0,
          'discountedPrice': data['discountedPrice'] ?? 0,
          'salesNumber': data['salesNumber'] ?? 0,
          'description': data['descriptions'] ?? 'No Description',
          'categoryId': data['categoryId'] ?? 'No Category',
          'image': (data['images'] is List && data['images'].isNotEmpty)
              ? data['images'][0]
              : null, // Ambil gambar pertama dari array
        };
      }).toList();
    } catch (e) {
      log("Error fetching products: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProductsFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No products found"),
            );
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: product['image'] != null
                      ? Image.network(
                          ImageDisplayHelper.generateProductImageURL(
                              product['image']),
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.image_not_supported),
                        ),
                  title: Text(
                    product['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${product['price']}'),
                      Text(
                          'Discounted Price: ${product['discountedPrice']}'), // Menampilkan harga diskon
                      Text(
                          'Sales: ${product['salesNumber']}'), // Menampilkan jumlah penjualan
                    ],
                  ),
                  isThreeLine: true, // Memberikan ruang lebih pada subtitle
                );
              },
            );
          }
        },
      ),
    );
  }
}
