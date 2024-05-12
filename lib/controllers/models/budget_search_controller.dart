import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class BudgetSearchController extends GetxController {
  final TextEditingController searchDateController = TextEditingController();
  RxList<TransactionModel> searchedTransactions = <TransactionModel>[].obs;

  Future<void> searchTransactionsByDate() async {
    final String searchDate = searchDateController.text.trim();

    if (searchDate.isEmpty) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Please enter a date to search',
      );
      return;
    }

    final List<TransactionModel> transactions =
    await FireStoreService.getTransactionsOfUser(
      userId: FirebaseAuthService.currentUserId,
    ).then((List<TransactionModel> transactions) {
      return transactions
          .where((TransactionModel transaction) =>
      transaction.date.toDate().toString().substring(0, 10) ==
          searchDate,)
          .toList();
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
      return [];
    });

    searchedTransactions.assignAll(transactions);
  }
}