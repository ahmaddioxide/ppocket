import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timeStampToString(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  final String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
  return formattedDate;
}


