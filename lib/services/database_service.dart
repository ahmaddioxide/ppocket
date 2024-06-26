import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ppocket/components/snackbars.dart';
import 'package:ppocket/controllers/models/group_model.dart';
import 'package:ppocket/controllers/models/receipt_model.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/controllers/models/user_model.dart';
import 'package:ppocket/models/debtors_model.dart';
import 'package:ppocket/models/group_spensing_model.dart';

class FireStoreService {
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static final CollectionReference usersCollection =
  fireStore.collection('users');
  static final CollectionReference receiptsCollection =
  fireStore.collection('receipts');

  static final CollectionReference groupsCollection =
  fireStore.collection('groups');

    static final CollectionReference bugReportsCollection =
      fireStore.collection('bugreports');

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
        .then((value) {
      //update id of transaction
      value.update({'id': value.id});
    }).onError((error, stackTrace) {
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
            (e) => TransactionModel.fromDocumentSnapshot(documentSnapshot: e),
      )
          .toList();
    }).onError((error, stackTrace) => Future.error(error.toString()));

    return transactions;
  }

  static Stream<List<TransactionModel>> getTransactionsStreamOfUser({
    required String userId,
  }) {
    return fireStore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
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

  static Future<String> getTotalFromScannedReceipt({
    required String receiptId,
  }) async {
    final ReceiptModel receipt = await receiptsCollection
        .doc(receiptId)
        .get()
        .then(
          (value) => ReceiptModel.fromDocumentSnapshot(documentSnapshot: value),
    )
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
    debugPrint('groupModel to add in database ${groupModel.toString()}');
    await groupsCollection.add(groupModel.toMap()).then((value) {
      value.update({'id': value.id});
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Creating Group in FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
  }

  static Stream<List<GroupModel>> getAllGroupsThatUserIsPartOf(String userId,) {
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
static Future<void> updateTransaction({
  required String userId,
  required String transactionId,
  required Map<String, dynamic> updatedTransaction,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transactionId)
        .update(updatedTransaction);
  } catch (error) {
    throw error.toString();
  }
}


// Set up Budget goal
  static Future<void> addGoalToFirestore({
    required String userId,
    required Map<String, dynamic> goal,
  }) async {
    goal['date'] = Timestamp.now();
    await usersCollection
        .doc(userId)
        .collection('goals')
        .add(goal)
        .catchError((error) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Storing Goal to Firestore',
      );
      if (kDebugMode) {
        print('Error Storing Goal to Firestore: $error');
      }
      throw error.toString();
    });
  }

// Store Reciepts
  static Future<void> addReceiptToFirestore({
    required String userId,
    required Map<String, dynamic> receipt,
  }) async {
    await usersCollection
        .doc(userId)
        .collection('receipts')
        .add(receipt)
        .onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Storing Receipt to Firestore',
      );
      if (kDebugMode) {
        print('Error Storing Receipt to Firestore: $error');
      }
      return Future.error(error.toString());
    });
  }

