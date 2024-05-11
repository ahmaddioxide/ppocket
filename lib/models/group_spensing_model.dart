import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppocket/models/debtors_model.dart';

class GroupSpendingModel {
  final String groupID;
  final double totalAmount;
  final String divisionType;
  final String payor;
  final DateTime date;
  final String description;
  final List<DebtorsModel> debtors;

  GroupSpendingModel({
    required this.groupID,
    required this.totalAmount,
    required this.divisionType,
    required this.payor,
    required this.date,
    required this.description,
    required this.debtors,
  });

  factory GroupSpendingModel.fromMap(Map<String, dynamic> map) {
    return GroupSpendingModel(
      groupID: map['groupID'],
      totalAmount: map['totalAmount'],
      divisionType: map['divisionType'],
      payor: map['payor'],
      date: map['date'].toDate(),
      description: map['description'],
      debtors: map['debtors'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupID': groupID,
      'totalAmount': totalAmount,

      'divisionType': divisionType,
      'payor': payor,
      'date': date,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'GroupSpendingModel{groupID: $groupID, totalAmount: $totalAmount, divisionType: $divisionType, payor: $payor, date: $date, description: $description, debtors: ${debtors.toString()}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupSpendingModel &&
        other.groupID == groupID &&
        other.totalAmount == totalAmount &&
        other.divisionType == divisionType &&
        other.payor == payor &&
        other.date == date &&
        other.description == description &&
        other.debtors == debtors;
  }

  //copyWith
  GroupSpendingModel copyWith({
    String? groupID,
    double? totalAmount,
    String? divisionType,
    String? payor,
    DateTime? date,
    String? description,
    List<DebtorsModel>? debtors,
  }) {
    return GroupSpendingModel(
      groupID: groupID ?? this.groupID,
      totalAmount: totalAmount ?? this.totalAmount,
      divisionType: divisionType ?? this.divisionType,
      payor: payor ?? this.payor,
      date: date ?? this.date,
      description: description ?? this.description,
      debtors: debtors ?? this.debtors,

    );
  }

  //from DocumentSnapshot
  factory GroupSpendingModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    return GroupSpendingModel(
      groupID: documentSnapshot['groupID'],
      totalAmount: documentSnapshot['totalAmount'],
      divisionType: documentSnapshot['divisionType'],
      payor: documentSnapshot['payor'],
      date: documentSnapshot['date'].toDate(),
      description: documentSnapshot['description'],
      //debtors is a separate collection
      debtors: [],
    );
  }

  @override
  int get hashCode {
    return groupID.hashCode ^
    totalAmount.hashCode ^
    divisionType.hashCode ^
    payor.hashCode ^
    date.hashCode ^
    description.hashCode ^
    debtors.hashCode;
  }
}
