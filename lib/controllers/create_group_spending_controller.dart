import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/models/debtors_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';
import '../models/group_spensing_model.dart';

class CreateGroupSpendingController extends GetxController {
  final spendingAmountController = TextEditingController();
  final spendingDescriptionController = TextEditingController();

  final isLoading = false.obs;

  void addSpending({
    required double spendingAmount,
    required String spendingDescription,
    String splitType = 'equally',
    required GroupModel group,
  }) async {
    isLoading.value = true;
    String payorId = FirebaseAuthService.currentUser!.uid;

    if (splitType == 'equally') {
      final amountPerPerson = spendingAmount / group.members.length;
      final List<Map<String, dynamic>> debtors = group.members
          .map(
            (member) => {
              'debtorID': member,
              'amount': amountPerPerson,
              'debtStatus': payorId == member ? 'paid' : 'unpaid',
            },
          )
          .toList();
      final spending = GroupSpendingModel(
        groupID: group.id!,
        totalAmount: spendingAmount,
        date: DateTime.now(),
        description: spendingDescription,
        divisionType: splitType,
        payor: payorId,
        debtors: debtors.map((e) => DebtorsModel.fromMap(e)).toList(),
      );
      await FireStoreService().addGroupSpending(spending).then((value) {
        spendingAmountController.clear();
        spendingDescriptionController.clear();
        Get.back();
      });
    }

    isLoading.value = false;
  }

  Stream<List<GroupSpendingModel>> getAllSpending(String groupID) {
    return FireStoreService().getGroupSpending(groupID);
  }
}
