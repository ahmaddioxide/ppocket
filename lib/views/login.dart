import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/button.dart';
import '../components/text_input.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: Get.height * .25),
                          const Center(
                              child: Text(
                            "Welcome to",
                            style: TextStyle(fontSize: 45),
                          )),

                             Container(
                               height:Get.height*.200,
                               width: Get.width*.200,
                               child: Center(
                                child: Image.asset('assets/images/ppocket_land.png'),
                            ),
                             ),

                          SizedBox(height: Get.height * .04),
                          const InputField(
                            text: 'Email',
                            postfixIcon: Icons.email,
                          ),
                          SizedBox(height: Get.height * .03),
                          const InputField(
                            text: 'Password',
                            postfixIcon: Icons.fingerprint,
                          ),
                          SizedBox(height: Get.height * .01),
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(Get.width * .53, 0, 0, 0),
                            child: const Text(
                              "Forget Password ?",

                              style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: Get.height * .03),
                          Button(text: 'Login', onPressed: () {}),
                        ])))));
  }
}
