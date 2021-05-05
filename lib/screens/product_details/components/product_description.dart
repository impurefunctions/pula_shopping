import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/screens/compare_search_result/search_result_screen.dart';
import 'package:e_commerce_app_flutter/screens/product_details_comp/product_details_screen.dart';
import 'package:e_commerce_app_flutter/services/data_streams/all_products_stream.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:e_commerce_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {

  final AllProductsStream allProductsStream = AllProductsStream();


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                  text: widget.product.title,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: "\n${widget.product.variant} ",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: getProportionateScreenHeight(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text.rich(
                      TextSpan(
                        text: "\P${widget.product.discountPrice}   ",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                        children: [
                          TextSpan(
                            text: "\n\P${widget.product.originalPrice}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: kTextColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        RaisedButton(onPressed: () async {

    final query = widget.product.title;
    if (query.length <= 0) return;
    List<String> searchedProductsId;
    try {
    searchedProductsId = await ProductDatabaseHelper()
        .searchInProducts(query.toLowerCase());
    if (searchedProductsId != null) {
    await Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => SearchResultScreen(
    searchQuery: query,
    searchResultProductsId: searchedProductsId,
    searchIn: "All Products",
    ),
    ),
    );
    await refreshPage();
    } else {
    throw "Couldn't perform search due to some unknown reason";
    }
    } catch (e) {
    final error = e.toString();
    Logger().e(error);
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("$error"),
    ),
    );

    }








                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreenComp(
                                product: product,
                              ),
                            ),
                          );*/
                        },child: Text("Compare"),
                        color: Colors.blue,
                        textColor: Colors.white,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            /*ExpandableText(
              title: "Highlights",
              content: product.highlights,
            ),
            const SizedBox(height: 16),
            ExpandableText(
              title: "Description",
              content: product.description,
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: "Sold by ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "${product.seller}",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ],
    );
  }

  Future<void> refreshPage() {
    //favouriteProductsStream.reload();
    allProductsStream.reload();
    return Future<void>.value();
  }
}
