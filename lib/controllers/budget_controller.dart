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
            transaction: transaction.toMap())
        .then((value) {
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
}
