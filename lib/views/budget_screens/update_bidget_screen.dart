import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';

class UpdateTransactionScreen extends StatelessWidget {
  final BudgetController budgetController = Get.find();

  final TransactionModel transaction;

  UpdateTransactionScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController =
        TextEditingController(text: transaction.amount);
    TextEditingController dateController = TextEditingController(
        text: transaction.date.toDate().toString().substring(0, 10));

    String selectedName = transaction.name;
    String selectedCategory = transaction.category;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedName,
              onChanged: (value) {
                selectedName = value!;
              },
<<<<<<< Updated upstream
              items: [
                'Food',
                'Transfer',
                'Transportation',
                'Education',
                'Receipt Scan'
              ].map<DropdownMenuItem<String>>((String value) {
=======
              items: ['Food', 'Transfer', 'Transportation', 'Education','Receipt Scan']
                  .map<DropdownMenuItem<String>>((String value) {
>>>>>>> Stashed changes
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                selectedCategory = value!;
              },
              items: ['Expense', 'Income', 'Receipt Scan']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                TransactionModel updatedTransaction = TransactionModel(
                  name: selectedName,
                  amount: amountController.text.trim(),
                  date: Timestamp.fromDate(
                      DateTime.parse(dateController.text.trim())),
                  category: selectedCategory,
                  isIncome: selectedCategory == 'Income' ? true : false,
                  id: transaction.id,
                  receiptId: transaction.receiptId,
                );
                budgetController.updateTransaction(
                    transaction.id, updatedTransaction);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Update Transaction',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
