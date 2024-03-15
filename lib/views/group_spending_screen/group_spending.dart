import 'package:flutter/material.dart';
import 'package:ppocket/views/group_spending_screen/create_group_screen.dart';

class GroupSpending extends StatefulWidget {
  const GroupSpending({Key? key}) : super(key: key);

  @override
  _GroupSpendingState createState() => _GroupSpendingState();
}

class _GroupSpendingState extends State<GroupSpending> {
  List<Group> groups = [
    Group(
      name: "Group 1",
      image: "assets/group1.png",
      type: "Trips"
    ),
    Group(
      name: "Group 2",
      image: "assets/group2.png",
      type: "Trips",
    ),
  ];

  void _goToCreateGroupScreen(BuildContext context) async {
    final newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroup()),
    );

    if (newGroup != null) {
      setState(() {
        groups.add(newGroup as Group);
      });
    }
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
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GroupTile(group: groups[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class Group {
  final String name;
  final String image;
  final String type;

  Group({
    required this.name,
    required this.image,
    required this.type,
  });
}

class GroupTile extends StatelessWidget {
  final Group group;

  const GroupTile({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundImage: AssetImage(group.image),
        ),
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
