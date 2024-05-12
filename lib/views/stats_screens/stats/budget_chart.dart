import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/budget_data_model.dart';
import 'package:ppocket/controllers/stats_controller.dart';
import 'package:ppocket/views/components/loading_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BudgetChart extends StatelessWidget {
  final int selectedIndex;

  const BudgetChart({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatsController>();
    return FutureBuilder<List<BudgetDataModel>>(
      future: selectedIndex == 0
          ? controller.getPaymentPerDay()
          : selectedIndex == 1
              ? controller.getPaymentPerWeek()
              : selectedIndex == 2
                  ? controller.getPaymentPerMonth()
                  : controller.getPaymentPerYear(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingWidget(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final List<BudgetDataModel> data = snapshot.data ?? [];

        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: selectedIndex == 0
              ? NumericAxis(
                  minimum: 0,
                  maximum: 10000,
                )
              : null,
          series: <SplineSeries<BudgetDataModel, String>>[
            SplineSeries<BudgetDataModel, String>(
              dataSource: data,
              xValueMapper: (BudgetDataModel budget, _) => budget.date,
              yValueMapper: (BudgetDataModel budget, _) => budget.expense,
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    );
  }
}
