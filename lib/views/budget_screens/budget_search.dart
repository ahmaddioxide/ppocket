import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';

class BudgetSearchScreen extends StatelessWidget {
  final BudgetController _budgetController = Get.find<BudgetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: IgnorePointer(
                child: TextField(
                  controller: _budgetController.searchDateController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Date (YYYY-MM-DD)',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                _budgetController.searchTransactionsByDate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              icon: const Icon(Icons.search),
              label: const Text('Search'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Obx(
                () {
                  if (_budgetController.searchedTransactions.isEmpty) {
                    return const Center(
                      child: Text('No transactions found for the selected date'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: _budgetController.searchedTransactions.length,
                      itemBuilder: (context, index) {
                        TransactionModel transaction = _budgetController.searchedTransactions[index];
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'assets/images/ppocket_logo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                transaction.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('kk:mm | yyyy-MM-dd').format(
                                  transaction.date.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                '${transaction.amount}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: transaction.isIncome ? Colors.green : Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _budgetController.searchDateController.text = formattedDate;
    }
  }
}
