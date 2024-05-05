import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/services/database_service.dart';
import 'package:ppocket/services/auth_service.dart';

class BugReportController extends GetxController {
  final TextEditingController bugDescriptionController =
      TextEditingController();

  // Variable to store bug reports
  RxList bugReports = [].obs;

  // Report a bug
  Future<void> reportBug() async {
    final String bugDescription = bugDescriptionController.text.trim();

    if (bugDescription.isEmpty) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Please describe the bug before submitting',
      );
      return;
    }

    try {
      // Save bug report to Firestore
      await FireStoreService.reportBug(
        userId: FirebaseAuthService.currentUserId,
        bug: bugDescription,
      );
      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'Bug reported successfully!',
      );
      // Clear the text field after reporting the bug
      bugDescriptionController.clear();
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Failed to report bug: $error',
      );
    }
  }

  // Get all bug reports
  Future<void> getAllBugReports() async {
    try {
      final bugReportsData = await FireStoreService.getBugReports();
      bugReports.value = bugReportsData as List;
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Failed to get bug reports: $error',
      );
    }
  }
}