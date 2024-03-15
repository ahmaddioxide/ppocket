import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/models/group_model.dart';
import 'package:ppocket/services/database_service.dart';

class GroupController extends GetxController {
  Future<void> createGroup(GroupModel group) async {
    // Create the group
    await FireStoreService.createGroup(groupModel: group)
        .onError((error, stackTrace) {
      return Future.error(error.toString());
    });
  }

  Stream<List<GroupModel>> getAllGroupThatUserIsPartOf() {
    // Get all the groups that the user is part of
    return FireStoreService.getAllGroupsThatUserIsPartOf(
        FirebaseAuth.instance.currentUser!.uid);
  }

  Future<Map<String, String>> findUserIdViaEmail(String email) async {
    // Find user via email
    return await FireStoreService.findUserViaEmail(email).then((value) {
      if (value.isEmpty) {
        AppSnackBar.errorSnackbar(
            title: 'Not Found', message: 'User Not Found with this email');
        return Future.error('User not found');
      } else {
        return value;
      }
    });
  }
}
