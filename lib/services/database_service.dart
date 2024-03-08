import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/models/transaction_model.dart';
import 'package:ppocket/models/user_model.dart';

class FireStoreService {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static final CollectionReference usersCollection =
      fireStore.collection('users');

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

  static updateUserInFireStore({required UserOfApp userOfApp}) async {
    await fireStore
        .collection('users')
        .doc(userOfApp.id)
        .update(userOfApp.toMap());
  }

  deleteUserFromFireStore({required String userId}) async {
    await fireStore.collection('users').doc(userId).delete();
  }

  static Future<UserOfApp?> getUserFromFireStore({
    required String userId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await fireStore.collection('users').doc(userId).get();
    if (kDebugMode) {
      print('documentSnapshot.exists ${documentSnapshot.exists}');
    }
    if (documentSnapshot.exists) {
      if (kDebugMode) {
        print('documentSnapshot.data() ${documentSnapshot.data()}');
      }
      return UserOfApp.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
    } else {
      return null;
    }
  }

  static Stream<UserOfApp> getUserStreamFromFireStore({
    required String userId,
  }) {
    return fireStore.collection('users').doc(userId).snapshots().map((event) {
      if (kDebugMode) {
        print('event.data() ${event.data()}');
      }
      return UserOfApp.fromDocumentSnapshot(documentSnapshot: event);
    });
  }

  static Future<void> addTransactionToFireStore({
    required String userId,
    required Map<String, dynamic> transaction,
  }) async {
    await fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add(transaction)
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Storing Transaction to FireStore',
      );
      if (kDebugMode) {
        print('Error Storing Data to FireStore ${error.toString()}');
      }
      return Future.error(error.toString());
    });
  }

  static Future<List<TransactionModel>> getTransactionsOfUser({
    required String userId,
  }) async {
    final transactions = await fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .get()
        .then((value) {
      return value.docs
          .map(
              (e) => TransactionModel.fromDocumentSnapshot(documentSnapshot: e))
          .toList();
      debugPrint('value.docs ${value.docs}');
    }).onError((error, stackTrace) => Future.error(error.toString()));

    return transactions;
  }

  static Stream<List<TransactionModel>> getTransactionsStreamOfUser({
    required String userId,
  }) {
    return fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions').orderBy('date',descending: true)
        .snapshots()
        .map((event) {
          // debugPrint('event.docs ${event.docs}');
      return event.docs
          .map(
            (e) => TransactionModel.fromDocumentSnapshot(documentSnapshot: e),
          )
          .toList();

    });
  }
}
