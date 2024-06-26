import 'package:flutter/material.dart';
import 'package:ppocket/theme/app_colors.dart';
import 'package:ppocket/views/budget_screens/add_budget_screen.dart';
import 'package:ppocket/views/budget_screens/budget_home_screen.dart';
import 'package:ppocket/views/group_spending_screen/group_spending.dart';
import 'package:ppocket/views/scanqr.dart';
import 'package:ppocket/views/stats_screens/stats_screen.dart';
import 'package:ppocket/views/user_profile/user_profile_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomState();
}

class _BottomState extends State<BottomNav> {
  int indexColor = 0;
  List screens = [
    const BudgetHome(),
    const StatScreen(),
    const ScanQr(),
    const UserProfileScreen(),
    const GroupSpending(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[indexColor],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddBudget()));
        },
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 0;
                  });
                },
                child: Icon(
                  Icons.home_outlined,
                  size: 30,
                  color:
                      indexColor == 0 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color:
                      indexColor == 1 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              // const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 2;
                  });
                },
                child: Icon(
                  Icons.qr_code_outlined,
                  size: 30,
                  color:
                      indexColor == 2 ? const Color(0xff368983) : Colors.grey,
                ),
              ),


              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 4;
                  });
                },
                child: Icon(
                  Icons.group_outlined,
                  size: 30,
                  color:
                  indexColor == 4 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexColor = 3;
                  });
                },
                child: Icon(
                  Icons.person,
                  size: 30,
                  color:
                  indexColor == 3 ? const Color(0xff368983) : Colors.grey,
                ),
              ),/**/
            ],
          ),
        ),
      ),
    );
  }
}
