import 'package:flutter/cupertino.dart';

class Address {
  final String name;
  final String address;
  final String state;
  final String country;
  final String zipCode;
  final String phone;

  Address({
    @required this.name,
    @required this.address,
    @required this.state,
    @required this.country,
    @required this.zipCode,
    @required this.phone,
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      name: data['name'],
      address: data['address'],
      state: data['state'],
      country: data['country'],
      zipCode: data['zip_code'],
      phone: data['phone'],
    );
  }
}
