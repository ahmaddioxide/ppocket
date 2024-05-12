import 'package:flutter/material.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/budget_goal_model.dart'; // Import the Goal model

class SetBudgetGoalScreen extends StatelessWidget {
  final TextEditingController goalController = TextEditingController();
  final BudgetController budgetController;

  SetBudgetGoalScreen({super.key, required this.budgetController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Budget Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your monthly saving goal:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: goalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Goal Amount',
                hintText: 'Enter your goal amount',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your goal amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                String goalAmount = goalController.text.trim();
                Goal goal = Goal(id: DateTime.now().toString(), amount: double.parse(goalAmount), date: DateTime.now());
                budgetController.saveGoalToFirestore(goal); // Save goal using the controller

                Navigator.pop(context);
              },
              child: const Text(
                'Save Goal',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
