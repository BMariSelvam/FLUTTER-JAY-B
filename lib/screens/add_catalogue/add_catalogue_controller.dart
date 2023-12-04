import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/Model/tax_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutProductController extends GetxController with StateMixin {
  TextEditingController cartonCountController = TextEditingController();
  TextEditingController looseCountController = TextEditingController();
  TextEditingController qtyCountController = TextEditingController();

  TextEditingController focController = TextEditingController();
  TextEditingController exchangeController = TextEditingController();
  TextEditingController pcsController = TextEditingController();

  TextEditingController cartonPriceController = TextEditingController();
  TextEditingController loosePriceController = TextEditingController();

  double boxtotal = 0;
  double Unittotal = 0;
  double qtytotal = 0;
  double subTotal = 0;
  double qty = 0;
  double box = 0;
  double countqty = 0;
  double tax = 0;
  double netTotal = 0;
  double taxValue = 0;
  double boxcount = 0;
  double unitcount = 0;
  double unittotal = 0;
  double subtotal = 0;
  double total = 0;
  double boxCounts = 0;
  double taxPercentage = 0;
  String taxName = "";
  String? selectedItemLength;
  Rx<List<TaxModel>?> taxValueList = (null as List<TaxModel>?).obs;
  int counter = 0;
  RxInt selectedIndex = 0.obs;
  RxBool isAbout = false.obs;
  RxBool isFavorite = false.obs;
  RxBool isLoading = false.obs;

  PageController imageSwipeController = PageController();

  Rx<bool> isCustomersListLoading = false.obs;

  Rx<List<CustomerListModel>?> customerListModel =
      (null as List<CustomerListModel>?).obs;

  RxList<ProductListModel> addProductModel = <ProductListModel>[].obs;

  LoginUser? loginUser;

  final ProductListService productService = getIt<ProductListService>();

  void clearData() {
    cartonCountController.clear();
    looseCountController.clear();
    qtyCountController.clear();
    focController.clear();
    exchangeController.clear();
  }
}
