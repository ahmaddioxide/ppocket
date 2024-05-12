import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/theme/app_colors.dart';
import 'package:ppocket/views/budget_screens/set_budget_goal_screen.dart';

class BudgetGoalScreen extends StatelessWidget {
  const BudgetGoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BudgetController budgetController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Goal'),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
            future: budgetController.getBudgetGoalForCurrentMonth(),
            builder: (context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final goalData = snapshot.data!;
                final goalAmount = goalData['amount'];
                return Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 50),
                        child: Text(
                          'Your Budget Goal for ${DateTime.now().month}/${DateTime.now().year}:',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$goalAmount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // return Text('No Budget Goal Set for the Current Month');
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'No Budget Goal Set for the Current Month',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                       ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
