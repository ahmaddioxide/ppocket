import 'package:cloud_firestore/cloud_firestore.dart';

class DebtorsModel {
  final String debtorID;
  final double amount;
  final String debtStatus;

  DebtorsModel({
    required this.debtorID,
    required this.amount,
    required this.debtStatus,
  });

  factory DebtorsModel.fromMap(Map<String, dynamic> map) {
    return DebtorsModel(
      debtorID: map['debtorID'],
      amount: map['amount'],
      debtStatus: map['debtStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'debtorID': debtorID,
      'amount': amount,
      'debtStatus': debtStatus,
    };
  }

  @override
  String toString() {
    return 'DebtorsModel{debtorID: $debtorID, amount: $amount, debtStatus: $debtStatus}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DebtorsModel &&
        other.debtorID == debtorID &&
        other.amount == amount &&
        other.debtStatus == debtStatus;
  }

  @override
  int get hashCode {
    return debtorID.hashCode ^
        amount.hashCode ^
        debtStatus.hashCode;
  }

  //from DocumentSnapshot
  factory DebtorsModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return DebtorsModel(
      debtorID: documentSnapshot['debtorID'],
      amount: documentSnapshot['amount'],
      debtStatus: documentSnapshot['debtStatus'],
    );
  }
}
