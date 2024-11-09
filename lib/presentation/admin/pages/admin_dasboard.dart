import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
      ),
      body: const Center(
        child: Text(
          'Selamat datang di Dashboard Admin',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
