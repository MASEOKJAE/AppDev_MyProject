import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  late String userId;
  late String name;
  late String description;
  late int price;
  String? image;
  late DateTime saveTime;
  DateTime? modifyTime;
  List<String> likedUids = [];

  bool like(String uid) {
    if (likedUids.contains(uid)) return false;
    likedUids.add(uid);
    return true;
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    description = json['Description'];
    price = json['price'];
    image = json['image'];
    saveTime = (json['saveTime'] as Timestamp).toDate();
    modifyTime = (json['modifyTime'] as Timestamp?)?.toDate();
    likedUids = json['likedUid'].cast<String>();
  }

  Map<String, dynamic> get json => {
    'id': id,
    'userId': userId,
    'name': name,
    'Description': description,
    'price': price,
    'image': image,
    'saveTime': Timestamp.fromDate(saveTime),
    'modifyTime': modifyTime == null 
      ? null : Timestamp.fromDate(modifyTime!),
    'likedUid': likedUids,
  };
}