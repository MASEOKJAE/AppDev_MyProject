import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalterm_project/model/product.dart';
import 'package:finalterm_project/model/user_repository.dart';
import 'package:flutter/material.dart';

class ProductRepository extends ChangeNotifier {
  final _products = <ProductModel>[];

  int get count => _products.length;

  Future loadAllFromDatabase() async {
    _products.clear();
    var collection = await FirebaseFirestore.instance.collection('products').get();

    for (var doc in collection.docs) {
      _products.add(ProductModel.fromJson({'id': doc.id, ...doc.data()}));
    }
  }

  Future addOneToDatabase(ProductModel p) async {
    var ref = await FirebaseFirestore.instance.collection('products').add(p.json);
    updateProduct(p..id = ref.id);
  }
  Future updateOneToDatabase(ProductModel p) async {
    await FirebaseFirestore.instance.collection('products').doc(p.id).set(p.json);
  }
  Future deleteOneFromDatabase(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  List<ProductModel> getSortedList(bool isAscending) {
    return _products..sort((a, b) => (a.price - b.price) * (isAscending ? 1 : -1));
  }

  ProductModel getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void addProduct(ProductModel product) async {
    _products.add(product);
    await addOneToDatabase(product);
    notifyListeners();
  }

  void updateProduct(ProductModel product) async {
    product.modifyTime = DateTime.now();
    int index = _products.indexWhere((p) => p.id == product.id);
    _products[index] = product;
    await updateOneToDatabase(product);
    notifyListeners();
  }

  void deleteProduct(String id) async {
    int index = _products.indexWhere((p) => p.id == id);
    _products.removeAt(index);
    await deleteOneFromDatabase(id);
    notifyListeners();
  }

  bool like(ProductModel product) {
    if (!product.like(UserRepository.user!.uid)) return false;
    updateProduct(product);
    return true;
  }
}