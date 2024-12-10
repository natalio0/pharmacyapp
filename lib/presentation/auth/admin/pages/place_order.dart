import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// Example for Orders Page
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: const Center(child: Text("This is the Orders Page")),
    );
  }
}

// Example for Products Page
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: const Center(child: Text("This is the Products Page")),
    );
  }
}

// Example for Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("This is the Settings Page")),
    );
  }
}
