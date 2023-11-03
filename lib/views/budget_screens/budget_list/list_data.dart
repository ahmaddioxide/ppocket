import 'package:ppocket/views/budget_screens/budget_list/list_items.dart';

List<Itemlist> geter() {
  Itemlist upwork = Itemlist();
  upwork.name = 'Upwork';
  upwork.price = '1200';
  upwork.date = '12/12/2021';
  upwork.category = 'Income';
  upwork.id = '1';

  return [upwork];
}