// Search Reciept
  static Future<List<ReceiptModel>> searchReceipts({
    required String userId,
    required String searchText,
  }) async {
    final List<ReceiptModel> receipts = [];
    await usersCollection
        .doc(userId)
        .collection('receipts')
        .where('searchIndex', arrayContains: searchText)
        .get()
        .then((value) {
      for (var element in value.docs) {
        receipts.add(
          ReceiptModel.fromDocumentSnapshot(
            documentSnapshot: element,
          ),
        );
      }
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Searching Receipts in FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
    return receipts;
  }

  static Future<List<TransactionModel>> searchReceiptsByDate({
    required String userId,
    required Timestamp endTimestamp,
    required Timestamp startTimestamp,
  }) {
    debugPrint('startTimestamp $startTimestamp');
    debugPrint('endTimestamp $endTimestamp');
    return usersCollection
        .doc(userId)
        .collection('transactions')
        .where('category', isEqualTo: 'Receipt Scan')
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThan: endTimestamp)
        .get()
        .then((value) {
      debugPrint('value.docs ${value.docs}');
      final docs = value.docs
          .map(
            (e) => TransactionModel.fromDocumentSnapshot(documentSnapshot: e),
      )
          .toList();
      debugPrint('docs length of search query ${docs.length}');
      return docs;
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Searching Receipts by Date in FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
  }

  static Future<String> getReceiptImageUrl(receiptUrl) {
    return receiptsCollection.doc(receiptUrl).get().then((value) {
      ReceiptModel receiptModel = ReceiptModel.fromDocumentSnapshot(
        documentSnapshot: value,
      );
      return receiptModel.imageUrl;
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Getting Receipt Image from FireStore',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });
  }

  // Get budget goal for current month
  static Future<Map> getBudgetGoalForCurrentMonth({
    required String userId,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);
    final DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

    final Map goal = await usersCollection
        .doc(userId)
        .collection('goals')
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThan: endOfMonth)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.first.data();
      } else {
        return {};
      }
    }).onError((error, stackTrace) {
      AppSnackBar.errorSnackbar(
        title: 'Error',
        message: 'Error Getting Budget Goal for Current Month',
      );
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return Future.error(error.toString());
    });

    return goal;
  }

  // Future<void> addDebtorsToGroupSpending(String spendingId,
  //     String groupId,
  //     List<DebtorsModel> debtors,) async {
    static Future<void> reportBug({
      required String userId,
      required String bug,
    }) async {
      await FirebaseFirestore.instance
          .collection('bugreports')
          .add({'userId': userId, 'bug': bug}).then((_) {}).catchError((error) {
        AppSnackBar.errorSnackbar(
          title: 'Error',
          message: 'Error Reporting Bug to FireStore',
        );
        debugPrint('Error: $error');
      });
    }

// Get all bug reports
    static Future<List<Map<String, dynamic>>> getAllBugReports() async {
      final List<Map<String, dynamic>> bugReports = [];

      await bugReportsCollection.get().then((value) {
        value.docs.forEach((doc) {
          bugReports.add(doc.data() as Map<String, dynamic>);
        });
      }).onError((error, stackTrace) {
        AppSnackBar.errorSnackbar(
          title: 'Error',
          message: 'Error Getting Bug Reports from FireStore',
        );
        if (kDebugMode) {
          print('Error Getting Bug Reports from FireStore: $error');
        }
        return Future.error(error.toString());
      });

      return bugReports;
    }


    // Future<void> addDebtorsToGroupSpending(String spendingId,
    //     String groupId,
    //     List<DebtorsModel> debtors,) async {
    //   final debtorsCollection = groupsCollection
    //       .doc(groupId)
    //       .collection('spendings')
    //       .doc(spendingId)
    //       .collection('debtors');
    //   for (var debtor in debtors) {
    //     await debtorsCollection.add(debtor.toMap()).then((value) {
    //       value.update({'id': value.id});
    //     }).onError((error, stackTrace) {
    //       AppSnackBar.errorSnackbar(
    //         title: 'Error',
    //         message: 'Error Adding Debtors to Group Spending in FireStore',
    //       ).then((value) {
    //         debugPrint('Error Adding Debtors to Group Spending in FireStore');
    //       });
    //       debugPrintStack(stackTrace: stackTrace, label: error.toString());
    //       return Future.error(error.toString());
    //     });
    //   }
    // }
  // Future<void> addDebtorsToGroupSpending(String spendingId,
  //     String groupId,
  //     List<DebtorsModel> debtors,) async {
  //   final debtorsCollection = groupsCollection
  //       .doc(groupId)
  //       .collection('spendings')
  //       .doc(spendingId)
  //       .collection('debtors');
  //   for (var debtor in debtors) {
  //     await debtorsCollection.add(debtor.toMap()).then((value) {
  //       value.update({'id': value.id});
  //     }).onError((error, stackTrace) {
  //       AppSnackBar.errorSnackbar(
  //         title: 'Error',
  //         message: 'Error Adding Debtors to Group Spending in FireStore',
  //       ).then((value) {
  //         debugPrint('Error Adding Debtors to Group Spending in FireStore');
  //       });
  //       debugPrintStack(stackTrace: stackTrace, label: error.toString());
  //       return Future.error(error.toString());
  //     });
  //   }
  // }
    Future<void> addGroupSpending(GroupSpendingModel spending) async {
      final spendingCollection =
      groupsCollection.doc(spending.groupID).collection('spendings');
      await spendingCollection.add(spending.toMap()).then((value) async {
      await  value.update({'id': value.id});
        // await addDebtorsToGroupSpending(
        //   value.id,
        //   spending.groupID,
        //   spending.debtors,
        // );
      }).onError((error, stackTrace) {
        AppSnackBar.errorSnackbar(
          title: 'Error',
          message: 'Error Adding Group Spending to FireStore',
        );
        debugPrintStack(stackTrace: stackTrace, label: error.toString());
        return Future.error(error.toString());
      });
    }

    Stream<List<GroupSpendingModel>> getGroupSpending(String groupID) {
      try {
        return groupsCollection
            .doc(groupID)
            .collection('spendings')
            .snapshots()
            .map((event) {
          return event.docs
              .map(
                (e) => GroupSpendingModel.fromDocumentSnapshot(e),
          )
              .toList();
        });
      } on Exception catch (e) {
        AppSnackBar.errorSnackbar(
          title: 'Error',
          message: 'Error Getting Group Spending from FireStore',
        );
        debugPrintStack(stackTrace: StackTrace.current, label: e.toString());
        return const Stream.empty();
      }
    }
    static Future<void> deleteGroup(String groupID) async {
      try {
        await fireStore.collection('groups').doc(groupID).delete();
      } catch (error) {
        throw error.toString();
      }
    }

  // static Future<List<DebtorsModel>> getDebtorsFromFirestore(String spendingId, String groupId) async {
  //
  //
  // }
  }




