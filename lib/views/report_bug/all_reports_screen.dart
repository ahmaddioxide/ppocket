import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/report_bug_controller.dart';

class AllBugReportsScreen extends StatelessWidget {
  final BugReportController bugReportController =
      Get.put(BugReportController());

  @override
  Widget build(BuildContext context) {
    // Fetch bug reports when screen initializes
    bugReportController.getBugReports();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bug Reports'),
      ),
      body: Obx(
        () => bugReportController.bugReports.isEmpty
            ? const Center(
                child: Text(
                  'No bug reports found',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: bugReportController.bugReports.length,
                itemBuilder: (context, index) {
                  final bugReport = bugReportController.bugReports[index];
                  return Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: ListTile(
                      title: Text(
                        bugReport['bug'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Reported by: ${bugReport['userId']}'),
                      
                    ),
                  );
                },
              ),
      ),
    );
  }
}
