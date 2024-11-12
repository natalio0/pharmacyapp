import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/domain/auth/entity/user.dart';
import 'package:pharmacyapp/domain/auth/usecases/get_user.dart';
import 'package:pharmacyapp/presentation/auth/pages/welcomepage.dart';
import '../../../service_locator.dart';
import '../../../common/bloc/account/account_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacyapp/common/helper/images/image_display.dart'; // Import the helper

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
          FutureBuilder<String>(
            future: _getProfileImageUrl(user.image),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                );
              }

              if (snapshot.hasData) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(snapshot.data!),
                );
              }

              return const CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              );
            },
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
          ElevatedButton(
            onPressed: () async {
              try {
                // Perform sign-out and then execute UI updates
                await FirebaseAuth.instance.signOut();

                // Show the SnackBar and navigate, but only if context is still valid
                // Using WidgetsBinding to schedule the execution after the async operation
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Check if the widget is still part of the tree
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have signed out successfully.'),
                      ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    );
                  }
                });
              } catch (e) {
                // Handle error after sign-out
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign out failed: $e')),
                    );
                  }
                });
              }
            },
            child: const Text(
              'Sign Out',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _getProfileImageUrl(String imagePath) async {
    try {
      return ImageDisplayHelper.generateUserImageURL(imagePath);
    } catch (e) {
      return 'https://via.placeholder.com/150'; // Fallback image
    }
  }
}
