import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';

class HomeModel {
  final PageController pageController = PageController(keepPage: false);

  final Database database;
  final AuthBase auth;

  HomeModel({@required this.database, @required this.auth});

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  // Future<void> checkNotificationToken() async {
  //   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //
  //   String token = await _firebaseMessaging.getToken();
  //   database.setData({
  //     "token": token,
  //   }, 'admin/notifications');
  // }
}
