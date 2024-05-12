import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/user_model.dart';
import 'package:ppocket/views/login.dart';

import '../components/button.dart';
import '../controllers/signup_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = Get.put(SignupController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
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
                SizedBox(height: Get.height * .1),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .02),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          signupController.isPasswordVisible.value =
                              !signupController.isPasswordVisible.value;
                        },
                        icon: !signupController.isPasswordVisible.value
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.visibility_off_rounded),
                      ),
                      //const Icon(Icons.remove_red_eye
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: !signupController.isPasswordVisible.value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: Get.height * .02),
                Obx(
                  () => TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          signupController.isConfirmPasswordVisible.value =
                              !signupController.isConfirmPasswordVisible.value;
                        },
                        icon: !signupController.isConfirmPasswordVisible.value
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.visibility_off_rounded),
                      ),
                      //const Icon(Icons.remove_red_eye
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText:
                        !signupController.isConfirmPasswordVisible.value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (value != passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: Get.height * .05),
                Obx(
                  () => BlackButton(
                    text: 'Sign Up',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        UserOfApp userOfApp = UserOfApp(
                          id: '',
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        signupController.signup(
                          userOfApp,
                        );
                      }
                    },
                    isLoading: signupController.isSignUpLoading.value,
                  ),
                ),
                SizedBox(height: Get.height * .03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
