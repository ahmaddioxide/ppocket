import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/group_controller.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/views/components/loading_widget.dart';
import 'package:ppocket/views/group_spending_details_screen/group_spending_details_screen.dart';
import 'package:ppocket/views/group_spending_screen/create_group_screen.dart';

import 'components/group_tile.dart';

class GroupSpending extends StatelessWidget {
  const GroupSpending({Key? key}) : super(key: key);

  void _goToCreateGroupScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GroupController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Group Spending',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.group_add,
                color: Colors.white,
              ),
              onPressed: () {
                _goToCreateGroupScreen(context);
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: StreamBuilder(
              stream: controller.getAllGroupThatUserIsPartOf(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingWidget());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching groups'));
                }
                final List<GroupModel> groups =
                    snapshot.data as List<GroupModel>;
                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return GroupTile(
                      group: groups[index],
                      onTap: () {
                        Get.to(
                          () => GroupSpendingDetails(group: groups[index], ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
