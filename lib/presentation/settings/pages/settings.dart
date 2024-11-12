import 'package:flutter/material.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/presentation/settings/widgets/account_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/logout_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/my_orders_tile.dart';
import 'package:pharmacyapp/presentation/settings/widgets/my_favorties_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BasicAppbar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AccountTile(),
            SizedBox(height: 20),
            MyFavortiesTile(),
            SizedBox(height: 20),
            MyOrdersTile(),
            SizedBox(height: 20),
            LogOutTile(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
