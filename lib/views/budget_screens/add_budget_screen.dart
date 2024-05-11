import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/views/scanqr.dart';
import 'package:uuid/uuid.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final uuid = const Uuid();
  DateTime date = DateTime.now();
  TextEditingController explainController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? selectedCategory;
  String? selectedTransactionType;
  final List<String> expenseCategory = [
    'Food',
    'Transfer',
    'Transportation',
    'Education',
  ];
  final List<String> transactionType = ['Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    final budgetController = Get.put(BudgetController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ScanQr());
        },
        backgroundColor: Colors.green[600],
        child: const Icon(
          Icons.qr_code,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Add Budget',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // BuildDropDown('Name', items, selectedItem),
                  BuildDropDown(
                    hint: 'Transaction Type',
                    items: expenseCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  // _buildTextField('Amount', amountController),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                            fontSize: 17, color: Colors.grey.shade500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color(0xffC5C5C5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color(0xff368983),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  BuildDropDown(
                    hint: 'Type',
                    items: transactionType,
                    onChanged: (value) {
                      setState(() {
                        selectedTransactionType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildDateTime(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (selectedCategory == null ||
                          selectedTransactionType == null ||
                          amountController.text.isEmpty) {
                        AppSnackBar.errorSnackbar(
                          title: 'Error',
                          message: 'Please fill all the fields',
                        );
                        return;
                      }
                      String id = uuid.v4();
                      budgetController.addManualTransaction(
                        TransactionModel(
                          id: id,
                          name: selectedCategory!,
                          amount: amountController.text,
                          category: selectedTransactionType!,
                          date: Timestamp.fromDate(date),
                          isIncome: selectedTransactionType == 'Income'
                              ? true
                              : false,
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff098670),
                      ),
                      width: 150,
                      height: 50,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTime() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate;

          if (Platform.isIOS) {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return Container(
                  height: 300,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: date,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        date = newDate;
                      });
                    },
                  ),
                );
              },
            );
          } else {
            newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
          }

          if (newDate != null) {
            setState(() {
              date = newDate!;
            });
          }
        },
        child: Text(
          'Date : ${date.year} / ${date.day} / ${date.month}',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
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
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  State<BuildDropDown> createState() => _BuildDropDownState();
}

class _BuildDropDownState extends State<BuildDropDown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
