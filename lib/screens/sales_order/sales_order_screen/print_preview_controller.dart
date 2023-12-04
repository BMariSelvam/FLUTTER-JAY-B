import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrintPreviewController extends GetxController with StateMixin {
  Rx<bool> getOrderSalesOrderListCodeModelIsLoading = false.obs;

  LoginUser? loginUser;

  Rx<List<SalesOrderListModel>?> salesOrderListCodeModel =
      (null as List<SalesOrderListModel>?).obs;

  getSalesOrderListCode(tranNo) async {
    getOrderSalesOrderListCodeModelIsLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getSalesOrderByCode,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "TranNo": "$tranNo",
      },
    ).then((apiResponse) {
      getOrderSalesOrderListCodeModelIsLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            salesOrderListCodeModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => SalesOrderListModel.fromJson(e))
                    .toList();
            print(salesOrderListCodeModel);
            print("salesOrderListCodeModel+++++++++++++++");
            change(salesOrderListCodeModel);
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
}
