import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/domain/auth/usecases/is_logged_in.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_state.dart';
import 'package:pharmacyapp/service_locator.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();

    // Emit state berdasarkan status login
    if (isLoggedIn) {
      emit(Authenticated()); // Emit state Authenticated
    } else {
      emit(UnAuthenticated()); // Emit state UnAuthenticated
    }
  }
}
