import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesOrderController extends GetxController with StateMixin {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController fromDatecontroller = TextEditingController();
  TextEditingController toDatecontroller = TextEditingController();
  TextEditingController customerCodecontroller = TextEditingController();
  GlobalKey<ScaffoldState> salesOrderScaffoldKey = GlobalKey<ScaffoldState>();
  String currentTimeAndDate = "";
  DateTime selectedDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  String date = "";
  String toDate = "";
  bool isChecked = false;
  bool isSelectedFilter = true;
  bool isSearchFilter = false;
  Rx<bool> getOrderSearchListIsLoading = false.obs;
  Rx<bool> getOrderSearchListIsLoading2 = false.obs;
  Rx<bool> getOrderListIsLoading = false.obs;
  Rx<bool> getOrderCustomerListIsLoading = false.obs;
  Rx<bool> getOrderSalesOrderListCodeModelIsLoading = false.obs;

  Rx<List<SalesOrderListModel>?> salesOrderSearchListModel =
      (null as List<SalesOrderListModel>?).obs;
  LoginUser? loginUser;

  CustomerListModel? customerList;
  Rx<List<CustomerListModel>?> customerListModel =
      (null as List<CustomerListModel>?).obs;
  Rx<List<SalesOrderListModel>?> salesOrderListCodeModel =
      (null as List<SalesOrderListModel>?).obs;

  String? customerName;
  String? companyBranch;

  getOrderCustomerList(customerName) async {
    getOrderCustomerListIsLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.salesOrderGetAllCustomersSearch,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CustomerName": "$customerName",
      },
    ).then((apiResponse) {
      getOrderCustomerListIsLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          if (resJson != null) {
            customerListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => CustomerListModel.fromJson(e))
                    .toList();
            print(customerListModel);
            print("customerListModel+++++++++++++++");
            change(customerListModel);
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

  getSalesOrderListCode(tranNo) async {
    getOrderSalesOrderListCodeModelIsLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getCustomersByCodeList,
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

  getOrderCodeList(
      {customerCode,
      searchFromDate,
      searchToDate,
      required bool isSearch}) async {
    if (isSearch == false) {
      getOrderSearchListIsLoading.value = true;
    }
    if (isSearch == true) {
      isSearchFilter = true;
    }

    companyBranch = await PreferenceHelper.getBranchCodeString();
    loginUser = await PreferenceHelper.getUserData();

    NetworkManager.get(
      url: HttpUrl.salesOrderGetHeaderSearch,
      parameters: {
        "searchModel.organisationId": "${loginUser?.orgId}",
        "searchModel.customerCode": "$customerCode" ?? "",
        "searchModel.branchCode": companyBranch ?? "",
        "searchModel.fromdate": "$searchFromDate",
        "searchModel.todate": "$searchToDate",
        // "searchModel.status": 0,
      },
    ).then((apiResponse) {
      if (isSearch == false) {
        getOrderSearchListIsLoading.value = false;
      }
      if (isSearch == true) {
        isSearchFilter = false;
      }

      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            salesOrderSearchListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => SalesOrderListModel.fromJson(e))
                    .toList();
            print(salesOrderSearchListModel);
            print("salesOrderCodeListModel+++++++++++++++");
            change(salesOrderSearchListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      } else {
        isSearchFilter = false;
        change(null, status: RxStatus.error());
        String? message = apiResponse.apiResponseModel?.message;
        PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "msg",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  clearData() {
    customerList = null;
    customerCodecontroller.clear();
    toDatecontroller.clear();
    fromDatecontroller.clear();
    searchcontroller.clear();
  }
}
