import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/button.dart';

class ScanQr extends StatelessWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                // debugPrint("DashBoard");
              },
              icon: const Icon(
                Icons.line_weight_outlined,
                color: Colors.white,
              ))
        ],
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SizedBox(
          width: Get.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * .04,
              ),
              const Text('Scan Your QR Code ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: Get.height * .01,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.qr_code_2,
                  size: 300,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              ButtonGreen(
                text: 'Scan the QR Code',
                onPressed: () {
                  //  debugPrint("Scan the QR Please");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
