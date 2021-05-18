import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_admin/blocs/orders_reader_bloc.dart';
import 'package:grocery_admin/models/order.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/cards.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrdersReader extends StatelessWidget {
  final String status;

  final OrdersReaderBloc bloc;

  static Widget create(BuildContext context, {String status}) {
    final database = Provider.of<Database>(context, listen: false);

    return Provider<OrdersReaderBloc>(
      create: (context) => OrdersReaderBloc(database: database),
      child: Consumer<OrdersReaderBloc>(
        builder: (context, bloc, _) {
          return OrdersReader(bloc: bloc, status: status);
        },
      ),
    );
  }

  OrdersReader({@required this.bloc, this.status});

  ScrollController _scrollController = ScrollController();

  int streamLength = 0;
  int productsLength = 0;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 70) {
        bloc.lengthController.add(streamLength + 10);

      }
    });

    return StreamBuilder<int>(
      stream: bloc.lengthStream,
      initialData: 15,
      builder: (context, snapshot) {
        streamLength = snapshot.data;
        return StreamBuilder<List<Order>>(
            stream: bloc.getOrders(status ?? 'Processing', streamLength),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Order> orders = snapshot.data;

                productsLength = orders.length;

                if (snapshot.data.length == 0) {
                  return FadeIn(
                    duration: Duration(milliseconds: 300),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'images/nothing_found.svg',
                            width: isPortrait ? width * 0.5 : height * 0.5,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Texts.headline3(
                                'Nothing found!', themeModel.accentColor,
                                alignment: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemBuilder: (context, position) {
                      return FadeIn(
                        duration: Duration(milliseconds: 300),
                        child:
                            Cards.orderCard(context, order: orders[position]),
                      );
                    },
                    itemCount: orders.length,
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: SvgPicture.asset(
                    'images/state_images/error.svg',
                    width: width * 0.5,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
      },
    );
  }
}
