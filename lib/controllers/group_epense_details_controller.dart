import 'package:get/get.dart';
import 'package:ppocket/controllers/models/user_model.dart';
import 'package:ppocket/models/group_spensing_model.dart';
import 'package:ppocket/services/database_service.dart';

class GroupExpenseDetailsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getUserNameFromId(String userId) async {
    UserOfApp? user= await FireStoreService.getUserFromFireStore(userId: userId);
    return user!.name!;
  }
  Future<List<String>> getAllUserName(GroupSpendingModel groupSpending)async{
    List<String> names=[];
    for(int i=0;i<groupSpending.debtors.length;i++){
      names.add(await getUserNameFromId(groupSpending.debtors[i].debtorID));
    }
    return names;
  }
}
