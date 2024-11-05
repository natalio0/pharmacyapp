import 'package:flutter/material.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';

class AdminPage extends StatelessWidget {
  final AdminCreationReq adminReq;

  // Constructor to accept AdminCreationReq
  const AdminPage({super.key, required this.adminReq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${adminReq.firstName} ${adminReq.lastName}!',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Email: ${adminReq.email}'),
            // You can add more details or functionality here
          ],
        ),
      ),
    );
  }
}
