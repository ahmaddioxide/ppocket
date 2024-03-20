import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/views/scanned_screen/scanned_data_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../components/button.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({Key? key}) : super(key: key);

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  // Function to handle the QR code scanning result
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        debugPrint(scanData.code!);

        result = scanData;
      });

      // Navigate to the ScannedDataScreen and pass the scanned data
      if (result != null && result!.code!.isNotEmpty) {
        debugPrint(result!.code!);
        Get.to(ScannedDataScreen(data: result!.code!));
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

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
              // Navigate to Dashboard screen
            },
            icon: const Icon(
              Icons.line_weight_outlined,
              color: Colors.white,
            ),
          ),
        ],
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SizedBox(
          width: Get.width * .9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * .04,
              ),
              const Text(
                'Scan Your QR Code ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: Get.height * .01,
              ),
              SizedBox(
                height: Get.height * .5,
                width: Get.width * .8,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 150,
                  ),
                  onPermissionSet: (ctrl, p) =>
                      _onPermissionSet(context, ctrl, p),
                ),
              ),
              SizedBox(
                height: Get.height * .02,
              ),
              ButtonGreen(
                text: 'Scan the QR Code',
                onPressed: () {
                  // debugPrint("Scan the QR Please");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
