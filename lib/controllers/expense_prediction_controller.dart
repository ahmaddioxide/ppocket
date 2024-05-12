import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionController extends GetxController {
  var predictionResult = ''.obs;

  Future<void> fetchPrediction() async {
    try {
      final client = http.Client();
      final response = await client
          .get(
            Uri.parse('http://127.0.0.3:5000/get_prediction'),
          )
          .timeout(const Duration(seconds: 5));
      print("!!Response Code : ${response.statusCode}");
      print(("!! Response Body ${response.body}"));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        predictionResult.value = result.toString();
      } else {
        predictionResult.value = response.statusCode.toString();
      }

      client.close(); // Don't forget to close the client
    } catch (e) {
      predictionResult.value = e.toString();
      print(e.toString());
    }
  }
}
