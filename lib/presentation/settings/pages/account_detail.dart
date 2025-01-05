import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/domain/auth/entity/user.dart';
import 'package:pharmacyapp/domain/auth/usecases/get_user.dart';
import '../../../service_locator.dart';
import '../../../common/bloc/account/account_cubit.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  /// Generate the URL for the user profile image from Firebase Storage
  Future<String> generateUserImageURL(String userId) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child('Users/Images/$userId.jpg')
          .getDownloadURL();
    } catch (e) {
      // Return a placeholder URL if an error occurs
      return 'https://via.placeholder.com/150';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Account'),
      ),
      body: BlocProvider(
        create: (context) =>
            AccountCubit(useCase: sl<GetUserUseCase>())..fetchUserDetails(),
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is AccountLoaded) {
              return _accountDetails(state.user, context);
            }

            if (state is AccountFailure) {
              return const Center(
                child:
                    Text('Failed to load account details. Please try again.'),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _accountDetails(UserEntity user, BuildContext context) {
    String displayName = (user.firstName.isNotEmpty && user.lastName.isNotEmpty)
        ? '${user.firstName} ${user.lastName}'
        : 'No Name Provided';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await _pickAndUploadImage(user, context);
            },
            child: FutureBuilder<String>(
              future: generateUserImageURL(user.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  );
                }

                return CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(snapshot.data!),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Name: $displayName',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text(
            'Email: ${user.email}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 15),

          // "Change Photo" button
          ElevatedButton(
            onPressed: () async {
              await _pickAndUploadImage(user, context);
            },
            child: const Text(
              'Change Photo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(
      UserEntity user, BuildContext context) async {
    // Use the image picker to select an image
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Get the file
        File file = File(image.path);

        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('Users/Images/${user.userId}.jpg');

        // Upload the file to Firebase Storage
        await storageRef.putFile(file);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated!')),
          );
        }
      } catch (e) {
        // Handle error after image upload
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile picture: $e')),
          );
        }
      }
    }
  }
}
