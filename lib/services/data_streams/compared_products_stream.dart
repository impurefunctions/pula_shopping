import 'package:e_commerce_app_flutter/models/Product.dart';
import 'package:e_commerce_app_flutter/services/database/product_database_helper.dart';

import 'data_stream.dart';

class ComparedProductsStream extends DataStream<List<String>> {
  final String productId;

  ComparedProductsStream(this.productId);
  @override
  void reload() {
    final allProductsFuture =
    ProductDatabaseHelper().getComparedProductsList(productId);
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}