import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabClick;

  BottomNavBar({super.key, required this.onTabClick});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          child: GNav(
            color:
                Theme.of(context).colorScheme.primary,
            activeColor:
            Theme.of(context).colorScheme.inversePrimary,
            mainAxisAlignment: MainAxisAlignment.center,
            tabs: [
              GButton(icon: Icons.home_filled, iconSize: 30,),
              GButton(icon: Icons.search_rounded, iconSize: 30),
              GButton(icon: Icons.add, iconSize: 30),
              GButton(icon: Icons.person, iconSize: 32),
              GButton(icon: Icons.settings, iconSize: 30),
            ],
            onTabChange: (value) => onTabClick!(value),
          ),
        ),
      ),
    );
  }
}
