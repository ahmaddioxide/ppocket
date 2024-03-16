import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/budget_data_model.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';
import 'package:ppocket/utils/helper_functions.dart';

class StatsController extends GetxController {
  List<TransactionModel> transactions = [];

  @override
  void onInit() {
    super.onInit();
    getTransactions();
  }

  Future<List<TransactionModel>> getTransactions() async {
    transactions = await FireStoreService.getTransactionsOfUser(
      userId: FirebaseAuthService.currentUserId,
    );
    //filter only spending
    transactions = transactions.where((element) => !element.isIncome).toList();
    debugPrint('Transactions of the User Pulled: $transactions');
    return transactions;
  }

  Future<List<BudgetDataModel>> getPaymentPerDays() async {
    // await Future.delayed(const Duration(seconds: 2));
    // return [
    //   BudgetDataModel('Mon', 350),
    //   BudgetDataModel('Tue', 228),
    //   BudgetDataModel('Wen', 500),
    //   BudgetDataModel('Thu', 158),
    //   BudgetDataModel('Fri', 989),
    //   BudgetDataModel('Sat', 120),
    //   BudgetDataModel('Sun', 700),
    // ];

    List<BudgetDataModel> data = [];
    for (var transaction in transactions) {
      data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
    }
    return data;
  }

  Future<List<BudgetDataModel>> getPaymentPerWeek() async {
    // await Future.delayed(const Duration(seconds: 2));
    // return [
    //   BudgetDataModel('Week 1', 350),
    //   BudgetDataModel('Week 2', 228),
    //   BudgetDataModel('Week 3', 500),
    //   BudgetDataModel('Week 4', 158),
    // ];

    List<BudgetDataModel> data = [];
    // tome to week number
    //transaction of this week only

    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(lastWeek) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;


  }

  Future<List<BudgetDataModel>> getPaymentPerMonth() async {
    // await Future.delayed(const Duration(seconds: 2));
    // return [
    //   BudgetDataModel('Jan', 350),
    //   BudgetDataModel('Feb', 228),
    //   BudgetDataModel('Mar', 500),
    //   BudgetDataModel('Apr', 158),
    //   BudgetDataModel('May', 989),
    //   BudgetDataModel('Jun', 120),
    //   BudgetDataModel('Jul', 700),
    //   BudgetDataModel('Aug', 350),
    //   BudgetDataModel('Sep', 228),
    //   BudgetDataModel('Oct', 500),
    //   BudgetDataModel('Nov', 158),
    //   BudgetDataModel('Dec', 989),
    // ];

    //this month only
    List<BudgetDataModel> data = [];
    final lastMonth = DateTime.now().subtract(const Duration(days: 30));
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(lastMonth) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }

  Future<List<BudgetDataModel>> getPaymentPerYear() async {
    // await Future.delayed(const Duration(seconds: 2));
    // return [
    //   BudgetDataModel('2020', 350),
    //   BudgetDataModel('2021', 228),
    //   BudgetDataModel('2022', 500),
    //   BudgetDataModel('2023', 158),
    // ];

    List<BudgetDataModel> data = [];
    final lastYear = DateTime.now().subtract(const Duration(days: 365));
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(lastYear) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }
}
