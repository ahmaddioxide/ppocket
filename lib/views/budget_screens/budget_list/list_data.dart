import 'package:ppocket/views/budget_screens/budget_list/list_items.dart';

List<Itemlist> geter() {
  Itemlist income1 = Itemlist();
  income1.name = 'Salary';
  income1.price = '12000';
  income1.date = '28/11/2021';
  income1.category = 'Income';
  income1.id = '0';
  income1.image = 'assets/images/ppocket_logo.png';
  income1.isIncome = true;

  // Itemlist food = Itemlist();
  // income1.name = 'Travel';
  // income1.price = '500';
  // income1.date = '12/12/2021';
  // income1.category = 'Expense';
  // income1.id = '1';
  // income1.image = 'assets/images/ppocket_logo.png';
  // income1.isIncome = false;

  // return [income1, food];

  Itemlist food = Itemlist();
  food.name = 'Breakfast';
  food.price = '500';
  food.date = '29/11/2021';
  food.category = 'Expense';
  food.id = '1';
  food.image = 'assets/images/ppocket_logo.png';
  food.isIncome = false;

  Itemlist food2 = Itemlist();
  food2.name = 'Lunch';
  food2.price = '500';
  food2.date = '29/11/2021';
  food2.category = 'Expense';
  food2.id = '2';
  food2.image = 'assets/images/ppocket_logo.png';
  food2.isIncome = false;

  return [income1, food, food, food, income1, food, food, food2];
}
