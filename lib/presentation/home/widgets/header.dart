import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/core/configs/assets/app_vectors.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/domain/auth/entity/user.dart';
import 'package:pharmacyapp/presentation/cart/pages/cart.dart';
import 'package:pharmacyapp/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacyapp/presentation/settings/pages/settings.dart';

import '../bloc/user_info_display_state.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserInfoLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _profileImage(state.user, context),
                  _welcomeMessage(state.user),
                  _card(context),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // Function to generate the profile image URL
  String generateUserImageURL(String imagePath) {
    // Assuming that `AppUrl.userImage` is the base URL for Firebase Storage
    return 'https://firebasestorage.googleapis.com/v0/b/pharmacyapp-0101-dev.appspot.com/o/Users%2FImages%2F$imagePath?alt=media';
  }

  // Widget to display the profile image
  Widget _profileImage(UserEntity user, BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const SettingsPage());
      },
      child: FutureBuilder<String>(
        future: Future.delayed(
            const Duration(seconds: 1),
            () =>
                generateUserImageURL(user.image)), // Simulating async operation
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display a loading indicator while waiting
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const CircleAvatar(
              radius: 30, // Reduced radius for smaller size
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Fallback image if an error occurs
            );
          }
          return CircleAvatar(
            radius: 30, // Reduced radius for smaller size
            backgroundImage:
                NetworkImage(snapshot.data!), // Use the fetched image URL
          );
        },
      ),
    );
  }

  // Widget to display the welcome message
  Widget _welcomeMessage(UserEntity user) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          'Hi, ${user.firstName}', // Displaying the user's first name
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }

  // Widget to display the cart icon
  Widget _card(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const CartPage());
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: AppColors.primary, // Cart button color
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          AppVectors.bag, // Cart icon
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
