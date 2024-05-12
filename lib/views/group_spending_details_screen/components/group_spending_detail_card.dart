import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/utils/helper_functions.dart';
import 'package:ppocket/views/group_spending_details_screen/components/expense_detail_card_screen.dart';

class GroupSpendingDetailCard extends StatelessWidget {
  final GroupSpendingModel groupSpending;
  final List<String> memberNames;
  final List<double> allocatedAmounts;
  final String splitType;

  const GroupSpendingDetailCard({
    Key? key,
    required this.groupSpending,
    required this.memberNames,
    required this.allocatedAmounts,
    required this.splitType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.green,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExpenseDetailsScreen(
                groupSpending: groupSpending,
                memberNames:memberNames,
                allocatedAmounts: [],

              ),
            ),
          );
        },
        title: Text(
          groupSpending.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  dateTimeToString(groupSpending.date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.clock,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  dateTimeToTimeString(groupSpending.date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Text(
          groupSpending.totalAmount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
