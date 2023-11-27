import 'package:ppocket/views/budget_screens/budget_list/list_items.dart';

List<Itemlist> geter() {
  Itemlist travel = Itemlist();
  travel.name = 'Travel';
  travel.price = '1200';
  travel.date = '12/12/2021';
  travel.category = 'Income';
  travel.id = '0';
  travel.image = 'assets/images/ppocket_logo.png';
  travel.isIncome = false;

  return [travel];
}
