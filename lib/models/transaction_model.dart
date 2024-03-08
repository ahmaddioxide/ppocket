import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String name;
  final String amount;
  final Timestamp date;
  final String category;
  final bool isIncome;

  TransactionModel({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });

  @override
  //ToString
  String toString() {
    return 'TransactionMode{name: $name, amount: $amount, date: $date, category: $category, isIncome: $isIncome}';
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date,
      'category': category,
      'isIncome': isIncome,
    };
  }

  // CopyWith
  TransactionModel copyWith({
    String? name,
    String? amount,
    Timestamp? date,
    String? category,
    bool? isIncome,
  }) {
    return TransactionModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  //from DocumentSnapshot
  factory TransactionModel.fromDocumentSnapshot({
    required DocumentSnapshot documentSnapshot,
  }) {
    return TransactionModel(
      name: documentSnapshot['name'],
      amount: documentSnapshot['amount'],
      date: documentSnapshot['date'],
      category: documentSnapshot['category'],
      isIncome: documentSnapshot['isIncome'],
    );
  }
}
