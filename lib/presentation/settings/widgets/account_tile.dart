import 'package:flutter/material.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/presentation/settings/pages/account_detail.dart';
import '../../../common/helper/navigator/app_navigator.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the account page or settings page
        AppNavigator.push(context,
            const AccountPage()); // Replace with the correct account page
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
