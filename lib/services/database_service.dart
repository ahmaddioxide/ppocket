import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/controllers/models/receipt_model.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/controllers/models/user_model.dart';

class FireStoreService {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static final CollectionReference usersCollection =
  fireStore.collection('users');
  static final CollectionReference receiptsCollection =
  fireStore.collection('receipts');
  static final CollectionReference groupsCollection =
  fireStore.collection('groups');

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
    required transaction,
  }) async {
    await usersCollection
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
        .collection('transactions').orderBy('date', descending: true)
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

  static Future<String> getTotalFromScannedReceipt({required String receiptId}) async {
    final ReceiptModel receipt = await receiptsCollection
        .doc(receiptId)
        .get()
        .then((value) =>
        ReceiptModel.fromDocumentSnapshot(documentSnapshot: value),)
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Getting Receipt from FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());

      return Future.error(error.toString());
    });
    return receipt.total.toString();
  }

  static Future<void> createGroup({required GroupModel groupModel}) async {
    print('groupModel to add in database ${groupModel.toString()}');
    await groupsCollection
        .add(groupModel.toMap())
        .then((value) {})
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Creating Group in FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
  }

  static Stream<List<GroupModel>> getAllGroupsThatUserIsPartOf(
    String userId,
  ) {
    try {
      return groupsCollection
          .where('members', arrayContains: userId)
          .snapshots()
          .map((event) {
        return event.docs
            .map(
              (e) => GroupModel.fromDocumentSnapshot(e),
            )
            .toList();
      });
    } on Exception catch (e) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Getting Groups from FireStore',
      );
      debugPrintStack(stackTrace: StackTrace.current, label: e.toString());
      return const Stream.empty();
    }
  }

  static Future<Map<String, String>> findUserViaEmail(String email) async {
    final Map<String, String> idAndName = {};

    await usersCollection.where('email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        idAndName['id'] = value.docs.first.id;
        idAndName['name'] = value.docs.first['name'];
        return value.docs.first;
      } else {
        return '';
      }
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Finding User from FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
    return idAndName;
  }
// Delete Transaction
  static Future<void> deleteTransaction({
    required String userId,
    required String transactionId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (error) {
      throw error.toString();
    }
  }

// Update Transaction

// Set up Budget goal
static Future<void> addGoalToFirestore({
    required String userId,
    required Map<String, dynamic> goal,
  }) async {
    await usersCollection
        .doc(userId)
        .collection('goals')
        .add(goal)
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Storing Goal to Firestore',
      );
      if (kDebugMode) {
        print('Error Storing Goal to Firestore: $error');
      }
      return Future.error(error.toString());
    });
  }

}
