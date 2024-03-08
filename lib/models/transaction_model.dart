import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String name;
  final String price;
  final String date;
  final String category;
  final bool isIncome;

  TransactionModel({
    required this.name,
    required this.price,
    required this.date,
    required this.category,
    required this.isIncome,
  });

  @override
  //ToString
  String toString() {
    return 'TransactionMode{name: $name, price: $price, date: $date, category: $category, isIncome: $isIncome}';
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'date': date,
      'category': category,
      'isIncome': isIncome,
    };
  }

  // CopyWith
  TransactionModel copyWith({
    String? name,
    String? price,
    String? date,
    String? category,
    bool? isIncome,
  }) {
    return TransactionModel(
      name: name ?? this.name,
      price: price ?? this.price,
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
      price: documentSnapshot['price'],
      date: documentSnapshot['date'],
      category: documentSnapshot['category'],
      isIncome: documentSnapshot['isIncome'],
    );
  }
}
