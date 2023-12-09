import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/model/user.dart';
import 'package:flutter/material.dart';

class UserRepository extends ChangeNotifier {
  static UserModel? user;

  final Map<String, List<String>> _favoriteItems = {};

  Map<String, List<String>> get favoriteItems => _favoriteItems;

  static void login(UserModel u) => user = u;
  static void logout() => user = null;

  final _users = <UserModel>[];

  Future loadAllFromDatabase() async {
    _users.clear();
    var collection = await FirebaseFirestore.instance.collection('users').get();

    for (var doc in collection.docs) {
      _users.add(UserModel.fromJson(doc.id, doc.data()));
    }

    notifyListeners();
  }

  UserModel getUser(String uid) {
    return _users.firstWhere((user) => user.uid == uid);
  }

  Future<void> loadFavorite(String roomName) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorite')
        .doc(roomName)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      _favoriteItems[roomName] = List<String>.from(data['index'] ?? []);
    }
    notifyListeners();
  }

  void addToFavorite(String roomName, String seatIndex) {
    (_favoriteItems[roomName] ??= []).add(seatIndex);
    _updateFavoriteInFirebase(roomName);
    notifyListeners();
  }

  void removeFromFavorite(String roomName, String seatIndex) {
    (_favoriteItems[roomName] ??= []).remove(seatIndex);
    _updateFavoriteInFirebase(roomName);
    notifyListeners();
  }

  bool isInFavorite(String roomName, String seatIndex) {
    return (_favoriteItems[roomName] ??= []).contains(seatIndex);
  }

  void _updateFavoriteInFirebase(String roomName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorite')
        .doc(roomName)
        .set({'index': _favoriteItems[roomName]});
  }

  Future<int> getFavoriteSeats() async {
   var col = await FirebaseFirestore.instance
        .collection('users') // 'rooms' 컬렉션에 접근
        .doc(user!.uid)
        .collection('favorite') // 각 room의 'seats' 컬렉션에 접근
        .get();

    int length = 0;
    for (var doc in col.docs) {
      length += (doc.get('index') as List).length;
    }
    
    return length;
  }
}
