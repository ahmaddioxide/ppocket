import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ppocket/controllers/bug_report_controller.dart';
import 'package:ppocket/controllers/report_bug_controller.dart';
// import 'package:ppocket/views/report_bug/get_bugs_screen.dart';

class BugReportScreen extends StatelessWidget {
  final BugReportController bugReportController = Get.put(BugReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Bug'),
        // Add a button to navigate to the bug reports screen
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () {
            //                 Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => AllBugReportScreen(),
            //     ),
            //   );
             },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: bugReportController.bugDescriptionController,
              decoration: InputDecoration(
                labelText: 'Bug Description',
                hintText: 'Describe the bug here...',
              ),
              maxLines: null,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: bugReportController.reportBug,
              child: Text('Submit Bug Report'),
            ),
          ],
        ),
      ),
    );
  }
}
