import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/constants/strings.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(dashboard, style: TextStyle(color: Colors.white)),
          leading: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.line_weight,
                  color: Colors.white,
                  size: 26.0,
                ),
              ),
            ),
          ],),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * .05,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Get.width * .08, 0, 0, 0),
            child: const Text(
              'Welcome Ahmad',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * .05,
          ),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
