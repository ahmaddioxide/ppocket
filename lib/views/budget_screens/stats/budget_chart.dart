import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetChart extends StatelessWidget {
  const BudgetChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<BudgetData, String>>[
          SplineSeries<BudgetData, String>(
            dataSource: <BudgetData>[
              BudgetData('Mon', 350),
              BudgetData('Tue', 228),
              BudgetData('Wen', 500),
              BudgetData('Thu', 158),
              BudgetData('Fri', 989),
              BudgetData('Sat', 120),
              BudgetData('Sun', 700),
            ],
            xValueMapper: (BudgetData budget, _) => budget.date,
            yValueMapper: (BudgetData budget, _) => budget.expense,
            // Enable data label
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

class BudgetData {
  BudgetData(this.date, this.expense);
  final String date;
  final double expense;
}
