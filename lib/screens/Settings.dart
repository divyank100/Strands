import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/components/SettingsTile.dart';
import 'package:threads_clone/navigation/navigation.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/themes/theme_provider.dart';

import '../services/auth/auth_gate.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final _auth = AuthService();

  void logoutUser() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text("S E T T I N G S"),
      ),
      body: Column(
        children: [
          SettingTile(
            title: "Dark Mode",
            action: CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
            ),
            onTap: () {},
          ),

          SettingTile(
            title: "Blocked Users",
            action: Icon(Icons.arrow_forward),
            onTap: () {
              navigateToBlockedUsers(context);
            },
          ),

          SettingTile(
            title: "Account Settings",
            action: Icon(Icons.arrow_forward),
            onTap: () {
              navigateToAccountSettings(context);
            },
          ),

          SettingTile(
            title: "Logout",
            action: Icon(Icons.login_outlined),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthGate()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
