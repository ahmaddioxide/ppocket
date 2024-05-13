import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/expense_prediction_controller.dart';

class PredictionScreen extends StatelessWidget {
  final PredictionController predictionController = Get.put(PredictionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                predictionController.postExpenseTransactions().then((_) {
                  predictionController.fetchPrediction();
                });
              },
              child: Text('Get Prediction'),
            ),
            Obx(() {
              if (predictionController.predictionResult.value.isNotEmpty) {
                return Text(predictionController.predictionResult.value);
              } else {
                return SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}