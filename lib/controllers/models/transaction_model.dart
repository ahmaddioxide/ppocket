import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String name;
  final String amount;
  final Timestamp date;
  final String category;
  final bool isIncome;
  final String? receiptId;

  TransactionModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
    this.receiptId='',

  });

  @override
  //ToString
  String toString() {
    return 'TransactionMode{id: $id, name: $name, amount: $amount, date: $date, category: $category, isIncome: $isIncome, receiptId: $receiptId}';
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'category': category,
      'isIncome': isIncome,
      'receiptId': receiptId,
    };
  }

  // CopyWith
  TransactionModel copyWith({
    String? id,
    String? name,
    String? amount,
    Timestamp? date,
    String? category,
    bool? isIncome,
    String? receiptId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      isIncome: isIncome ?? this.isIncome,
      receiptId: receiptId ?? this.receiptId,
    );
  }

  //from DocumentSnapshot
  factory TransactionModel.fromDocumentSnapshot({
    required DocumentSnapshot documentSnapshot,
  }) {
    return TransactionModel(
      id: documentSnapshot['id'],
      name: documentSnapshot['name'],
      amount: documentSnapshot['amount'],
      date: documentSnapshot['date'],
      category: documentSnapshot['category'],
      isIncome: documentSnapshot['isIncome'],
      receiptId: documentSnapshot['receiptId'],
    );
  }
}
