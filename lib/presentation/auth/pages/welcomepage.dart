import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Pastikan untuk mengimpor ini
import 'package:pharmacyapp/core/configs/assets/app_vectors.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart'; // Pastikan untuk mengimpor AppColors

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  // Metode untuk membangun widget logo
  Widget _buildLogo() {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
      child: SvgPicture.asset(
        AppVectors.appLogo, // Pastikan jalur logo benar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors
            .primary, // Mengatur latar belakang menggunakan AppColors.primary
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(), // Panggil metode untuk membangun logo
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Pharmacy App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks judul
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginUser');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: Colors.white, // Warna teks tombol
              ),
              child: const Text('Login as User'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loginAdmin');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: Colors.white, // Warna teks tombol
              ),
              child: const Text('Login as Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
