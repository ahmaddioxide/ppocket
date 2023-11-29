import 'package:flutter/material.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({super.key});

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Add Budget'),
    );
  }
}
