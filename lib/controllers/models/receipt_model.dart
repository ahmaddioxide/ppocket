import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptModel {
  // final String imageUrl;
  // final String textUrl;
  final int total;

  ReceiptModel({
    // required this.imageUrl,
    // required this.textUrl,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'imageUrl': imageUrl,
      // 'txtUrl': textUrl,
      'total': total,
    };
  }

  //from DocumentSnapshot
  factory ReceiptModel.fromDocumentSnapshot({
    required DocumentSnapshot documentSnapshot,
  }) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return ReceiptModel(
      // imageUrl: data['imageUrl'],
      // textUrl: data['textUrl'],
      total: data['total'],
    );
  }

//toString
  @override
  String toString() {
    return 'ReceiptModel {imageUrl: , textUrl: , total: $total}';
  }
}
