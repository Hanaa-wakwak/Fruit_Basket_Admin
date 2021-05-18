import 'package:flutter/material.dart';
import 'package:grocery_admin/models/order.dart';
import 'package:grocery_admin/models/product.dart';
import 'package:grocery_admin/models/shipping_method.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/ui/home/orders/order_details.dart';
import 'package:grocery_admin/ui/home/products/add_product.dart';
import 'package:grocery_admin/ui/home/shipping/add_shipping.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

import 'buttons.dart';


///All cards used in the app
class Cards{


  static Widget shippingCard(BuildContext context,{@required ShippingMethod shippingMethod,@required Function function}){
    final themeModel=Provider.of<ThemeModel>(context);

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: themeModel.secondBackgroundColor,
            borderRadius:
            BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 5),
                  color: themeModel.shadowColor)
            ]),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Texts.headline3(
                        shippingMethod.title,
                        themeModel.textColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      child: Texts.descriptionText(
                          shippingMethod.duration +
                              " (${shippingMethod.price}\$)",
                          themeModel.secondTextColor),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: themeModel.secondTextColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              color: themeModel
                                  .theme.backgroundColor),
                          padding: EdgeInsets.all(20),
                          child: Wrap(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Texts.headline2(
                                    "Are you Sure?",
                                    themeModel.textColor),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Buttons.button(
                                        widget: Texts.headline3(
                                            "Cancel",
                                            themeModel
                                                .secondTextColor),
                                        function: () {
                                          Navigator.pop(
                                              context);
                                        },
                                        color: themeModel
                                            .secondTextColor,
                                        border: true,
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            left: 20),
                                        child: Buttons.button(
                                            widget: Texts
                                                .headline3(
                                                "Delete",
                                                Colors
                                                    .white),
                                            function:function,
                                            color:
                                            Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        AddShipping.create(context,
            shippingMethod: shippingMethod);
      },
    );



  }

  static Widget productCard(BuildContext context,{@required Product product,@required Function function}){
    final themeModel=Provider.of<ThemeModel>(context);
    double width=MediaQuery.of(context).size.width;


    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: themeModel.secondBackgroundColor,
            borderRadius:
            BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 5),
                  color: themeModel.shadowColor)
            ]),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  FadeInImage(
                    height:
                    (width * 0.5) / (width ~/ 180),
                    image: NetworkImage(
                        product.image),
                    placeholder: AssetImage(""),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10),
                    child: Texts.text(
                        product.title,
                        themeModel.textColor,
                        textOverflow:
                        TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      child: Texts.text(
                          "${(product.pricePerKg == null) ? product.pricePerPiece : product.pricePerKg}\$",
                          themeModel.priceColor),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: themeModel.secondTextColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.only(
                                topLeft:
                                Radius.circular(15),
                                topRight:
                                Radius.circular(15),
                              ),
                              color: themeModel
                                  .theme.backgroundColor),
                          padding: EdgeInsets.all(20),
                          child: Wrap(
                            children: [
                              Align(
                                alignment:
                                Alignment.center,
                                child: Texts.headline2(
                                    "Are you Sure?",
                                    themeModel.textColor),
                              ),
                              Align(
                                alignment:
                                Alignment.center,
                                child: Padding(
                                  padding:
                                  EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Buttons.button(
                                        widget: Texts
                                            .headline3(
                                            "Cancel",
                                            themeModel
                                                .secondTextColor),
                                        function: () {
                                          Navigator.pop(
                                              context);
                                        },
                                        color: themeModel
                                            .secondTextColor,
                                        border: true,
                                      ),
                                      Padding(
                                        padding: EdgeInsets
                                            .only(
                                            left: 20),
                                        child: Buttons
                                            .button(
                                            widget: Texts.headline3(
                                                "Delete",
                                                Colors
                                                    .white),
                                            function:function,
                                            color: Colors
                                                .red),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        AddProduct.create(context,
            product: product);
      },
    );

  }


  static Widget orderCard(BuildContext context,{@required Order order}){

    final themeModel=Provider.of<ThemeModel>(context);
    return ListTile(
      title: Texts.headline3(
          "Order N:" + order.id,
          themeModel.textColor),
      subtitle: Texts.text(order.date,
          themeModel.secondTextColor),
      onTap: () {
        OrderDetails.create(
            context, order.path);
      },
    );

  }
}