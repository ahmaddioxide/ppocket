import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/models/user_model.dart';

class FireStoreService {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<void> addUserToFireStore({required UserOfApp userOfApp}) async {
    await fireStore
        .collection('users')
        .doc(userOfApp.id)
        .set(userOfApp.toMap())
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Storing Data to FireStore',
      );
      if (kDebugMode) {
        print('Error Storing Data to FireStore ${error.toString()}');
      }
      return Future.error(error.toString());
    });
  }

  updateUserInFireStore({required UserOfApp userOfApp}) async {
    await fireStore
        .collection('users')
        .doc(userOfApp.id)
        .update(userOfApp.toMap());
  }

  deleteUserFromFireStore({required String userId}) async {
    await fireStore.collection('users').doc(userId).delete();
  }

  static Future<UserOfApp?> getUserFromFireStore({required String userId}) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await fireStore.collection('users').doc(userId).get();
        print('documentSnapshot.exists ${documentSnapshot.exists}');
    if (documentSnapshot.exists) {
      print('documentSnapshot.data() ${documentSnapshot.data()}');
      return UserOfApp.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
    } else {
      return null;
    }
  }
}
