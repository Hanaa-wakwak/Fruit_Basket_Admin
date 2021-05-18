import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/blocs/landing_bloc.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/transitions/FadeRoute.dart';
import 'package:grocery_admin/ui/sign_in.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Landing extends StatelessWidget {
  final LandingBloc bloc;

  Landing({@required this.bloc});

  static create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    Navigator.pushReplacement(
        context,
        FadeRoute(
            page: Provider<LandingBloc>(create: (context)=>LandingBloc(
                auth: auth,
                database: database
            ),

            child: Consumer<LandingBloc>(builder: (context,bloc,_){
              return Landing(bloc: bloc);
        }),

            )));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: bloc.getSignedUser(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FadeIn(
              child: Home.create(context),
            );
          } else {
            return FadeIn(
              child: SignIn.create(context),
            );
          }
        });
  }
}
