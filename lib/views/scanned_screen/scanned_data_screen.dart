import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/views/components/loading_widget.dart';

class ScannedDataScreen extends StatelessWidget {
  final String data;

  const ScannedDataScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Data'),
      ),
      body: FutureBuilder(
          future: controller.addTransactionFromReceiptScan(data),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return const Center(child: Text('Transaction Added Successfully'));
          },),
    );
  }
}
