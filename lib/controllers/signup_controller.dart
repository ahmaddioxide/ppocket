import 'package:get/get.dart';

class SignupController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;

  void signup() {
    // Perform signup logic using the values from the observables
    // You can replace this with your own signup implementation

    // String nameValue = name.value;
    // String emailValue = email.value;
    // String passwordValue = password.value;
    // String confirmPasswordValue = confirmPassword.value;

    // Your signup logic here
    //
    // After successful signup, you can perform any necessary actions
    // such as navigating to the next screen or showing a success message
  }
}
