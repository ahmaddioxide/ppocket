import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/budget_controller.dart';

class CurrentMonthGoalWidget extends StatelessWidget {
  final BudgetController budgetController = Get.find<BudgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Screen'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Current Month Budget Goal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Goal for the Month:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                GetBuilder<BudgetController>(
                  builder: (controller) {
                    final goal = controller.getGoal();
                    if (goal == null) {
                      return Text(
                        'No budget goal set for this month',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount: \$${goal.amount}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 4.0),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            // Other widgets...
          ],
        ),
      ),
    );
  }
}
