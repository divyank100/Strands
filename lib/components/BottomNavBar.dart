import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabClick;

  BottomNavBar({super.key, required this.onTabClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color:
            Theme.of(context).colorScheme.primary,
        activeColor:
        Theme.of(context).colorScheme.inversePrimary,
        mainAxisAlignment: MainAxisAlignment.center,
        tabs: [
          GButton(icon: Icons.home_filled, iconSize: 32,),
          GButton(icon: Icons.search_rounded, iconSize: 32),
          GButton(icon: Icons.add, iconSize: 32),
          GButton(icon: Icons.favorite, iconSize: 32),
          GButton(icon: Icons.person_outline_rounded, iconSize: 32),
        ],
        onTabChange: (value) => onTabClick!(value),
      ),
    );
  }
}
