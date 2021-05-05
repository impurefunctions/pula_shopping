import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import '../constants.dart';
import 'package:e_commerce_app_flutter/models/Product.dart';

class ComparedProductCard extends StatelessWidget {
  final String productId;
  final GestureTapCallback press;
  const ComparedProductCard({
    Key key,
    @required this.productId,
    @required this.press,
  }) : super(key: key);

  makeCard(Product e) {

    return Card(
      elevation: 8,
      child: ListTile(
        onTap:press,
        title: Text.rich(
          TextSpan(
            text: "Sold by: ${e.seller}   ",
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 24,
            ),
          ),
        ),
        trailing: Text.rich(
          TextSpan(
            text: "\P${e.discountPrice.toStringAsFixed(2)}   ",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
      ),

    );


  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(productId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Product product = snapshot.data;
          return makeCard(product);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          Logger().e(error);
        }
        return Center(
          child: Icon(
            Icons.error,
            color: kTextColor,
            size: 60,
          ),
        );
      },
    );
  }


}
