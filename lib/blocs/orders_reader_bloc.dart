import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:grocery_admin/models/order.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:rxdart/rxdart.dart';

class OrdersReaderBloc {
  final Database database;

  OrdersReaderBloc({@required this.database});

  //Loaded number of orders stream
  // ignore: close_sinks
  StreamController<int> lengthController = BehaviorSubject();

  Stream<int> get lengthStream => lengthController.stream;

  //Get list of orders
  Stream<List<Order>> getOrders(String status, int length) {
    return database
        .getFromCollectionGroupWithValueCondition(
            'orders', length, 'status', status, 'date')
        .map((snapshots) => snapshots.docs.map((snapshot) {
              return Order.fromMap(
                  snapshot.data(), snapshot.id, snapshot.reference.path);
            }).toList());
  }
}
