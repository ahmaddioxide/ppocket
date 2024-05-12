import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/button.dart';
import 'package:ppocket/constants/strings.dart';
import 'package:ppocket/controllers/create_group_spending_controller.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/views/group_spending_details_screen/components/group_spending_detail_card.dart';

class GroupSpendingDetails extends StatelessWidget {
  final GroupModel group;

  const GroupSpendingDetails({super.key, required this.group});

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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Group Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
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
                                color: Colors.green,
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
                                color: Colors.green,
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
                                color: Colors.green,
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
                              onSelected: (value) {},
                            ),
                            ChoiceChip(
                              label: const Text('Percentage'),
                              selected: false,
                              onSelected: (value) {
                                //show that this feature is not yet implemented
                                //show snackbar using scaffold key
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
                            () => Button(
                              text: 'Create Spending',
                              isLoading:
                                  groupSpendingScreenController.isLoading.value,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  groupSpendingScreenController.addSpending(
                                    spendingAmount: double.parse(
                                      spendingAmountController.text,
                                    ),
                                    spendingDescription:
                                        spendingDescriptionController.text,
                                    group: group,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
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
          SizedBox(
            width: double.infinity,
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
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final spending = data[index];
                      return GroupSpendingDetailCard(
                        groupSpending: spending,
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
