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
    List<BudgetDataModel> data = [];
    // Get the date of the start of the current week
    DateTime startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(startOfWeek) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }

  Future<List<BudgetDataModel>> getPaymentPerMonth() async {
    List<BudgetDataModel> data = [];
    // Get the date of the start of the current month
    DateTime startOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(startOfMonth) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }

  Future<List<BudgetDataModel>> getPaymentPerYear() async {
    List<BudgetDataModel> data = [];
    // Get the date of the start of the current year
    DateTime startOfYear = DateTime(DateTime.now().year, 1, 1);
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(startOfYear) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }

  Future<List<BudgetDataModel>> getPaymentPerDay() async {
    List<BudgetDataModel> data = [];
    // Get the date of the start of the current day
    DateTime startOfDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (var transaction in transactions) {
      if (transaction.date.toDate().isAfter(startOfDay) && transaction.date.toDate().isBefore(DateTime.now())) {
        data.add(BudgetDataModel(timeStampToString(transaction.date), double.parse(transaction.amount)));
      }
    }
    return data;
  }
}
