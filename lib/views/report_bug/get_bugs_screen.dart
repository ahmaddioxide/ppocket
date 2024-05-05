import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/report_bug_controller.dart';

class AllBugReportScreen extends StatelessWidget {
  final BugReportController _bugReportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bug Reports'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    if (_bugReportController.bugReports.isEmpty) {
                      return Center(
                        child: Text('No bug reports available'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: _bugReportController.bugReports.length,
                        itemBuilder: (context, index) {
                          final bugReport =
                              _bugReportController.bugReports[index];
                          return ListTile(
                            title: Text(bugReport['bug']),
                            subtitle: Text('Reported by: ${bugReport['userId']}'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
