import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:grocery_admin/helpers/project_configuration.dart';
import 'package:grocery_admin/models/order.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class OrderDetailsBloc {
  final String path;
  final Database database;

  OrderDetailsBloc({@required this.database, @required this.path});

  // ignore: close_sinks
  StreamController<bool> itemsController = BehaviorSubject();

  Stream<bool> get itemsStream => itemsController.stream;

  // ignore: close_sinks
  StreamController<bool> paymentController = BehaviorSubject();

  Stream<bool> get paymentStream => paymentController.stream;

  // ignore: close_sinks
  StreamController<bool> addressController = BehaviorSubject();

  Stream<bool> get addressStream => addressController.stream;

  // ignore: close_sinks
  StreamController<bool> shippingMethodController = BehaviorSubject();

  Stream<bool> get shippingMethodStream => shippingMethodController.stream;

  //Get order
  Stream<Order> getOrder() {
    return database
        .getDataFromDocument(path)
        .map((snapshot) => Order.fromMap(snapshot.data(), snapshot.id, path));
  }

  //Set new order status
  Future<void> updateOrderStatus(String status, Order order) async {
    await database.updateData({'status': status}, path);

    // await _sendNotification("Your order nº${order.id} is $status", order.id);
  }

  Future<void> _sendNotification(String msg, String id) async {
    // var postUrl = Uri.parse("https://fcm.googleapis.com/fcm/send");
    // String token = await _getToken();
    //
    // print(token);
    //
    // if (token != null) {
    //   final body = {
    //     "notification": {"body": msg, "title": "New order!"},
    //     "priority": "high",
    //     "data": {
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //       "id": id,
    //       "status": "done"
    //     },
    //     "to": "$token"
    //   };
    //
    //   final headers = {
    //     'content-type': 'application/json',
    //     'Authorization': 'key=${ProjectConfiguration.messagingKey}'
    //   };
    //
    //   try {
    //     await http.post(postUrl, headers: headers, body: json.encode(body));
    //   } catch (e) {
    //     print(e);
    //   }
    // }
  }

  Future<String> _getToken() async {
    // String uid = path
    //     .replaceFirst("users/tokens", "")
    //     .substring(0, path.replaceFirst("users/", "").indexOf("/"));
    //
    // print(uid);
    //
    // try {
    //   final snapshot = await database.getFutureDataFromDocument("users/$uid");
    //
    //   return snapshot.data()['token'];
    // } catch (e) {
    //   return null;
    // }
  }
}
