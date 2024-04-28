import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id;
  final double amount;
  final DateTime date;

  Goal({
    required this.id,
    required this.amount,
    required this.date,
  });

  @override
  String toString() {
    return 'Goal{id: $id, amount: $amount, date: $date}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
    };
  }

  Goal copyWith({
    String? id,
    double? amount,
    DateTime? date,
  }) {
    return Goal(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  factory Goal.fromDocumentSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  }) {
    return Goal(
      id: documentSnapshot.id,
      amount: documentSnapshot['amount'] as double,
      date: (documentSnapshot['date'] as Timestamp).toDate(),
    );
  }
}
