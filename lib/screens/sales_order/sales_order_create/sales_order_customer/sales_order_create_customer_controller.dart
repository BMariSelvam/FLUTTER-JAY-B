import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesOrderCreateCustomerController extends GetxController
    with StateMixin {
  TextEditingController searchcontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();
  TextEditingController deliveryDatecontroller = TextEditingController();
  TextEditingController customerNamecontroller = TextEditingController();
  TextEditingController customerAddresscontroller = TextEditingController();
  TextEditingController customerAddress1controller = TextEditingController();
  TextEditingController customerAddress2controller = TextEditingController();
  TextEditingController customerAddress3controller = TextEditingController();
  TextEditingController currencyNamecontroller = TextEditingController();
  TextEditingController countryNamecontroller = TextEditingController();
  TextEditingController remarkcontroller = TextEditingController();
  String dropDownValue = 'index 0';

  DateTime orderDate = DateTime.now();
  DateTime deliveryDate = DateTime.now();

  String? dates;
  String? deliveryDates;
  bool isChecked = false;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isSelectedFilter = false.obs;
  Rx<bool> isCodeLoading = false.obs;

  CustomerListModel? customer;
  Rx<List<CustomerListModel>?> customerListModel =
      (null as List<CustomerListModel>?).obs;

  Rx<List<CustomerListModel>?> customerCodeListModel =
      (null as List<CustomerListModel>?).obs;

  String? CustomerName = '';
  LoginUser? loginUser;

  CustomerListModel? customerListModelValue;
  double creditLimit = 0.00;
  double outstandingAmount = 0.00;
  double balance = 0.00;

  String? customerCode;

  final ProductListService productService = getIt<ProductListService>();

  getOrderCustomerList(customerName) async {
    isLoading.value = true;
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
            print("QQQQQQQQQQQ");
            print(isChecked);
            isChecked = true;
            print(isChecked);
            print("QQQQQQQQQQQ");
            code();
            print(customerCodeListModel.value);
            print("customerCodeListModel+++++++++++++++");
            change(customerCodeListModel.value);
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

  code1() {
    print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    // customer?.name = customerListModelValue?.name;
    // CustomerName = customerListModelValue?.name ?? "";
    customerNamecontroller.text = customerListModelValue?.name ?? "";

    print(customerNamecontroller.text);
    print(" mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");

    // remarkcontroller.text = customerListModelValue?.remarks ?? "";
    customerAddresscontroller.text =
        "${customerListModelValue?.addressLine1 ?? ""}"
        ","
        "${customerListModelValue?.addressLine1 ?? ""}"
        ","
        "${customerListModelValue?.addressLine1 ?? ""}";

    customerAddress1controller.text =
        customerListModelValue?.addressLine1 ?? "";
    customerAddress2controller.text =
        customerListModelValue?.addressLine2 ?? "";
    customerAddress3controller.text =
        customerListModelValue?.addressLine3 ?? "";

    creditLimit = customerListModelValue?.creditLimit ?? 0.00;
    outstandingAmount = customerListModelValue?.outstandingAmount ?? 0.00;
    if (currencyNamecontroller.text == "SGD" &&
        currencyNamecontroller.text == "" &&
        currencyNamecontroller.text == null &&
        customerListModelValue?.currencyId == null &&
        customerListModelValue?.currencyId == "") {
      currencyNamecontroller.text = "Singapore Dollar";
      countryNamecontroller.text = "Singapore";
    }
    if (countryNamecontroller.text == "SGD" &&
        countryNamecontroller.text == "" &&
        countryNamecontroller.text == null &&
        customerListModelValue?.countryName == null &&
        customerListModelValue?.countryName == "") {
      currencyNamecontroller.text = "Singapore Dollar";
      countryNamecontroller.text = "Singapore";
    }
    //
    currencyNamecontroller.text = "Singapore Dollar";
    countryNamecontroller.text = "Singapore";

    balance = outstandingAmount - creditLimit;
  }

  code() {
    print("iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
    //
    // customer?.name = customerCodeListModel.value?.first.name ?? "";
    // CustomerName = customerCodeListModel.value?.first.name ?? "";

    customerNamecontroller.text = customerCodeListModel.value?.first.name ?? "";

    print(customerNamecontroller.text);
    print(" mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");

    // remarkcontroller.text = customerCodeListModel.value?.first.remarks ?? "";
    customerAddresscontroller.text =
        "${customerCodeListModel.value?.first.addressLine1 ?? ""}"
        ","
        "${customerCodeListModel.value?.first.addressLine1 ?? ""}"
        ","
        "${customerCodeListModel.value?.first.addressLine1 ?? ""}";

    customerAddress1controller.text =
        customerCodeListModel.value?.first.addressLine1 ?? "";
    customerAddress2controller.text =
        customerCodeListModel.value?.first.addressLine2 ?? "";
    customerAddress3controller.text =
        customerCodeListModel.value?.first.addressLine3 ?? "";

    creditLimit = customerCodeListModel.value?.first.creditLimit ?? 0.00;
    outstandingAmount =
        customerCodeListModel.value?.first.outstandingAmount ?? 0.00;
    if (currencyNamecontroller.text == "SGD" &&
        currencyNamecontroller.text == "" &&
        currencyNamecontroller.text == null &&
        customerCodeListModel.value?.first.currencyId == null &&
        customerCodeListModel.value?.first.currencyId == "") {
      currencyNamecontroller.text = "Singapore Dollar";
      countryNamecontroller.text = "Singapore";
    }
    if (countryNamecontroller.text == "SGD" &&
        countryNamecontroller.text == "" &&
        countryNamecontroller.text == null &&
        customerCodeListModel.value?.first.countryName == null &&
        customerCodeListModel.value?.first.countryName == "") {
      currencyNamecontroller.text = "Singapore Dollar";
      countryNamecontroller.text = "Singapore";
    }
    //
    currencyNamecontroller.text = "Singapore Dollar";
    countryNamecontroller.text = "Singapore";

    balance = outstandingAmount - creditLimit;
  }

  void clearData() {
    customer = null;
    CustomerName = "";
    // customerCodeListModel.value?.isEmpty;
    customerNamecontroller.clear();
    remarkcontroller.clear();
    customerAddresscontroller.clear();
    customerAddress1controller.clear();
    customerAddress2controller.clear();
    customerAddress3controller.clear();
    customerCodeListModel.value = null;
    creditLimit = 0.00;
    outstandingAmount = 0.00;
    balance = 0.00;
    currencyNamecontroller.clear();
    countryNamecontroller.clear();
    isChecked = false;
  }
}
