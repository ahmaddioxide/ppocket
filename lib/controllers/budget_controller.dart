import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/models/transaction_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class BudgetController extends GetxController {
  Future<void> addManualTransaction(
    TransactionModel transaction,
  ) async {
    FireStoreService.addTransactionToFireStore(
      userId: FirebaseAuthService.currentUserId,
      transaction: transaction.toMap(),
    ).then((value) {
      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'Transaction Added Successfully',
      ).then((value) {
        Get.back();
      });
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
    });
  }

  Future<List<TransactionModel>> getTransactionsOfCurrentUser() async {
    final List<TransactionModel> transactions =
        await FireStoreService.getTransactionsOfUser(
      userId: FirebaseAuthService.currentUserId,
    ).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error Getting Transactions',
        message: error.toString(),
      );
      return Future.error(error.toString());
    });
    return transactions;
  }

  Stream<List<TransactionModel>> getTransactionsStreamOfCurrentUser() {
    final Stream<List<TransactionModel>> transactionsStream =
        FireStoreService.getTransactionsStreamOfUser(
      userId: FirebaseAuthService.currentUserId,
    );
    // debugPrint('transactionsStream ${transactionsStream.toString()}');
    return transactionsStream;
  }

   int calculateTotalBalance(List<TransactionModel> transactions) {
     int total = 0;
     total=calculateTotalIncome(transactions)-calculateTotalExpense(transactions);
     return total;
   }

  int calculateTotalIncome(List<TransactionModel> transactions) {
    int total = 0;
    for (var element in transactions) {
      if (element.isIncome) {
        total += int.parse(element.amount);
      }
    }
    debugPrint('total calculated $total');
    return total;
  }

   int calculateTotalExpense(List<TransactionModel> transactions) {
    int total = 0;
    for (var element in transactions) {
      if (!element.isIncome) {
        total += int.parse(element.amount);
      }
    }
    debugPrint('total calculated $total');
    return total;
  }
}
