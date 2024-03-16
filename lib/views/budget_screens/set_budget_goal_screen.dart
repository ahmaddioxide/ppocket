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
        title: Text('Set Budget Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your monthly saving goal:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: goalController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
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
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                // Utilize the BudgetController and Goal model for logic implementation
                String goalAmount = goalController.text.trim();
                Goal goal = Goal(id: DateTime.now().toString(), amount: double.parse(goalAmount));
                budgetController.saveGoalToFirestore(goal); // Save goal using the controller

                Navigator.pop(context);
              },
              child: Text(
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
