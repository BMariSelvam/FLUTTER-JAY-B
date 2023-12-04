import 'dart:async';

import 'package:JNB/Model/product_model.dart';
import 'package:get/get.dart';

class ProductListService {
  final List<ProductListModel> _productSelectedListItems = [];

  List<ProductListModel> get productListItems => _productSelectedListItems;

  Stream<bool> get productListChangeStream =>
      _productListChangeController.stream;

  final _productListChangeController = StreamController<bool>.broadcast();

  void addToProductList({required ProductListModel productList}) {
    // var existingItem = _productSelectedListItems
    //     .firstWhereOrNull((item) => item.code == productList.code);
    // // if (existingItem != null) {
    // //   existingItem.quantity;
    // //
    // //   existingItem.looseCount;
    // //   existingItem.cartOnCount;
    // //   existingItem.foc;
    // //   existingItem.exchange;
    // //   existingItem.taxPerc;
    // //   existingItem.lsCount;
    // //   existingItem.ctCount;
    // //   existingItem.qtCount;
    // // } else {
    // //   _productSelectedListItems.add(productList);
    // // }

    var existingItemIndex = _productSelectedListItems
        .indexWhere((item) => item.code == productList.code);

    if (existingItemIndex != -1) {
      // Remove the existing item with the same 'code'
      _productSelectedListItems.removeAt(existingItemIndex);
    }

    _productSelectedListItems.add(productList);
    _productListChangeController.add(true);
  }

  void removeFromProductList({required ProductListModel productList}) {
    var existingItem = _productSelectedListItems.firstWhereOrNull(
        (item) => item.productCode == productList.productCode);

    if (productList.quantity != null) {
      _productSelectedListItems
          .removeWhere((item) => item.productCode == productList.productCode);
    }
    _productSelectedListItems.remove(productList);
    _productListChangeController.add(true);
  }

  void clearProductList() {
    _productSelectedListItems.clear();
    _productListChangeController.add(true);
  }

  // Dispose the stream controller
  void disposeProductList() {
    _productListChangeController.close();
  }
}
