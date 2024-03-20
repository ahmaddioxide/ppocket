import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  final String imageUrl;
  final String txtUrl;
  final int total;
  final Timestamp createdAt;

  ReceiptModel({
    required this.imageUrl,
    required this.txtUrl,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'txtUrl': txtUrl,
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
      txtUrl: data['txtUrl'],
      total: data['total'],
      createdAt: data['createdAt'],
    );
  }

//toString
  @override
  String toString() {
    return 'ReceiptModel {imageUrl: , txtUrl $txtUrl, total: $total}, date: $createdAt';
  }
}
