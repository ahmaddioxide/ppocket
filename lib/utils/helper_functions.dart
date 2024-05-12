import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String timeStampToString(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  final String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
  return formattedDate;

}

String dateTimeToString(DateTime dateTime) {
  final String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
  return formattedDate;
}

String dateTimeToTimeString(DateTime dateTime) {
  final String formattedTime = DateFormat('hh:mm a').format(dateTime);
  return formattedTime;
}


