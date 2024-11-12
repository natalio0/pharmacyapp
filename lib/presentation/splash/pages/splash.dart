import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmacyapp/core/configs/assets/app_vectors.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_cubit.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Panggil appStarted di sini dengan argumen context
    context.read<SplashCubit>().appStarted(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Jika pengguna terautentikasi, arahkan ke HomePage
          Navigator.pushReplacementNamed(context, '/welcome');
        } else if (state is UnAuthenticated) {
          // Jika pengguna tidak terautentikasi, arahkan ke WelcomePage
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
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
