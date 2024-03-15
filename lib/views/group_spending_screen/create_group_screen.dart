import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/button.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/constants/strings.dart';
import 'package:ppocket/controllers/group_controller.dart';
import 'package:ppocket/models/group_model.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String? category;
  final List<String> groupCategory = [
    'Trip',
    'Home',
    'Couple',
    'Others',
  ];
  final TextEditingController _groupNameController = TextEditingController();
  final _groupController = Get.put(GroupController());
  List<Map<String, String>> membersToAdd = [];
  final TextEditingController _memberEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          createGroup,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              const Text(
                'Group Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 55,
                width: 320,
                child: TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter group name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Type:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Add type selection dropdown here
              BuildDropDown(
                hint: 'Type',
                items: groupCategory,
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  SizedBox(
                    height: 55,
                    width: 320,
                    child: TextFormField(
                      controller: _memberEmailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter member email',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add the member to the list
                      if (_memberEmailController.text.isNotEmpty) {
                        _groupController
                            .findUserIdViaEmail(_memberEmailController.text)
                            .then((value) {
                          if (value.isNotEmpty) {
                            membersToAdd.add(value);
                            AppSnackBar.successSnackbar(
                              title: 'Member Added',
                              message: 'Member Added To group Successfully',
                            ).then((value) {
                              setState(() {
                                _memberEmailController.clear();
                              });
                            });
                          }
                        }).onError((error, stackTrace) {
                          // AppSnackBar.errorSnackbar(
                          //   title: 'Error',
                          //   message: 'Error Adding Member',
                          // );
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: membersToAdd.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(membersToAdd[index]['name']!),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          membersToAdd.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ButtonGreen(
                  onPressed: () {
                    if (_groupNameController.text.isEmpty || category == null) {
                      AppSnackBar.errorSnackbar(
                        title: 'Error',
                        message: 'Please fill all the fields',
                      );
                      return;
                    }
                    // Create the group
                    GroupModel newGroup = GroupModel(
                      name: _groupNameController.text,
                      type: category!,
                      members: [
                        FirebaseAuth.instance.currentUser!.uid,
                        //current user ID
                      ],
                    ).copyWith(
                      members: membersToAdd.map((e) => e['id']!).toList()
                        ..add(FirebaseAuth.instance.currentUser!.uid),
                    );

                    _groupController.createGroup(newGroup).whenComplete(
                      () {
                        AppSnackBar.successSnackbar(
                          title: 'Success',
                          message: 'Group Created Successfully',
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                  text: 'Done',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildDropDown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function onChanged;

  const BuildDropDown({
    Key? key,
    required this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<BuildDropDown> createState() => _BuildDropDownState();
}

class _BuildDropDownState extends State<BuildDropDown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 2,
          color: const Color(0xffC5C5C5),
        ),
      ),
      child: DropdownButton<String>(
        value: widget.items.contains(selectedItem) ? selectedItem : null,
        onChanged: (value) {
          debugPrint('!!Selected item: $value');
          setState(() {
            selectedItem = value;
            widget.onChanged(value);
          });
        },
        items: widget.items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Icon(
                          Icons.category,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        e,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
        selectedItemBuilder: (BuildContext context) => widget.items
            .map(
              (e) => Row(
                children: [
                  // SizedBox(
                  //   width: 42,
                  //   child: Image.asset('images/$e.png'),
                  // ),
                  const SizedBox(width: 5),
                  Text(e),
                ],
              ),
            )
            .toList(),
        hint: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            widget.hint,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(),
      ),
    );
  }
}
