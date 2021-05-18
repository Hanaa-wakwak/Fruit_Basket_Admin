import 'package:flutter/material.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/ui/home/orders/orders_reader.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: themeModel.shadowColor,
          title: Texts.headline3('Orders', themeModel.textColor),
          centerTitle: true,
          backgroundColor: themeModel.secondBackgroundColor,
          leading: Container(),
          bottom: TabBar(
            tabs: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Texts.subheads('Processing', themeModel.secondTextColor),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Texts.subheads('Delivered', themeModel.secondTextColor),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Texts.subheads('Declined', themeModel.secondTextColor),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdersReader.create(context),
            OrdersReader.create(context, status: 'Delivered'),
            OrdersReader.create(context, status: 'Declined'),
          ],
        ),
      ),
    );
  }
}
