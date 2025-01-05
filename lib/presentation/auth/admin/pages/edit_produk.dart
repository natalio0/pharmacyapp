import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/common/helper/images/image_display.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController salesNumberController = TextEditingController();

  String? selectedCategory;
  final List<String> categoryItems = ['Alat Kesehatan', 'Vitamin', 'Herbal'];

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
        return {
          'id': doc.id, // Tambahkan ID dokumen untuk referensi penghapusan
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

  Future<void> _editProduct(String productId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .update(newData);
      log("Product with ID $productId has been updated.");
    } catch (e) {
      log("Error updating product with ID $productId: $e");
    }
  }

  void _showEditDialog(Map<String, dynamic> product) {
    nameController.text = product['title'];
    priceController.text = product['price'].toString();
    discountedPriceController.text = product['discountedPrice'].toString();
    salesNumberController.text = product['salesNumber'].toString();
    detailController.text = product['description'];
    selectedCategory = product['categoryId'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Produk"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Harga"),
                ),
                TextField(
                  controller: discountedPriceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Harga Diskon"),
                ),
                TextField(
                  controller: salesNumberController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Jumlah Penjualan"),
                ),
                TextField(
                  controller: detailController,
                  decoration: const InputDecoration(labelText: "Detail produk"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categoryItems.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: "Category"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text("Ganti Gambar"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newData = {
                  'title': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0,
                  'discountedPrice':
                      double.tryParse(discountedPriceController.text) ?? 0,
                  'salesNumber': int.tryParse(salesNumberController.text) ?? 0,
                  'descriptions': detailController.text,
                  'categoryId': selectedCategory,
                  if (selectedImage != null)
                    'images': [selectedImage!.path], // Update with new image path
                };
                await _editProduct(product['id'], newData);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product has been updated.")),
                );
                (context as Element).markNeedsBuild(); // Refresh UI
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
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
                      Text('Harga: ${product['price']}'),
                      Text('Harga Diskon: ${product['discountedPrice']}'),
                      Text('Jumlah: ${product['salesNumber']}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditDialog(product),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
