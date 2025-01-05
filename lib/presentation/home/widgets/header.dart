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

  // Generate the profile image URL using userId
  String generateUserImageURL(String userId) {
    return 'https://firebasestorage.googleapis.com/v0/b/pharmacyapp-0101-dev.appspot.com/o/Users%2FImages%2F$userId.jpg?alt=media';
  }

  // Profile Image Widget
  Widget _profileImage(UserEntity user, BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const SettingsPage());
      },
      child: FutureBuilder<String>(
        future: Future.delayed(
          const Duration(seconds: 1),
          () => generateUserImageURL(
              user.userId), // Use userId instead of imagePath
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            // Fallback image in case of error
            return const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            );
          }

          // Display the profile image from Firebase Storage
          return CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(snapshot.data!),
          );
        },
      ),
    );
  }

  // Welcome Message Widget
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
          'Hi, ${user.firstName}', // Display user's first name
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }

  // Cart Icon Widget
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
