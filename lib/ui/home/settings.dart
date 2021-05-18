import 'package:flutter/material.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/auth.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  final AuthBase auth;

  final Database database;
  Settings({@required this.auth,@required this.database});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final database = Provider.of<Database>(context);

    return Settings(auth: auth,database:database ,);
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(


        title: Texts.headline3('Settings', themeModel.textColor),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
        leading: Container(),
        shadowColor: themeModel.shadowColor,

      ),
      body: ListView(
        children: [
          ///Dark mode switch
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              onTap: () {
                themeModel.updateTheme();
              },
              leading: Icon(
                Icons.star_border,
                color: themeModel.accentColor,
              ),
              title: Texts.text('Dark mode', themeModel.textColor),
              trailing: Switch(
                activeColor: themeModel.accentColor,
                value: themeModel.theme.brightness == Brightness.dark,
                onChanged: (value) {
                  themeModel.updateTheme();
                },
              ),
            ),
          ),
          ///Logout button
          Container(
            decoration: BoxDecoration(
                color: themeModel.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),

            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20, top: 20),
            //   padding: EdgeInsets.all(20),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              onTap: () async{
                ///Remove notification token
                await database.setData({}, 'admin/notifications');
                auth.signOut();
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Texts.text('Logout', themeModel.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
