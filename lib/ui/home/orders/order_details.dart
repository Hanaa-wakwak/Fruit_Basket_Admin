import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_admin/blocs/order_details_bloc.dart';
import 'package:grocery_admin/models/order.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/widgets/buttons.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetails extends StatefulWidget {
  final OrderDetailsBloc bloc;

  const OrderDetails({@required this.bloc});

  static create(BuildContext context, String path) {
    final database = Provider.of<Database>(context, listen: false);
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Provider<OrderDetailsBloc>(
                  create: (context) =>
                      OrderDetailsBloc(database: database, path: path),
                  child: Consumer<OrderDetailsBloc>(
                    builder: (context, bloc, _) {
                      return OrderDetails(bloc: bloc);
                    },
                  ),
                )));
  }

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final themeModel = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Texts.headline3('Order Details', themeModel.textColor),
        backgroundColor: themeModel.secondBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeModel.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<Order>(
        stream: widget.bloc.getOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Order order = snapshot.data;

            return ListView(
              padding: EdgeInsets.all(0),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Texts.headline3(
                          'Order №${order.id}', themeModel.textColor),
                      Spacer(),
                      Texts.text(order.date, themeModel.secondTextColor)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Texts.headline3("Status: ", themeModel.textColor),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (order.status == 'Delivered')
                                ? Colors.green
                                : (order.status == 'Declined')
                                    ? Colors.red
                                    : Colors.orange),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          (order.status == 'Delivered')
                              ? Icons.done
                              : (order.status == 'Declined')
                                  ? Icons.clear
                                  : Icons.pending_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      Texts.headline3(
                          order.status,
                          (order.status == 'Delivered')
                              ? Colors.green
                              : (order.status == 'Declined')
                                  ? Colors.red
                                  : Colors.orange),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  vsync: this,
                  child: StreamBuilder<bool>(
                      stream: widget.bloc.itemsStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Container(
                              height: 0.5,
                              color: themeModel.secondTextColor,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.shopping_cart_outlined,
                                color: themeModel.textColor,
                              ),
                              title: Texts.headline3(
                                  "Items", themeModel.textColor),
                              onTap: () {
                                widget.bloc.itemsController.add(!snapshot.data);
                              },
                              contentPadding: EdgeInsets.only(
                                  right: 20, bottom: 5, top: 5, left: 20),
                              trailing: Icon(
                                (!snapshot.data)
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: themeModel.textColor,
                              ),
                            ),
                            (snapshot.data)
                                ? FadeIn(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20, bottom: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Texts.headline3(
                                                '${order.products.length} item' +
                                                    ((order.products.length ==
                                                            1)
                                                        ? ""
                                                        : "s"),
                                                themeModel.textColor),
                                          ),
                                          Column(
                                            children: List.generate(
                                                order.products.length,
                                                (position) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: width / 3,
                                                    child: Texts.headline3(
                                                        order.products[position]
                                                            .title,
                                                        themeModel.textColor),
                                                  ),
                                                  Container(
                                                    width: width / 3,
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Texts.headline3(
                                                        order.products[position]
                                                            .quantity,
                                                        themeModel
                                                            .secondTextColor),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width: width / 3 - 40,
                                                    child: Texts.headline3(
                                                        order.products[position]
                                                                .price
                                                                .toString() +
                                                            "\$",
                                                        themeModel.priceColor),
                                                  ),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        );
                      }),
                ),
                AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    vsync: this,
                    child: StreamBuilder<bool>(
                      initialData: false,
                      stream: widget.bloc.paymentStream,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 0.5,
                              color: themeModel.secondTextColor,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.credit_card_sharp,
                                color: themeModel.textColor,
                              ),
                              title: Texts.headline3(
                                  "Payment", themeModel.textColor),
                              onTap: () {
                                widget.bloc.paymentController
                                    .add(!snapshot.data);
                              },
                              contentPadding: EdgeInsets.only(
                                  right: 20, bottom: 5, top: 5, left: 20),
                              trailing: Icon(
                                (!snapshot.data)
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: themeModel.textColor,
                              ),
                            ),
                            (snapshot.data)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 20),
                                    child: FadeIn(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Texts.headline3(
                                                'Payment type:',
                                                themeModel.textColor),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: Texts.headline3(
                                                order.paymentMethod,
                                                themeModel.secondTextColor),
                                          ),

                                          (order.paymentReference==null)? SizedBox() : Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                            child: Texts.headline3(
                                                'Stripe payment details:',
                                                themeModel.textColor),
                                          ),

                                          (order.paymentReference==null)? SizedBox() : Align(
                                            alignment: Alignment.center,

                                            child: GestureDetector(
                                              onTap: () async {
                                                String url="https://dashboard.stripe.com/payments/"+order.paymentReference;
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: themeModel
                                                        .secondBackgroundColor,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(15)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 2,
                                                          offset: Offset(0, 5),
                                                          color: themeModel
                                                              .shadowColor)
                                                    ]),
                                                padding: EdgeInsets.all(20),
                                                child: FadeInImage(
                                                  placeholder: AssetImage(""),
                                                  image: AssetImage(
                                                      "images/stripe.png"),
                                                  width: 150,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        );
                      },
                    )),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  vsync: this,
                  child: StreamBuilder<bool>(
                    stream: widget.bloc.addressStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 0.5,
                            color: themeModel.secondTextColor,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: themeModel.textColor,
                            ),
                            title: Texts.headline3(
                                "Shipping address", themeModel.textColor),
                            onTap: () {
                              widget.bloc.addressController.add(!snapshot.data);
                            },
                            contentPadding: EdgeInsets.only(
                                right: 20, bottom: 5, top: 5, left: 20),
                            trailing: Icon(
                              (!snapshot.data)
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: themeModel.textColor,
                            ),
                          ),
                          (snapshot.data)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: FadeIn(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3('Full name:',
                                              themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.address.name,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'Address:', themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.address.address,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'State:', themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.address.state,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3('Zip code:',
                                              themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.address.zipCode,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'Country:', themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.address.country,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'Phone:', themeModel.textColor),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Texts.headline3(
                                                  order.address.phone,
                                                  themeModel.secondTextColor),
                                            ),
                                            Spacer(),


                                            Buttons.button(widget: Texts.text("Copy", Colors.white), function: ()async{


                                              await Clipboard.setData(ClipboardData(text: order.address.phone));
                                              Fluttertoast.showToast(
                                                  msg: "Number copied!",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                            }, color: themeModel.accentColor,
                                              margin: EdgeInsets.all(0)
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      );
                    },
                  ),
                ),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  vsync: this,
                  child: StreamBuilder<bool>(
                    stream: widget.bloc.shippingMethodStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 0.5,
                            color: themeModel.secondTextColor,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.local_shipping_outlined,
                              color: themeModel.textColor,
                            ),
                            title: Texts.headline3(
                                "Shipping method", themeModel.textColor),
                            onTap: () {
                              widget.bloc.shippingMethodController
                                  .add(!snapshot.data);
                            },
                            contentPadding: EdgeInsets.only(
                                right: 20, bottom: 5, top: 5, left: 20),
                            trailing: Icon(
                              (!snapshot.data)
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: themeModel.textColor,
                            ),
                          ),
                          (snapshot.data)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: FadeIn(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'Shipping title:',
                                              themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.shippingMethod.title,
                                              themeModel.secondTextColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Texts.headline3(
                                              'Price:', themeModel.textColor),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Texts.headline3(
                                              order.shippingMethod.price
                                                      .toString() +
                                                  "\$",
                                              themeModel.priceColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Container(
                            height: 0.5,
                            color: themeModel.secondTextColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: width * 0.3,
                        child: Texts.headline3(
                            'Total Amount:', themeModel.textColor),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: width * 0.7 - 40,
                        child: Texts.headline3(
                            (order.orderPrice + order.shippingMethod.price)
                                    .toString() +
                                '\$',
                            themeModel.priceColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Buttons.button(
                          color: Colors.red,
                          widget: Texts.headline3("Decline", Colors.white),
                          function: () {
                            widget.bloc.updateOrderStatus('Declined', order);
                          },
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          ),
                      Buttons.button(
                          color: Colors.orange,
                          widget: Texts.headline3("In Process", Colors.white),
                          function: () {
                            widget.bloc.updateOrderStatus('Processing', order);
                          },
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          ),
                      Buttons.button(
                          color: Colors.green,
                          widget: Texts.headline3("Deliver", Colors.white),
                          function: () {
                            widget.bloc.updateOrderStatus('Delivered', order);
                          },
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          ),
                    ],
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return FadeIn(
              duration: Duration(milliseconds: 300),
              child: Center(
                child: SvgPicture.asset(
                  'images/state_images/error.svg',
                  width: width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
