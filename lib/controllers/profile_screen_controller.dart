import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/user_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class ProfileScreenController extends GetxController {
  final isLoading = false.obs;

  Future<void> signOut() async {
    await FirebaseAuthService.signOut();
  }

  Stream<UserOfApp> getUserProfileData() {
    final userOfApp = FireStoreService.getUserStreamFromFireStore(
      userId: FirebaseAuthService.currentUserId,
    );
    if (kDebugMode) {
      print('userOfApp $userOfApp');
    }

    return userOfApp;
  }

  Future<void> updateProfileData({
    required String name,
    required String email,
  }) async {
    isLoading.value = true;
    final UserOfApp userOfApp = UserOfApp(
      id: FirebaseAuthService.currentUserId,
      name: name,
      email: email,
    );
    await FireStoreService.updateUserInFireStore(
      userOfApp: userOfApp,
    );
    isLoading.value = false;
    AppSnackBar.successSnackbar(title: 'Updated', message: 'Profile Updated');
  }
}
