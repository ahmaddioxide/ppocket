import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/services/database_service.dart';

class ReceiptDetailsController extends GetxController {
  Future<String> getReceiptImageLink(TransactionModel transaction) async {
    final String imageUrl =
        await FireStoreService.getReceiptImageUrl(transaction.receiptId)
            .onError((error, stackTrace) {
      debugPrint('Error getting receipt image link: $error');
      AppSnackBar.errorSnackbar(
          title: 'Error', message: 'Error getting receipt image link');
      return Future.error('Error getting receipt image link');
    });
    return imageUrl;
  }
}
