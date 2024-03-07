import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppocket/components/snackbars.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final currentUser = _firebaseAuth.currentUser;

  static String get currentUserId => _firebaseAuth.currentUser!.uid;

  static Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .onError((error, stackTrace) {
      if (error.toString().contains('email-already-in-use')) {
        AppSnackBar.errorSnackbar(
          title: 'Error',
          message: 'Email already in use',
        );
        return Future.error('Email already in use');
      } else if (error.toString().contains('invalid-email')) {
        AppSnackBar.errorSnackbar(title: 'Error', message: 'Invalid Email');
        return Future.error('Invalid Email');
      } else if (error.toString().contains('weak-password')) {
        AppSnackBar.errorSnackbar(title: 'Error', message: 'Weak Password');
        return Future.error('Weak Password');
      } else {
        AppSnackBar.errorSnackbar(title: 'Error', message: error.toString());
        return Future.error(error.toString());
      }
    });
    return userCredential.user!.uid.toString();
  }

  static Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .onError((error, stackTrace) {

      if (error.toString().contains('invalid-email')) {
        AppSnackBar.errorSnackbar(title: 'Error', message: 'Invalid Email');
        return Future.error('Invalid Email');
      } else if (error.toString().contains('user-not-found')) {
        AppSnackBar.errorSnackbar(title: 'Error', message: 'User not found');
        return Future.error('User not found');
      } else if (error.toString().contains('wrong-password')) {
        AppSnackBar.errorSnackbar(title: 'Error', message: 'Wrong Password');
        return Future.error('Wrong Password');
      } else {
        AppSnackBar.errorSnackbar(title: 'Error', message: error.toString());
        return Future.error(error.toString());
      }
    });
  }

  static Future<void> signOut()async {
    await _firebaseAuth.signOut();
  }
}
