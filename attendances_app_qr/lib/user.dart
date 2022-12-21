import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String id;
  final String name;
  final String display;

  User({
    this.id='',
    required this.name,
    required this.display,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display': display,
  };

  //to convert from retrived json
  static User fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    display: json['display'],
  );
}
