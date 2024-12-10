import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  // Fungsi untuk mengambil data pengguna dari Firestore
  Future<List<Map<String, dynamic>>> fetchUsersFromFirebase() async {
  try {
    // Tambahkan log untuk memastikan koleksi diakses
    print("Fetching users from Firestore...");
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Log hasil query
    print("Fetched ${querySnapshot.docs.length} users");

    if (querySnapshot.docs.isEmpty) {
      print("No users found in Firestore");
    }

    // Ubah dokumen menjadi list of map
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      print("User data: $data"); // Log setiap dokumen
      return {
        'firstName': data['firstName'] ?? 'No First Name',
        'lastName': data['lastName'] ?? 'No Last Name',
        'email': data['email'] ?? 'No Email',
        'image': data['image'],
        'gender': data['gender'] ?? 'No Gender',
      };
    }).toList();
  } catch (e) {
    // Log error
    print("Error fetching users: $e");
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUsersFromFirebase(), // Memanggil data dari Firestore
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
              child: Text("No users found"),
            );
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: user['image'] != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user['image']),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(
                    '${user['firstName']} ${user['lastName']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['email']}'),
                      Text('Gender: ${user['gender']}'),
                    ],
                  ),
                  isThreeLine: true, // Memberikan ruang untuk subtitle
                );
              },
            );
          }
        },
      ),
    );
  }
}
