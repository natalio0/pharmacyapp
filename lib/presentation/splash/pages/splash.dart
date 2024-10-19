import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/core/configs/assets/app_vectors.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/presentation/auth/pages/siginin.dart';
import 'package:pharmacyapp/presentation/home/pages/home.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_cubit.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  get email => null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          AppNavigator.pushReplacement(context, const SigninPage());
        }
        if (state is Authenticated) {
          AppNavigator.pushReplacement(context, const HomePage());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white, // Change this to the desired color
              BlendMode.srcIn, // Blend mode to apply the color
            ),
            child: SvgPicture.asset(
              AppVectors.appLogo,
            ),
          ),
        ),
      ),
    );
  }
}
