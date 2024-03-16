import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id;
  final double amount;

  Goal({
    required this.id,
    required this.amount,
  });

  @override
  String toString() {
    return 'Goal{id: $id, amount: $amount}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
    };
  }

  Goal copyWith({
    String? id,
    double? amount,
  }) {
    return Goal(
      id: id ?? this.id,
      amount: amount ?? this.amount,
    );
  }

  factory Goal.fromDocumentSnapshot({
    required DocumentSnapshot documentSnapshot,
  }) {
    return Goal(
      id: documentSnapshot.id,
      amount: documentSnapshot['amount'],
    );
  }
}
