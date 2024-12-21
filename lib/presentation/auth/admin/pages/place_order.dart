import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacyapp/common/helper/images/image_display.dart';

// Example for Orders Page
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<List<Map<String, dynamic>>> _fetchOrdersFromFirebase() async {
    try {
      log("Fetching orders from Firestore...");
      final querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('Orders').get();

      log("Fetched ${querySnapshot.docs.length} orders");

      if (querySnapshot.docs.isEmpty) {
        log("No orders found in Firestore");
      }

      // Mengubah dokumen menjadi list of map
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        log("Order data: $data"); // Log setiap dokumen

        // Pengecekan null untuk properti yang bisa menyebabkan error
        return {
          'code': data['code'] ?? 'No Code',
          'totalPrice': data['totalPrice'] ?? 0.0,
          'shippingAddress': data['shippingAddress'] ?? 'No Address',
          'products': (data['products'] as List?)?.map((p) {
                return {
                  'productTitle': p['productTitle'] ?? 'No Title',
                  'productQuantity': p['productQuantity'] ?? 0,
                  'productImage': p['productImage'],
                  'productPrice': p['productPrice'] ?? 0.0,
                };
              }).toList() ??
              [], // Jika null, gunakan list kosong
          'orderStatus': (data['orderStatus'] as List?)?.map((status) {
                return {
                  'title': status['title'] ?? 'No Status',
                  'done': status['done'] ?? false,
                };
              }).toList() ??
              [], // Jika null, gunakan list kosong
          'itemCount': data['itemCount'] ?? 0,
        };
      }).toList();
    } catch (e) {
      log("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrdersFromFirebase(),
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
              child: Text("No orders found"),
            );
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final products = order['products'] as List;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Code: ${order['code']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('Total Price: \$${order['totalPrice']}'),
                        Text('Shipping Address: ${order['shippingAddress']}'),
                        Text('Item Count: ${order['itemCount']}'),
                        const SizedBox(height: 8),
                        const Text('Products:'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: products.map<Widget>((product) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: (product['productImage'] != null &&
                                      product['productImage'].isNotEmpty)
                                  ? Image.network(
                                      ImageDisplayHelper
                                          .generateProductImageURL(
                                              product['productImage']),
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const CircleAvatar(
                                          child: Icon(Icons.broken_image),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    )
                                  : const CircleAvatar(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                              title: Text(product['productTitle']),
                              subtitle: Text(
                                  'Quantity: ${product['productQuantity']} \nPrice: \$${product['productPrice']}'),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        const Text('Order Status:'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (order['orderStatus'] as List)
                              .map<Widget>((status) {
                            return Row(
                              children: [
                                Icon(
                                  status['done']
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: status['done']
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(status['title']),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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
