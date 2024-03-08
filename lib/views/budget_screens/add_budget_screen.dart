import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/views/scanqr.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  DateTime date = DateTime.now();
  TextEditingController explainController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? selectedItem;
  String? selectedItemIncomeExpense;
  final List<String> items = [
    'Food',
    'Transfer',
    'Transportation',
    'Education',
  ];
  final List<String> incomeExpense = ['Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
        ),
        title: const Text(
          'Add Budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: 80,
            child: _buildMainContainer(),
          ),
        ],
      ),
    );
  }

  Container _buildMainContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade100,
      ),
      height: 550,
      width: 340,
      child: Column(
        children: [
          const SizedBox(height: 50),
          // BuildDropDown('Name', items, selectedItem),
          BuildDropDown(
            hint: 'Name',
            items: items,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                labelText: 'Amount',
                labelStyle:
                    TextStyle(fontSize: 17, color: Colors.grey.shade500),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xffC5C5C5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(width: 2, color: Color(0xff368983)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // _buildDropdown('Type', incomeExpense, selectedItemIncomeExpense),
          BuildDropDown(
            hint: 'Type',
            items: items,
            onChanged: (value) {
              setState(() {
                selectedItemIncomeExpense = value;
              });
            },
          ),
          const SizedBox(height: 30),
          _buildDateTime(),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff368983),
              ),
              width: 120,
              height: 50,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'f',
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
          DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (newDate != null) {
            setState(() {
              date = newDate;
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
