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
// Update transaction
Future<void> updateTransaction(
  String transactionId,
  TransactionModel updatedTransaction,
) async {
  try {
    await FireStoreService.updateTransaction(
      userId: FirebaseAuthService.currentUserId,
      transactionId: transactionId,
      updatedTransaction: updatedTransaction.toMap(),
    );
    AppSnackBar.successSnackbar(
      title: 'Success',
      message: 'Transaction Updated Successfully',
    );
  } catch (error) {
    AppSnackBar.errorSnackbar(
      title: 'Error Updating Transaction',
      message: error.toString(),
    );
  }
}





// Set up Budget Goal
  Goal? _goal;

  Goal? getGoal() {
    return _goal;
  }

  void setGoal(Goal goal) {
    _goal = goal;
  }

  Future<void> saveGoalToFirestore(Goal goal) async {
    try {
      // Check if a budget goal already exists for the current month
      final existingGoal = await FireStoreService.getBudgetGoalForCurrentMonth(
        userId: FirebaseAuthService.currentUserId,
      );

      if (existingGoal.isNotEmpty) {
        // Display a message if a goal already exists for the current month
        AppSnackBar.errorSnackbar(
          title: 'Info',
          message: 'Budget goal for the current month already exists!',
        );
        return;
      }

      // If no goal exists, save the new goal
      await FireStoreService.addGoalToFirestore(
        userId: FirebaseAuthService.currentUserId,
        goal: goal.toMap(),
      );
      setGoal(goal);
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

  // Get budget goal for current month
  Future<Map> getBudgetGoalForCurrentMonth() async {
    final DateTime now = DateTime.now();
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);

    final Map goal = await FireStoreService.getBudgetGoalForCurrentMonth(
      userId: FirebaseAuthService.currentUserId,
    ).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Getting Budget Goal for Current Month',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });

    return goal;
  }





    // Search budget
  final TextEditingController searchDateController = TextEditingController();
  RxList<TransactionModel> searchedTransactions = <TransactionModel>[].obs;

  // Future<void> searchTransactionsByDate() async {
  //   final String searchDate = searchDateController.text.trim();

  //   if (searchDate.isEmpty) {
  //     AppSnackBar.errorSnackbar(
  //       title: 'Error',
  //       message: 'Please enter a date to search',
  //     );
  //     return;
  //   }

  //   final List<TransactionModel> transactions =
  //   await FireStoreService.getTransactionsOfUser(
  //     userId: FirebaseAuthService.currentUserId,
  //   ).then((List<TransactionModel> transactions) {
  //     return transactions
  //         .where((TransactionModel transaction) =>
  //     transaction.date.toDate().toString().substring(0, 10) ==
  //         searchDate)
  //         .toList();
  //   }).onError((error, stackTrace) {
  //     AppSnackBar.errorSnackbar(
  //       title: 'Error',
  //       message: error.toString(),
  //     );
  //     return [];
  //   });

  //   searchedTransactions.assignAll(transactions);
  // }

  void onClose() {
    // Dispose of the searchDateController when the controller is closed.
    searchDateController.dispose();
    super.onClose();
  }

  Future<void> searchTransactionsByDate() async {
    final String searchDate = searchDateController.text.trim();

    if (searchDate.isEmpty) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Please enter a date to search',
      );
      return;
    }

    try {
      final List<TransactionModel> transactions =
          await FireStoreService.getTransactionsOfUser(
        userId: FirebaseAuthService.currentUserId,
      );

      final List<TransactionModel> searched = transactions
          .where((TransactionModel transaction) =>
              transaction.date.toDate().toString().substring(0, 10) ==
              searchDate,)
          .toList();

      searchedTransactions.assignAll(searched);

      // Clear the input after displaying the results
      searchDateController.clear();
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: error.toString(),
      );
    }
  }


 }
