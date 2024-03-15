
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String name;
  final String type;
  final List<String> members;

  GroupModel({
    required this.name,
    required this.type,
    required this.members,
  });


  @override
  String toString() => 'GroupModel(name: $name, type: $type, members: $members)';

  //copyWith method
  GroupModel copyWith({
    String? name,
    String? type,
    List<String>? members,
  }) {
    return GroupModel(
      name: name ?? this.name,
      type: type ?? this.type,
      members: members ?? this.members,
    );
  }

  //fromMap method
  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'],
      type: map['type'],
      members: List<String>.from(map['members']),
    );
  }

  //From DocumentSnapshot method
  factory GroupModel.fromDocumentSnapshot(DocumentSnapshot document) {
    return GroupModel(
      name: document['name'],
      type: document['type'],
      members: List<String>.from(document['members']),
    );
  }

  //toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'members': members,
    };
  }


}