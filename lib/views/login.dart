import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/constants/assets.dart';

import '../components/button.dart';
import '../components/text_input.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            heightFactor: 1.2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(height: Get.height * .1),
                  const Center(
                    child: Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      ppocketLandscapeImage,
                      // height: Get.height * .1,
                    ),
                  ),

                  SizedBox(height: Get.height * .04),
                  const InputField(
                    text: 'Email',
                    postfixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: Get.height * .03),
                  const InputField(
                    text: 'Password',
                    postfixIcon: Icons.fingerprint,
                  ),
                  SizedBox(height: Get.height * .01),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget Password ?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .03),
                  Button(text: 'Login', onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
