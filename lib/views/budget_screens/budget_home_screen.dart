import 'package:flutter/material.dart';

class BudgetHome extends StatelessWidget {
  const BudgetHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Budget'),
        ),
        body: const Column(
          children: [
            Text("A"),
            Text("B"),
            Text("C"),
          ],
        ));
  }
}
