import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/core/configs/theme/app_theme.dart';
import 'package:pharmacyapp/firebase_options.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/add_product.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/admindasboard.dart';
import 'package:pharmacyapp/presentation/home/pages/home.dart';
import 'package:pharmacyapp/presentation/splash/bloc/splash_cubit.dart';
import 'package:pharmacyapp/presentation/splash/pages/splash.dart';
import 'package:pharmacyapp/presentation/auth/pages/welcomepage.dart';
import 'package:pharmacyapp/presentation/auth/pages/sigininuser.dart';
import 'package:pharmacyapp/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(context),
      child: MaterialApp(
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/welcome': (context) => const WelcomePage(),
          '/loginUser': (context) => const SigninuserPage(),
          '/loginAdmin': (context) => const AddProduct(),
          '/home': (context) => const HomePage(),
          '/admindasboard': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
