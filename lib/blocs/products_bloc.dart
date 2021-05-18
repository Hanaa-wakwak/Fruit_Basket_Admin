
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocery_admin/models/product.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  final Database database;

  ProductsBloc({@required this.database});

  //Loaded number of products stream
  // ignore: close_sinks
  StreamController<int> productsLengthController = BehaviorSubject();

  Stream<int> get productsLengthStream => productsLengthController.stream;

  //Get list of products
  Stream<List<Product>> getProducts(int length) {
    return database
        .getDataFromCollectionByUserID("products", length)
        .map((snapshots) => snapshots.docs.map((snapshot) {
      var data = snapshot.data();
      data['reference'] = snapshot.id;
      return Product.fromMap(data);
    }).toList());
  }

  //Remove Product
  Future<void> removeProduct(String reference) async {
    await database.removeData('products/$reference');
  }
}
