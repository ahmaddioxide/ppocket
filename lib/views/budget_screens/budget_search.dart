import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';

class BudgetSearchScreen extends StatelessWidget {
  final BudgetController _budgetController = Get.find<BudgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _budgetController.searchDateController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _budgetController.searchTransactionsByDate();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: _budgetController.searchedTransactions.length,
                  itemBuilder: (context, index) {
                    TransactionModel transaction =
                    _budgetController.searchedTransactions[index];
                    return ListTile(
                      title: Text(transaction.name),
                      subtitle: Text(transaction.amount),
                      trailing: Text(transaction.date.toDate().toString()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
