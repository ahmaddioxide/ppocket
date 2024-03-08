import 'package:cloud_firestore/cloud_firestore.dart';

class UserOfApp {
  String id;
  String? name;
  final String email;
  String? password;

  UserOfApp({
    required this.id,
    required this.name,
    required this.email,
    this.password,
  });

  void updateId(String newId) {
    id = newId;
  }

  void updatePassword(String newPassword) {
    password = newPassword;
  }

  void updateName(String newName) {
    name = newName;
  }

  UserOfApp.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        password = map['password'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password ?? '',
    };
  }

  UserOfApp.fromDocumentSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
  })  : id = documentSnapshot.id,
        name = documentSnapshot.data()!['name'],
        email = documentSnapshot.data()!['email'],
        password = documentSnapshot.data()!['password'];
}
