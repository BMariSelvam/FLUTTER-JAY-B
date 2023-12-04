import 'dart:async';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/TaxModel.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarScreenController extends GetxController with StateMixin {
  TextEditingController searchcontroller = TextEditingController();

  Rx<bool> isLoading = false.obs;
  Rx<bool> isTaxLoading = false.obs;
  Rx<bool> isSalesLoading = false.obs;

  CustomerListModel? customerList;
  Rx<List<CustomerListModel>?> customerListModel =
      (null as List<CustomerListModel>?).obs;

  Rx<List<CustomerListModel>?> customerCodeListModel =
      (null as List<CustomerListModel>?).obs;

  String? CustomerName = '';
  String? customerCode;

  LoginUser? loginUser;
  CustomerListModel? customer;
  List<TaxModel> taxmodel = [];
  double taxpercentage = 0;
  String tax = "";
  String taxName = "";
  final ProductListService productService = getIt<ProductListService>();

  Rx<bool> isCodeLoading = false.obs;

  late SalesOrderListModel salesOrderListModel;

  salesOrderApi() async {
    isSalesLoading.value = true;
    int index = 1;

    salesOrderListModel.salesOrderDetail?.forEach((element) {
      element.slNo = index;
      index += 1;
    });
    NetworkManager.post(
            URl: HttpUrl.salesOrderCreatePost,
            params: salesOrderListModel.toJson())
        .then((apiResponse) async {
      isSalesLoading.value = false;
      if (apiResponse.apiResponseModel != null) {
        if (apiResponse.apiResponseModel!.status) {
          productService.productListItems.clear();
          productService.clearProductList();
          clearData();
          await Get.offAndToNamed(AppRoutes.salesOrderSuccessfullyScreen);
          // Timer(const Duration(seconds: 5), () async {
          //   productService.clearProductList();
          //   Get.offAndToNamed(AppRoutes.salesOrderScreen);
          //   await PreferenceHelper.removeCartData()
          //       .then((value) => Get.offAndToNamed(AppRoutes.salesOrderScreen));
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

  getOrderCustomerList(customerName) async {
    isLoading.value = true;
    change(null, status: RxStatus.loading());
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.salesOrderGetAllCustomersSearch,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CustomerName": "$customerName",
      },
    ).then((apiResponse) {
      isLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            customerListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => CustomerListModel.fromJson(e))
                    .toList();
            print(customerListModel.value);
            print("customerListModel+++++++++++++++");
            print("CustomerName+++++++++++++++$CustomerName");
            change(customerListModel.value);
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

  getCustomersByCodeList(customerCode) async {
    isCodeLoading.value = true;
    change(null, status: RxStatus.loading());
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getCustomersByCodeList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CustomerCode": "$customerCode",
      },
    ).then((apiResponse) {
      isCodeLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            customerCodeListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => CustomerListModel.fromJson(e))
                    .toList();
            print(customerCodeListModel.value);
            print("customerCodeListModel+++++++++++++++");
            change(customerCodeListModel.value);
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

  Future<void> getTaxDetails(taxTypeId) async {
    isTaxLoading.value = true;
    LoginUser? loginUser = await PreferenceHelper.getUserData();
    change(null, status: RxStatus.loading());
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
  // code() {
  //   print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
  //   //
  //   // customer?.name = customerCodeListModel.value?.first.name ?? "";
  //   // CustomerName = customerCodeListModel.value?.first.name ?? "";
  //
  //   customerNamecontroller.text = customerCodeListModel.value?.first.name ?? "";
  //
  //   print(customerNamecontroller.text);
  //   print(" mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
  //
  //   // remarkcontroller.text = customerCodeListModel.value?.first.remarks ?? "";
  //   customerAddresscontroller.text =
  //   "${customerCodeListModel.value?.first.addressLine1 ?? ""}"
  //       ","
  //       "${customerCodeListModel.value?.first.addressLine1 ?? ""}"
  //       ","
  //       "${customerCodeListModel.value?.first.addressLine1 ?? ""}";
  //
  //   customerAddress1controller.text =
  //       customerCodeListModel.value?.first.addressLine1 ?? "";
  //   customerAddress2controller.text =
  //       customerCodeListModel.value?.first.addressLine2 ?? "";
  //   customerAddress3controller.text =
  //       customerCodeListModel.value?.first.addressLine3 ?? "";
  //
  //   creditLimit = customerCodeListModel.value?.first.creditLimit ?? 0.00;
  //   outstandingAmount =
  //       customerCodeListModel.value?.first.outstandingAmount ?? 0.00;
  //   if (currencyNamecontroller.text == "SGD" &&
  //       currencyNamecontroller.text == "" &&
  //       currencyNamecontroller.text == null &&
  //       customerCodeListModel.value?.first.currencyId == null &&
  //       customerCodeListModel.value?.first.currencyId == "") {
  //     currencyNamecontroller.text = "Singapore Dollar";
  //     countryNamecontroller.text = "Singapore";
  //   }
  //   if (countryNamecontroller.text == "SGD" &&
  //       countryNamecontroller.text == "" &&
  //       countryNamecontroller.text == null &&
  //       customerCodeListModel.value?.first.countryName == null &&
  //       customerCodeListModel.value?.first.countryName == "") {
  //     currencyNamecontroller.text = "Singapore Dollar";
  //     countryNamecontroller.text = "Singapore";
  //   }
  //   //
  //   currencyNamecontroller.text = "Singapore Dollar";
  //   countryNamecontroller.text = "Singapore";
  //
  //   balance = outstandingAmount - creditLimit;
  // }

  void clearData() {
    customer = null;
    // customerCodeListModel.value?.isEmpty;
    customerCodeListModel.value = null;
  }
}
