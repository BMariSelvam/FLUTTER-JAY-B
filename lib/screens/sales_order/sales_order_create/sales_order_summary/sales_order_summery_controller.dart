import 'dart:async';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/TaxModel.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SummeryScreenController extends GetxController with StateMixin {
  Uint8List? customerSignatureExportedImage;
  Uint8List? userSignatureExportedImage;

  Rx<bool> isLoading = false.obs;
  Rx<bool> isTaxLoading = false.obs;
  late SalesOrderListModel salesOrderListModel;
  List<ProductListModel> productModel = [];
  final ProductListService productService = getIt<ProductListService>();
  List<TaxModel> taxmodel = [];
  double taxpercentage = 0;
  String tax = "";
  String taxName = "";
  RxInt selectedIndex = 0.obs;

  salesOrderApi() async {
    isLoading.value = true;
    change(null, status: RxStatus.loading());
    int index = 1;

    salesOrderListModel.salesOrderDetail?.forEach((element) {
      element.slNo = index;
      index += 1;
    });
    NetworkManager.post(
            URl: HttpUrl.salesOrderCreatePost,
            params: salesOrderListModel.toJson())
        .then((apiResponse) async {
      isLoading.value = false;
      if (apiResponse.apiResponseModel != null) {
        if (apiResponse.apiResponseModel!.status) {
          productService.productListItems.clear();
          productService.clearProductList();

          await Get.offAndToNamed(AppRoutes.salesOrderSuccessfullyScreen);

          // Timer(const Duration(seconds: 5), () async {
          //
          //   await PreferenceHelper.removeCartData()
          //       .then((value) => Get.toNamed(AppRoutes.salesOrderScreen));
          // });
        } else {
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: apiResponse.error);
      }
    });
  }

  Future<void> getTaxDetails(taxTypeId) async {
    isTaxLoading.value = true;
    LoginUser? loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getTaxGetApi,
      parameters: {
        //todo hardcoded for business id
        "OrganizationId": "${loginUser?.orgId}",
        "TaxCode": taxTypeId,
      },
    ).then((apiResponse) async {
      isTaxLoading.value = false;
      change(null, status: RxStatus.success());
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            List<TaxModel> list = resJson.map<TaxModel>((value) {
              return TaxModel.fromJson(value);
            }).toList();
            taxmodel = list;

            taxpercentage = taxmodel.first.taxPercentage!;
            tax = taxmodel.first.taxType!;
            taxName = taxmodel.first.taxName!;

            change(taxpercentage);
            return;
          }
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      } else {
        change(null, status: RxStatus.error());
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: apiResponse.error);
      }
    });
  }
}
