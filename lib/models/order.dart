import 'package:flutter/foundation.dart';
import 'package:grocery_admin/models/address.dart';

import 'order_product_items.dart';
import 'shipping_method.dart';

class Order {
  final String id;
  final List<OrdersProductItem> products;
  final ShippingMethod shippingMethod;
  final num orderPrice;
  final String status;
  final String date;
  final String path;
  final Address address;
  final String paymentReference;
  final String paymentMethod;

  factory Order.fromMap(Map data, String id, String path) {
    
    

    return Order(
        id: id,
      paymentReference: data["payment_reference"],
      paymentMethod: data["payment_method"] ?? "Cash in Delivery",
        date: data['date'],
        products: OrdersProductItem.fromMap(data['products']),
        shippingMethod: ShippingMethod(
          title: data['shipping_method']['title'],
          price: data['shipping_method']['price'],
        ),
        address: Address.fromMap(data['shipping_address']),
        orderPrice: data['order'],
        status: data['status'] ?? "Processing",
        path: path,
      
     
      
    );
  }

  Order(
      {@required this.id,
      @required this.date,
      @required this.products,
      @required this.paymentMethod,
      @required this.paymentReference,
      @required this.shippingMethod,
      @required this.orderPrice,
      @required this.status,
      @required this.path,
      @required this.address,

      });
}
