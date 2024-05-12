import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/button.dart';
import 'package:ppocket/controllers/create_group_spending_controller.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/services/database_service.dart';
import 'package:ppocket/theme/app_colors.dart';
import 'package:ppocket/views/group_spending_details_screen/components/group_spending_detail_card.dart';

class GroupSpendingDetails extends StatelessWidget {
  final GroupModel group;

  const GroupSpendingDetails({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final spendingAmountController = TextEditingController();
    final spendingDescriptionController = TextEditingController();
    final groupSpendingScreenController =
        Get.put(CreateGroupSpendingController());
    final formKey = GlobalKey<FormState>();

    void createAndShowEquallySpending(BuildContext context) {
      if (formKey.currentState!.validate()) {
        // Calculate amount to be allocated to each member equally
        double totalExpenseAmount = double.parse(spendingAmountController.text);
        double amountPerMember = totalExpenseAmount / group.members.length;

        // Allocate amount equally to each member
        Map<String, double> allocatedAmountsMap = {};
        group.members.forEach((memberId) {
          allocatedAmountsMap[memberId] = amountPerMember;
        });

        // Show allocated amounts in a popup
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allocated Amounts'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: allocatedAmountsMap.entries.map((entry) {
                String memberId = entry.key;
                double amount = entry.value;
                // Fetch member name from Firestore using memberId
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(memberId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Error fetching member name');
                    }
                    String memberName = snapshot.data!['name'];
                    return Text('$memberName: \$${amount.toStringAsFixed(2)}');
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Add the spending
                  groupSpendingScreenController.addSpending(
                    spendingAmount: totalExpenseAmount,
                    spendingDescription: spendingDescriptionController.text,
                    group: group,
                    splitType: 'equally',
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

// Function to delete the group
    Future<void> _deleteGroup(BuildContext context) async {
      try {
        await FireStoreService.deleteGroup(group.id!);
        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Group deleted successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pop(); // Pop twice to go back to the previous screen
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (error) {
        // Show an error dialog if deletion fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error deleting group: $error'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    // Function to calculate the total expense amount
    double calculateTotalExpense(List<GroupSpendingModel> spendings) {
      double totalAmount = 0;
      for (var spending in spendings) {
        totalAmount += spending.totalAmount;
      }
      return totalAmount;
    }

    Future<List<String>> fetchMemberNames(List<String> memberIds) async {
      List<String> memberNames = [];
      for (String memberId in memberIds) {
        // Fetch the user document from Firestore using the memberId
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .get();
        // Extract the name from the user document and add it to the list
        if (userSnapshot.exists) {
          memberNames.add(userSnapshot['name']);
        } else {
          // Handle the case where the user document doesn't exist
          memberNames.add('Unknown'); // or any default value
        }
      }
      return memberNames;
    }

    void _showPercentageAllocationDialog(BuildContext context,
        double totalExpenseAmount, List<String> memberNames) {
      List<double> percentageValues = List.generate(
        memberNames.length,
        (index) => 0.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Allocate Percentage'),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: memberNames.length,
                      itemBuilder: (context, index) {
                        final memberName = memberNames[index];
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  memberName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Percentage',
                                      suffixText:
                                          '%', // Display percentage sign
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      double percentage = double.parse(
                                          value.isEmpty ? '0' : value);
                                      percentageValues[index] = percentage;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Validate if any percentage field is empty
                  if (percentageValues.any((percentage) => percentage == 0)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Please allocate percentages for all members.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // Calculate total percentage
                  double totalPercentage = percentageValues
                      .reduce((value, element) => value + element);

                  // Validate total percentage
                  if (totalPercentage != 100) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Total percentage should be 100%. Please adjust the percentages.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // Allocate expense amount
                  List<double> allocatedAmounts = percentageValues
                      .map((percentage) =>
                          (percentage / 100) * totalExpenseAmount)
                      .toList();

                  // Show allocated amounts
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Allocated Amounts'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          memberNames.length,
                          (index) => Text(
                              '${memberNames[index]}: \$${allocatedAmounts[index].toStringAsFixed(2)}'),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Allocate'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text(
              'Group Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content:
                        const Text('Are you sure you want to delete this group?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteGroup(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: height * .9,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 10,
                            ), // New line
                            Text(
                              'Expense Description:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: spendingDescriptionController,
                          maxLines: 1,
                          //max characters
                          maxLength: 100,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some description';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Expense Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.dollarSign,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ), // New line
                            Text(
                              'Expense Amount:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: spendingAmountController,
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            //check if the amount is greater than 0
                            if (double.parse(value) <= 0) {
                              return 'Please enter an amount greater than 0';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter expense amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.percentage,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ), // New line
                            Text(
                              'Split Type:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: [
                            ChoiceChip(
                                label: const Text('Equally'),
                                selected: true,
                                onSelected: (value) {}),
                            ChoiceChip(
                                label: const Text('Percentage'),
                                selected: false,
                                onSelected: (value) async {
                                  List<String> memberNames =
                                      await fetchMemberNames(group.members);
                                  // Call the function to show the percentage allocation dialog
                                  _showPercentageAllocationDialog(
                                      context,
                                      double.parse(
                                          spendingAmountController.text),
                                      memberNames);
                                }),
                            ChoiceChip(
                              label: const Text('Amount'),
                              selected: false,
                              onSelected: (value) {
                                Get.snackbar(
                                  'Feature not implemented',
                                  'This feature is not yet implemented',
                                  snackPosition: SnackPosition.BOTTOM,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Obx(
                            () => BlackButton(
                                text: 'Create Spending',
                                isLoading: groupSpendingScreenController
                                    .isLoading.value,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    // Extract the spending amount and description
                                    double spendingAmount = double.parse(
                                        spendingAmountController.text);
                                    String spendingDescription =
                                        spendingDescriptionController.text;

                                    // Check which split type is selected
                                    if (groupSpendingScreenController
                                            .selectedSplitType.value ==
                                        'equally') {
                                      // If split type is equally, show equally spending popup
                                      createAndShowEquallySpending(context);
                                    } else if (groupSpendingScreenController
                                            .selectedSplitType.value ==
                                        'percentage') {
                                      // If split type is percentage, show percentage allocation dialog
                                      List<String> memberNames =
                                          await fetchMemberNames(group.members);
                                      _showPercentageAllocationDialog(
                                        context,
                                        spendingAmount,
                                        memberNames,
                                      );
                                    }

                                    // Add the spending
                                    groupSpendingScreenController.addSpending(
                                      spendingAmount: spendingAmount,
                                      spendingDescription: spendingDescription,
                                      splitType: groupSpendingScreenController
                                          .selectedSplitType.value,
                                      group: group,
                                    );
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        label:
            const Text('Add Spending', style: TextStyle(color: Colors.white)),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            group.name, // Display the group name fetched from the group object
            style: const TextStyle(color: Colors.black, fontSize: 25),
          ),
          // Add some space between texts

          SizedBox(
            height: Get.height * .04,
          ),
          StreamBuilder(
              stream: groupSpendingScreenController.getAllSpending(group.id!),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occurred ${snapshot.error}'),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text('No spending yet'),
                  );
                }
                final data = snapshot.data as List<GroupSpendingModel>;
                double Expense = calculateTotalExpense(
                    data); // Calculate total expense amount
                return Expanded(
                    child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: Colors.red, // Set the color to red
                    child: Center(
                      child: Text(
                        'Total Expense \$${Expense.toStringAsFixed(2)}', // Display total expense amount
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final spending = data[index];
                          return GroupSpendingDetailCard(
                            groupSpending: spending,
                            memberNames:[],
                            allocatedAmounts: [],
                            splitType: 'equally',
                          );
                        }),
                  )
                ]));
              }),
        ],
      ),
    );
  }
}
