import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesOrderCreateProductController extends GetxController with StateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productCodeController = TextEditingController();
  TextEditingController cartonCountController = TextEditingController();
  TextEditingController looseCountController = TextEditingController();
  TextEditingController qtyCountController = TextEditingController();
  TextEditingController focController = TextEditingController();
  TextEditingController exchangeController = TextEditingController();
  TextEditingController pcsController = TextEditingController();
  TextEditingController cartonPriceController = TextEditingController();
  TextEditingController loosePriceController = TextEditingController();
  ProductListModel? productList;
  bool isSelectedFilter = true;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isCodeLoading = false.obs;
  Rx<List<ProductListModel>?> productListModel =
      (null as List<ProductListModel>?).obs;
  Rx<List<ProductListModel>?> productListCodeModel =
      (null as List<ProductListModel>?).obs;
  RxList<ProductListModel> productModel = <ProductListModel>[].obs;
  RxList<ProductListModel> addProductModel = <ProductListModel>[].obs;
  String? productName = '';
  LoginUser? loginUser;
  final ProductListService productService = getIt<ProductListService>();

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
  RxInt selectedIndex = 0.obs;

  getOrderProductList() async {
    isLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.getAllProductList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
      },
    ).then((apiResponse) {
      isLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            productListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => ProductListModel.fromJson(e))
                    .toList();
            print(productListModel.value);
            print("productListModel+++++++++++++++");
            print("productName+++++++++++++++$productName");
            change(productListModel.value);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "Error",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  getOrderProductCodeList(productCode) async {
    isCodeLoading.value = true;

    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getProductByCodeList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "ProductCode": "$productCode",
      },
    ).then((apiResponse) {
      isCodeLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            productListCodeModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => ProductListModel.fromJson(e))
                    .toList();
            code();
            print(productListCodeModel.value);
            print("productListCodeModel+++++++++++++++");
            change(productListCodeModel.value);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "Error",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }

  code() {
    productNameController.text = productListCodeModel.value?.first.name ?? "";
    productCodeController.text = productListCodeModel.value?.first.code ?? "";
    cartonPriceController.text =
        productListCodeModel.value?.first.sellingBoxCost?.toStringAsFixed(2) ??
            "0";
    loosePriceController.text =
        productListCodeModel.value?.first.sellingCost?.toStringAsFixed(2) ??
            "0";
    pcsController.text =
        productListCodeModel.value?.first.pcsPerCarton?.toStringAsFixed(0) ??
            "0";
    box = productListCodeModel.value!.first.pcsPerCarton?.toDouble() ?? 0.00;
  }

  void clearData() {
    //todo
    productListCodeModel.value = null;
    productList = null;
    productName = "";
    productCodeController.clear();
    productNameController.clear();
    cartonCountController.clear();
    looseCountController.clear();
    qtyCountController.clear();
    focController.clear();
    exchangeController.clear();
    pcsController.clear();
    cartonPriceController.clear();
    loosePriceController.clear();
  }

  // void updateProductCount() {
  //   for (var product in productModel) {
  //     productService.productListItems.firstWhereOrNull((element) {
  //       if (element.productCode == product.productCode) {
  //         productNameController.text = element.name ?? "";
  //         productCodeController.text = element.code ?? "";
  //         pcsController.text = "${element.pcsPerCarton ?? ""}";
  //         cartonPriceController.text =
  //             element.sellingBoxCost?.toStringAsFixed(2) ?? "0";
  //         loosePriceController.text =
  //             element.sellingCost?.toStringAsFixed(2) ?? "0";
  //         pcsController.text = element.pcsPerCarton!.toStringAsFixed(0) ?? "0";
  //         box = element.pcsPerCarton!.toDouble();
  //
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     });
  //   }
  // }
}
