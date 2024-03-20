import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/budget_goal_model.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
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
    total = calculateTotalIncome(transactions) -
        calculateTotalExpense(transactions);
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

  Future<void> addTransactionFromReceiptScan(
    String receiptId,
  ) async {
    final String total = await FireStoreService.getTotalFromScannedReceipt(
      receiptId: receiptId,
    ).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error in Getting Total from Receipt Scan',
        message: error.toString(),
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
    final TransactionModel transaction = TransactionModel(
      name: 'Receipt Scan',
      amount: total,
      date: Timestamp.now(),
      category: 'Receipt Scan',
      isIncome: false,
      id: '',
      receiptId: receiptId,
    );
    debugPrint('transaction to place $transaction');
    await FireStoreService.addTransactionToFireStore(
      userId: FirebaseAuthService.currentUserId,
      transaction: transaction.toMap(),
    ).then((value) {



      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'Transaction Added Successfully',
      ).then((value) {
        // Get.back();
      });
    }).onError((error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
    });
  }

// Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await FireStoreService.deleteTransaction(
        userId: FirebaseAuthService.currentUserId,
        transactionId: transactionId,
      );
      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'Transaction Deleted Successfully',
      );
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error Deleting Transaction',
        message: error.toString(),
      );
    }
  }

// Update transaction

// Set up Budget Goal
  Future<void> saveGoalToFirestore(Goal goal) async {
    try {
      await FireStoreService.addGoalToFirestore(
        userId: FirebaseAuthService.currentUserId,
        goal: goal.toMap(),
      );
      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'Goal Added Successfully',
      );
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
    }
  }
}
