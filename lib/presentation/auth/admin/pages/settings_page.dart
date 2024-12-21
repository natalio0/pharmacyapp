import 'package:flutter/material.dart';
import 'package:pharmacyapp/presentation/settings/widgets/logout_tile.dart';

// Example for Settings Page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: LogOutTile(),
        ),
      ),
    );
  }
}
