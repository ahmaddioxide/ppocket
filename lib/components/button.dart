import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ppocket/theme/app_colors.dart';

class BlackButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const BlackButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .08,
      width: Get.width * .80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
        child: isLoading
            ? const SpinKitFadingFour(
                color: Colors.white,
                size: 30,
              )
            : Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
      ),
    );
  }
}

class ButtonGreen extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonGreen({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .06,
      width: Get.height * .35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
