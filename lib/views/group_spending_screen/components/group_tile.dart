import 'package:flutter/material.dart';

import '../../../controllers/models/group_model.dart';

class GroupTile extends StatelessWidget {
  final Function? onTap;
  final GroupModel group;

  const GroupTile({Key? key, required this.group, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // Get.to(() => const GroupDetailsScreen());
          if (onTap != null) {
            onTap!();
          }
        },
      ),
    );
  }
}
