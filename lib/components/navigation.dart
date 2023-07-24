import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ppocket/views/dashboard/dashboard_screen.dart';
import 'package:ppocket/views/scanqr.dart';
import 'package:ppocket/views/user_profile/user_profile_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int currentIndex = 1;
  final screens = [
    const Dashboard(),
    const ScanQr(),
    const UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        backgroundColor: Colors.green,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        height: 55,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          Icon(
            Icons.home,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.qr_code_2,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.person_2_rounded,
            size: 24,
            color: Colors.white,
          )
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
