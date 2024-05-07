import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/report_bug_controller.dart';

class AllBugReportsScreen extends StatelessWidget {
   final BugReportController bugReportController = Get.put(BugReportController());

  @override
  Widget build(BuildContext context) {
    // Fetch bug reports when screen initializes
    bugReportController.getBugReports();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bug Reports'),
      ),
      body: Obx(
        () => bugReportController.bugReports.isEmpty
            ? Center(
                child: Text('No bug reports found'),
              )
            : ListView.builder(
                itemCount: bugReportController.bugReports.length,
                itemBuilder: (context, index) {
                  final bugReport = bugReportController.bugReports[index];
                  return ListTile(
                    title: Text(bugReport['bug']),
                    subtitle: Text('Reported by: ${bugReport['userId']}'),
                  );
                },
              ),
      ),
    );
  }}
