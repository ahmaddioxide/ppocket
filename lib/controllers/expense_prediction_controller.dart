import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class PredictionController extends GetxController {
  var predictionResult = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getExpenseTransactions();
  }

  Future<void> fetchPrediction() async {
    try {
      final client = http.Client();
      final response = await client
          .get(
            Uri.parse('http://127.0.0.1:5000/get_prediction'),
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

      // client.close();
    } catch (e) {
      predictionResult.value = e.toString();
      print(e.toString());
    }
  }

  Future<void> postExpenseTransactions() async {
    try {
      final transactions = await getExpenseTransactions();

      final List<Map<String, dynamic>> data = transactions.map((transaction) {
        return {
          'name': transaction.name,
          'amount': transaction.amount,
        };
      }).toList();

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/post_transactions'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Code : ${response.statusCode}");
      print("Response Body ${response.body}");

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

  List<TransactionModel> transactions = [];

  Future<List<TransactionModel>> getExpenseTransactions() async {
    transactions = await FireStoreService.getTransactionsOfUser(
      userId: FirebaseAuthService.currentUserId,
    );
    //filter only spending
    transactions = transactions.where((element) => !element.isIncome).toList();
    // debugPrint('Transactions of the User Pulled: $transactions');
    return transactions;
  }
}
