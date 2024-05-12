import 'package:flutter/material.dart';
import 'package:ppocket/models/group_spensing_model.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final GroupSpendingModel groupSpending;
  final List<String> memberNames;
  final List<double> allocatedAmounts;

  const ExpenseDetailsScreen({
    Key? key,
    required this.groupSpending,
    required this.memberNames,
    required this.allocatedAmounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              groupSpending.description,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Amount:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${groupSpending.totalAmount}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Split Type:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              groupSpending.divisionType,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Allocated Amounts:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: memberNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    memberNames[index],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '\$${allocatedAmounts[index]}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
