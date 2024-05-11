import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionController extends GetxController {
  var predictionResult = ''.obs;

  Future<void> fetchPrediction() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.3:5000/get_prediction'),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        predictionResult.value = result.toString();
      } else {

        predictionResult.value = response.statusCode.toString();
      }
    } catch (e) {
      predictionResult.value = e.toString();
      
        print(e.toString());
      
    }
  }
}
