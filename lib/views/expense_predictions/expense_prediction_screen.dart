import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/expense_prediction_controller.dart';

class PredictionScreen extends StatelessWidget {
  final PredictionController predictionController =
      Get.put(PredictionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Prediction Result: ${predictionController.predictionResult.value}',
                  style: const TextStyle(fontSize: 20.0),
                )),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                predictionController.fetchPrediction();
              },
              child: const Text('Fetch Prediction'),
            ),
          ],
        ),
      ),
    );
  }
}
