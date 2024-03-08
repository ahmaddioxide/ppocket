import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
          ),
          Center(
            child: Image.asset(
              'assets/images/ppocket_logo.png',
              height: 200,
              width: 200,
            ),
          )
        ],
      ),
    );
  }
}
