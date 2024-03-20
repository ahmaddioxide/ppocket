import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String imageUrl;
  final String textUrl;
  final int total;
  DateTime createdAt = DateTime.now();

  ReceiptModel({
    required this.imageUrl,
    required this.textUrl,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'txtUrl': textUrl,
      'total': total,
      'date': createdAt,
    };
  }

  //from DocumentSnapshot
  factory ReceiptModel.fromDocumentSnapshot({
    required DocumentSnapshot documentSnapshot,
  }) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ReceiptModel(
      imageUrl: data['imageUrl'],
      textUrl: data['textUrl'],
      total: data['total'],
      createdAt: data['date'],
    );
  }

//toString
  @override
  String toString() {
    return 'ReceiptModel {imageUrl: , textUrl, total: $total}, date: $createdAt}';
  }
}
