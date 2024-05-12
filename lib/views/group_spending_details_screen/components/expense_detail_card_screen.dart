import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/group_epense_details_controller.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/views/components/loading_widget.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final GroupSpendingModel groupSpending;

  const ExpenseDetailsScreen({
    Key? key,
    required this.groupSpending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupExpenseDetailsController groupExpenseDetailsController =
        Get.put(GroupExpenseDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense Description:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              groupSpending.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Total Amount:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${groupSpending.totalAmount}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Split Type:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              groupSpending.divisionType,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Allocated Amounts:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future:
                    groupExpenseDetailsController.getAllUserName(groupSpending),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            snapshot.data![index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '\$${groupSpending.debtors[index].amount}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            groupSpending.debtors[index].debtStatus,
                            style: TextStyle(
                              fontSize: 16,
                              color: groupSpending.debtors[index].debtStatus ==
                                      'paid'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
