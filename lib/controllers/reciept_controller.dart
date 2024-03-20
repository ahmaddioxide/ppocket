import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/receipt_model.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/services/database_service.dart';

class SearchReceiptController extends GetxController {
  final RxBool _isLoading = false.obs; // Reactive boolean for loading state
  final RxString _error = ''.obs; // Reactive string for error message
  final RxList<TransactionModel> _searchResults =
      <TransactionModel>[].obs; // Reactive list for search results
  final TextEditingController _dateController =
      TextEditingController(); // Date controller

  bool get loading => _isLoading.value; // Getter for loading state
  String get error => _error.value; // Getter for error message
  List<TransactionModel> get searchResults =>
      _searchResults; // Getter for search results
  TextEditingController get dateController =>
      _dateController; // Getter for date controller

  Future<void> searchReceiptsByDate({
    required String searchText,
  }) async {
    try {
      _isLoading.value = true; // Set loading state to true before fetching data

      // Convert the search text (date string) to a DateTime object
      DateTime searchDate = DateTime.parse(searchText);

      print('Search Date  = $searchDate');

      // Get the start and end timestamps for the selected date
      DateTime startOfDay =
          DateTime(searchDate.year, searchDate.month, searchDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      // Call the Firestore service method to search receipts within the date range
      List<TransactionModel>? receipts =
          await FireStoreService.searchReceiptsByDate(
        userId: FirebaseAuth.instance.currentUser!.uid,
        endTimestamp: Timestamp.fromDate(endOfDay),
        startTimestamp: Timestamp.fromDate(startOfDay),
      );

      if (receipts != null) {
        _searchResults
            .assignAll(receipts); // Assign fetched receipts to searchResults
        _error.value = ''; // Clear any previous errors
      } else {
        _searchResults.clear(); // Clear searchResults if receipts are null
        _error.value = 'No receipts found for this date'; // Set error message
      }
    } catch (error) {
      _error.value = 'Error searching receipts by date: $error';
      debugPrint(_error.value); // Set error message
    } finally {
      _isLoading.value =
          false; // Set loading state back to false after data is fetched or in case of error
    }
  }

  @override
  void onClose() {
    // Dispose of the date controller when the controller is closed
    _dateController.dispose();
    super.onClose();
  }
}
