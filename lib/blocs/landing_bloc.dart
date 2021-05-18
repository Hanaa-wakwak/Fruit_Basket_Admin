import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/dialogs.dart';
import 'package:rxdart/rxdart.dart';

class LandingBloc {
  final AuthBase auth;
  final Database database;

  bool _firstCheck = true;

  LandingBloc({@required this.auth, @required this.database});

  Stream<User> getSignedUser(BuildContext context) {
    Stream<User> onAuthStateChanged = auth.onAuthStateChanged;
    // ignore: close_sinks
    StreamController<User> authController = BehaviorSubject();
    onAuthStateChanged.listen((user) {
      if (user == null) {
        if (_firstCheck) {
          _firstCheck = false;
        }
        authController.add(null);
      } else {
        if (_firstCheck) {
          authController.add(user);
        } else {
          _firstCheck = false;

          Future.delayed(Duration.zero).then((value) async {
            try {
              await database.getFutureCollection("permission_check");

              authController.add(user);
            } catch (e) {
              await auth.signOut();

              authController.add(null);

              showDialog(
                  context: context,
                  builder: (context) => Dialogs.error(context,
                      messages: ["You are not the admin!"]));
            }
          });
        }
      }
    });

    return authController.stream;
  }
}
