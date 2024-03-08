import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/button.dart';
import 'package:ppocket/controllers/profile_screen_controller.dart';
import 'package:ppocket/models/user_model.dart';
import 'package:ppocket/views/signup_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileScreenController profileScreenController =
        Get.put(ProfileScreenController());
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('User Profile', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                profileScreenController.signOut().then((value) {
                  Get.offAll(() => const SignUpPage());
                });
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 26.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Center(
          heightFactor: 1.5,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: profileScreenController.getUserProfileData(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final UserOfApp userOfApp = snapshot.data;
                      nameController.text = userOfApp.name ?? 'Found No Name';
                      emailController.text = userOfApp.email;
                      return Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              } else if (value.length < 3) {
                                return 'Name must be at least 3 characters long';
                              } else if (value == userOfApp.name) {
                                return 'Name is same as previous';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: Get.height * 0.02),
                          TextFormField(
                            enabled: false,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Obx(
                            () => Button(
                              text: 'Update',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  profileScreenController.updateProfileData(
                                    name: nameController.text,
                                    email: emailController.text,
                                  );
                                }
                              },
                              isLoading:
                                  profileScreenController.isLoading.value,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: SpinKitChasingDots(
                          color: Colors.green,
                          size: 30.0,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
