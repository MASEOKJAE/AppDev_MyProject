import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/model/user.dart';
import 'package:flutter/material.dart';

class UserRepository extends ChangeNotifier {
  static UserModel? user;

  List<String> _wishlistItems = [];

  List<String> get wishlistItems => _wishlistItems;

  static void login(UserModel u) => user = u;
  static void logout() => user = null;

  final _users = <UserModel>[];

  Future loadAllFromDatabase() async {
    _users.clear();
    var collection = await FirebaseFirestore.instance.collection('users').get();

    for (var doc in collection.docs) {
      _users.add(UserModel.fromJson(doc.id, doc.data()));
    }

    if (user != null) {
      loadWishlist();
    }
    notifyListeners();
  }

  UserModel getUser(String uid) {
    return _users.firstWhere((user) => user.uid == uid);
  }

  Future<void> loadWishlist() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      _wishlistItems = List<String>.from(data['wishlist'] ?? []);
    }
    notifyListeners();
  }

  void addToWishlist(String productId) {
    _wishlistItems.add(productId);
    _updateWishlistInFirebase();
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlistItems.remove(productId);
    _updateWishlistInFirebase();
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistItems.contains(productId);
  }

  void _updateWishlistInFirebase() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'wishlist': _wishlistItems});
  }
}
