import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? id;
  final String name;
  final String type;
  final List<String> members;

  GroupModel({
    this.id,
    required this.name,
    required this.type,
    required this.members,
  });

  @override
  String toString() =>
      'GroupModel(id: $id, name: $name, type: $type, members: $members)';

  //copyWith method
  GroupModel copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      members: members ?? this.members,
    );
  }

  //fromMap method
  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      members: List<String>.from(map['members']),
    );
  }

  //From DocumentSnapshot method
  factory GroupModel.fromDocumentSnapshot(DocumentSnapshot document) {
    return GroupModel(
      id: document.id,
      name: document['name'],
      type: document['type'],
      members: List<String>.from(document['members']),
    );
  }

  //toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'members': members,
    };
  }
}
