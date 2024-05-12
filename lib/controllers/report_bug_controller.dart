import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/services/database_service.dart';
import 'package:ppocket/services/auth_service.dart';

class BugReportController extends GetxController {
  final TextEditingController bugDescriptionController =
      TextEditingController();
  RxList bugReports = [].obs;

  // Get current user's email
  String get currentUserEmail => FirebaseAuthService.currentUser!.email!;

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
        userId: currentUserEmail, // Use user's email as userId
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
  Future<void> getBugReports() async {
    try {
      final List<Map<String, dynamic>> reports =
          await FireStoreService.getAllBugReports();
      bugReports.assignAll(reports);
    } catch (error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Failed to get bug reports: $error',
      );
    }
  }
}
