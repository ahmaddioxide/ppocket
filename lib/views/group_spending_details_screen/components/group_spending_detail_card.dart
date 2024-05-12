import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/utils/helper_functions.dart';

class GroupSpendingDetailCard extends StatelessWidget {
  final GroupSpendingModel groupSpending;

  const GroupSpendingDetailCard({super.key, required this.groupSpending});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.green,
      child: ListTile(
        onTap: () {
          // Navigate to the group spending details screen
        },
        title: Text(
          groupSpending.description,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),
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
                  dateTimeToString(
                    groupSpending.date,
                  ),
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
                  dateTimeToTimeString(
                    groupSpending.date,
                  ),
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
        trailing: Text(groupSpending.totalAmount.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}
