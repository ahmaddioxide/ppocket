import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/group_controller.dart';
import 'package:ppocket/controllers/models/group_model.dart';

import 'package:ppocket/views/components/loading_widget.dart';
import 'package:ppocket/views/group_spending_screen/create_group_screen.dart';

class GroupSpending extends StatefulWidget {
  const GroupSpending({Key? key}) : super(key: key);

  @override
  _GroupSpendingState createState() => _GroupSpendingState();
}

class _GroupSpendingState extends State<GroupSpending> {
  final _controller = Get.put(GroupController());

  // List<GroupModel> groups = [
  //   GroupModel(
  //     name: "Group 1",
  //     type: "Trips",
  //     members: ["John", "Doe", "Jane"],
  //   ),
  //   GroupModel(
  //     name: "Group 2",
  //     type: "Trips",
  //     members: ["John", "Doe", "Jane"],
  //   ),
  // ];

  void _goToCreateGroupScreen(BuildContext context) async {
    final newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroup()),
    );

    // if (newGroup != null) {
    //   setState(() {
    //     groups.add(newGroup as GroupModel);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
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
              stream: _controller.getAllGroupThatUserIsPartOf(),
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
                    return GroupTile(group: groups[index]);
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

class GroupTile extends StatelessWidget {
  final GroupModel group;

  const GroupTile({Key? key, required this.group}) : super(key: key);

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
          // Handle group tap
        },
      ),
    );
  }
}
