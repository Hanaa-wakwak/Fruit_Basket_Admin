import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_admin/blocs/products_bloc.dart';
import 'package:grocery_admin/models/product.dart';
import 'package:grocery_admin/models/theme_model.dart';
import 'package:grocery_admin/services/database.dart';
import 'package:grocery_admin/ui/home/products/add_product.dart';
import 'package:grocery_admin/widgets/cards.dart';
import 'package:grocery_admin/widgets/fade_in.dart';
import 'package:grocery_admin/widgets/texts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Products extends StatelessWidget {
  final ProductsBloc bloc;

  Products({@required this.bloc});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Provider<ProductsBloc>(
      create: (context) => ProductsBloc(database: database),
      child: Consumer<ProductsBloc>(
        builder: (context, bloc, _) {
          return Products(
            bloc: bloc,
          );
        },
      ),
    );
  }

  int productsLength = 0;
  int streamLength = 0;


  int oldLength=0;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    _scrollController.addListener(() {

      if (_scrollController.position.pixels>=_scrollController.position.maxScrollExtent-50 ) {
        if (streamLength != -1) {
          bloc.productsLengthController.add(streamLength + 2 * width ~/ 180);
          }
      }
    });
    return Scaffold(
      appBar: AppBar(
        shadowColor: themeModel.shadowColor,

        title: Texts.headline3('Products', themeModel.textColor),
        centerTitle: true,
        backgroundColor: themeModel.secondBackgroundColor,
        leading: Container(),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 80),
        children: [
          GestureDetector(
            onTap: () {
              AddProduct.create(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: themeModel.secondBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 5),
                        color: themeModel.shadowColor)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: themeModel.accentColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:
                        Texts.headline3("Add Product", themeModel.accentColor),
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<int>(
            stream: bloc.productsLengthStream,
            initialData: (width ~/ 180) * (height ~/ 180),
            builder: (context, lengthSnapshot) {
              streamLength = lengthSnapshot.data;

              return StreamBuilder<List<Product>>(
                  stream: bloc.getProducts(streamLength).asBroadcastStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Product> products = snapshot.data;


                      productsLength = products.length;


                      if (streamLength > productsLength) {
                        streamLength = -1;
                      }

                      return GridView.count(
                        crossAxisCount: (width ~/ 180),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(left: 16, right: 16, top: 20),
                        children: List.generate(products.length, (index) {
                          return FadeIn(
                            duration: Duration(milliseconds: 300),
                            child:Cards.productCard(context,
                                product: products[index], function: () async {
                                 await bloc.removeProduct(products[index].reference);
                                  Navigator.pop(context);
                                })
                          );
                        }),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: SvgPicture.asset(
                            'images/state_images/error.svg',
                            width: isPortrait ? width * 0.5 : height * 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  });
            },
          ),
        ],
      ),
    );
  }
}
