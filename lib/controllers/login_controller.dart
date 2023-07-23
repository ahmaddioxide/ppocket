import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isLoginLoading = false.obs;

  Future<void> login({required String email, required String password}) async {
    isLoginLoading.value = true;
    await FirebaseAuthService.signInWithEmailAndPassword(
            email: email, password: password,)
        .then((value) {
      isLoginLoading.value = false;
      FireStoreService.getUserFromFireStore(userId: FirebaseAuthService.currentUserId).then((value) {
        if (value == null) {
          AppSnackBar.errorSnackbar(
              title: 'Error', message: 'User Not Found in FireStore');
          return;
        }
        // AppSnackBar.successSnackbar(
        //     title: 'Success', message: value.email,);
      });
      AppSnackBar.successSnackbar(
          title: 'Success', message: 'Logged in Successfully',);
    }).onError((error, stackTrace) {
      isLoginLoading.value = false;
    });
  }
}
