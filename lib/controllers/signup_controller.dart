import 'package:get/get.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/models/user_model.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/services/database_service.dart';

class SignupController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isSignUpLoading = false.obs;

  void createUserOfApp({
    required String id,
    required String name,
    required String email,
    required String password,
  }) {
    final UserOfApp userOfApp = UserOfApp(
      id: id,
      name: name,
      email: email,
      password: password,
    );
    FireStoreService.addUserToFireStore(userOfApp: userOfApp);
  }

  Future<void> signup(UserOfApp userOfApp) async {
    isSignUpLoading.value = true;
    userOfApp.id = await FirebaseAuthService.signUpWithEmailAndPassword(
      email: userOfApp.email,
      password: userOfApp.password!,
    ).onError((error, stackTrace) {
      isSignUpLoading.value = false;
      return 'Error while creating user';
    });
    // if (userOfApp.id != FirebaseAuthService.currentUserId) {
    //   AppSnackBar.errorSnackbar(
    //       title: 'Error',
    //       message: 'userOfApp.id!=FirebaseAuthService.currentUserId');
    //   return;
    // }
    await FireStoreService.addUserToFireStore(userOfApp: userOfApp)
        .then((value) {
      isSignUpLoading.value = false;
      AppSnackBar.successSnackbar(
        title: 'Success',
        message: 'User Created Successfully',
      );
    });
  }
}
