import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ppocket/controllers/budget_controller.dart';
import 'package:ppocket/controllers/models/budget_search_controller.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/views/budget_screens/budget_goal.dart';
import 'package:ppocket/views/budget_screens/set_budget_goal_screen.dart';
import 'package:ppocket/views/components/loading_widget.dart';
import 'package:ppocket/views/search_reciepts/search_reciepts.dart';

import 'budget_search.dart';

class BudgetHome extends StatelessWidget {
  const BudgetHome({Key? key});

  @override
  Widget build(BuildContext context) {
    final budgetController = Get.put(BudgetController());

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Budget',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.monetization_on, color: Colors.white),
            onPressed: () {
              // Navigate to the set budget goal screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SetBudgetGoalScreen(
                    budgetController: BudgetController(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Navigate to the add transaction screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchReceipts(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: budgetController.getTransactionsStreamOfCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            final transactionsList = snapshot.data as List<TransactionModel>;
            final goal = budgetController.getCurrentMonthGoal();

            return Column(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(18),
                      padding: const EdgeInsets.all(19),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.green[600],
                        //elevation
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      // padding: const EdgeInsets.all(20.0),
                      // color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Balance',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    budgetController
                                        .calculateTotalBalance(transactionsList)
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: 2,
                                color: Colors.white,
                              ),

                              Column(
                                children: [
                                  Text("Goal"),
                                  Text(goal != null ? goal.amount.toString() : "No goal set")
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width * 0.36,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.blueAccent,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_downward,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Income',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          budgetController
                                              .calculateTotalIncome(
                                                transactionsList,
                                              )
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width * 0.36,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.redAccent,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_upward,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Expense',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          budgetController
                                              .calculateTotalExpense(
                                                transactionsList,
                                              )
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        // Navigate to the search screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BudgetSearchScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Search Budget',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactionsList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'assets/images/ppocket_logo.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                transactionsList[index].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('kk:mm | yyyy-MM-dd').format(
                                  transactionsList[index].date.toDate(),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    transactionsList[index].amount,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: transactionsList[index].isIncome
                                          ? Colors.green
                                          : Colors.redAccent,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 0,
                                        ),
                                        // Adjust the right padding as needed
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () {
                                            // Call the delete function
                                            budgetController.deleteTransaction(
                                              transactionsList[index].id,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 0,
                                        ),
                                        // Adjust the left padding as needed
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            // Call the edit function
                                            // budgetController.editTransaction(transactionsList[index].id);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: LoadingWidget(),
          );
        },
      ),
    );
  }
}
