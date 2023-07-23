import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ppocket/views/dashboard.dart';
import 'package:ppocket/views/receipt.dart';
import 'package:ppocket/views/scanqr.dart';



class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 1;
  final screens = [
    const Dashboard(),
    const ScanQr(),
    const Reciept(),

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
              Icons.receipt,
              size: 24,
              color: Colors.white,
            )
          ]),
      body: screens[currentIndex],
    );
  }
}