import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan dependensi Firebase Firestore
import 'package:pharmacyapp/presentation/auth/admin/pages/product_page.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/settings_page.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/users_page.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/add_product.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/place_order.dart';
import 'package:pharmacyapp/presentation/auth/pages/welcomepage.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalUsers = 0;
  int totalProducts = 0;
  int totalOrders = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchTotalUsers();
    await _fetchTotalOrders();
    await _fetchTotalProducts();
  }

  Future<void> _fetchTotalUsers() async {
    try {
      // Ambil data dari koleksi 'users' di Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      setState(() {
        log(querySnapshot.docs.length.toString());
        totalUsers = querySnapshot.docs.length; // Hitung jumlah dokumen
      });
    } catch (e) {
      log("Error fetching total users: $e");
    }
  }

  Future<void> _fetchTotalOrders() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collectionGroup('Orders').get();

      setState(() {
        log(querySnapshot.docs.length.toString());
        totalOrders = querySnapshot.docs.length; // Hanya mengubah `totalOrders`
      });
    } catch (e) {
      log("Error fetching total orders: $e");
    }
  }

  Future<void> _fetchTotalProducts() async {
    try {
      // Ambil data dari koleksi 'users' di Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();
      setState(() {
        log(querySnapshot.docs.length.toString());
        totalProducts = querySnapshot.docs.length; // Hitung jumlah dokumen
      });
    } catch (e) {
      log("Error fetching total products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang, Admin",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Row(
            //   children: [
            //     _buildStatCard(
            //         "Total Pengguna", totalUsers.toString(), Colors.blue),
            //     _buildStatCard("Pesanan", "350", Colors.green),
            //     _buildStatCard("Produk", "45", Colors.red),
            //   ],
            // ),

            // Bagian Statistik
            const Text(
              "Statistik",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                _buildStatCard("Pengguna", totalUsers.toString(), Colors.blue),
                _buildStatCard("Pesanan", totalOrders.toString(), Colors.green),
                _buildStatCard("Produk", totalProducts.toString(), Colors.red),
              ],
            ),
            const SizedBox(height: 20),

            // Menu Navigasi
            const Text(
              "Navigasi Cepat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              children: [
                _buildMenuCard(
                  Icons.person,
                  "Pengguna",
                  Colors.blue,
                  const UsersPage(),
                ),
                _buildMenuCard(
                  Icons.receipt,
                  "Pesanan",
                  Colors.green,
                  const OrdersPage(),
                ),
                _buildMenuCard(
                  Icons.shopping_bag_rounded,
                  "Semua Produk",
                  Colors.purple,
                  const ProductsPage(),
                ),
                _buildMenuCard(
                  Icons.bar_chart,
                  "Tambah Produk",
                  Colors.orange,
                  const AddProduct(),
                ),
                _buildMenuCard(
                  Icons.settings,
                  "Pengaturan",
                  Colors.grey,
                  const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color color, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Navigate to the respective page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
