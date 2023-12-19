import 'package:flutter/material.dart';

class AddBudget extends StatefulWidget {
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
    'food',
    'Transfer',
    'Transportation',
    'Education'
  ];
  final List<String> incomeExpense = ['Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _buildBackgroundContainer(),
            Positioned(
              top: 120,
              child: _buildMainContainer(),
            ),
          ],
        ),
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
          SizedBox(height: 50),
          _buildDropdown('Name', items, selectedItem),
          SizedBox(height: 30),
          _buildTextField('Amount', amountController),
          SizedBox(height: 30),
          _buildDropdown('Type', incomeExpense, selectedItemIncomeExpense),
          SizedBox(height: 30),
          _buildDateTime(),
          Spacer(),
          _buildSaveButton(),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  GestureDetector _buildSaveButton() {
    return GestureDetector(
      onTap: () {
        // Handle saving data (You can replace this with your actual data-saving logic)
        print('Name: $selectedItem');
        // print('Explain: ${explainController.text}');
        print('Amount: ${amountController.text}');
        print('Type: $selectedItemIncomeExpense');
        print('Date: $date');
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xff368983),
        ),
        width: 120,
        height: 50,
        child: Text(
          'Save',
          style: TextStyle(
            fontFamily: 'f',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
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
        border: Border.all(width: 2, color: Color(0xffC5C5C5)),
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
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xffC5C5C5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xff368983)),
          ),
        ),
      ),
    );
  }

  Padding _buildDropdown(
      String hint, List<String> items, String? selectedItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: selectedItem,
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
          },
          items: items
              .map(
                (e) => DropdownMenuItem(
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          child: Image.asset('assets/Images/ppocket_logo.png'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          e,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  value: e,
                ),
              )
              .toList(),
          selectedItemBuilder: (BuildContext context) => items
              .map(
                (e) => Row(
                  children: [
                    Container(
                      width: 42,
                      child: Image.asset('images/$e.png'),
                    ),
                    SizedBox(width: 5),
                    Text(e),
                  ],
                ),
              )
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              hint,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Column _buildBackgroundContainer() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 240,
          decoration: BoxDecoration(
            // color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.green[600]),
                    ),
                    Text(
                      'Add Budget',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                    Icon(
                      Icons.qr_code,
                      color: Colors.green[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
