import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/button.dart';
import '../components/text_input.dart';
import '../controllers/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final _formKey = GlobalKey<FormState>();

  SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Get.height * .05),
                const Center(
                  child: Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                Center(
                  child: Image.asset(
                    'assets/images/ppocket_land.png',
                  ),
                ),

                SizedBox(height: Get.height * .02),
                InputField(
                  text: 'Name',
                  postfixIcon: Icons.person,
                  onChanged: (value) => signupController.name.value = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .02),
                InputField(
                  text: 'Email',
                  postfixIcon: Icons.email,
                  onChanged: (value) => signupController.email.value = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .02),
                InputField(
                  text: 'Password',
                  postfixIcon: Icons.lock,
                  obscureText: true,
                  onChanged: (value) => signupController.password.value = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .02),
                InputField(
                  text: 'Confirm Password',
                  postfixIcon: Icons.lock,
                  obscureText: true,
                  onChanged: (value) =>
                      signupController.confirmPassword.value = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .05),
                Button(text: 'Sign Up', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
