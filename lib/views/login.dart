import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/constants/assets.dart';
import 'package:ppocket/controllers/login_controller.dart';

import '../components/button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final LoginController loginController = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
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
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * .03),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: !loginController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            loginController.isPasswordVisible.value =
                                !loginController.isPasswordVisible.value;
                          },
                          icon: loginController.isPasswordVisible.value
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  // SizedBox(height: Get.height * .001),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .03),
                  Obx(
                    () => BlackButton(
                      text: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          loginController
                              .login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      isLoading: loginController.isLoginLoading.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
