import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Helper/extension.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:JNB/Model/sales_order/sales_order_model.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_customer/sales_order_create_customer_controller.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_product/sales_order_create_Product_controller.dart';
import 'package:JNB/screens/signature/signature_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../Model/customer_list_model.dart';
import '../../../../Model/product_model.dart';
import 'sales_order_summery_controller.dart';

class SalesOrderSummaryScreen extends StatefulWidget {
  const SalesOrderSummaryScreen({super.key});

  @override
  State<SalesOrderSummaryScreen> createState() =>
      _SalesOrderSummaryScreenState();
}

class _SalesOrderSummaryScreenState extends State<SalesOrderSummaryScreen> {


  late SummeryScreenController summeryScreenController;
  late SalesOrderCreateCustomerController customerController;
  late SalesOrderCreateProductController productController;

  List<CustomerListModel> customerCodeListModel = [];

  TextEditingController locationcontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();
  TextEditingController signaturecontroller = TextEditingController();

  XFile? pickedFile;
  String customerSignatureExportedImage = "";
  String userSignatureExportedImage = "";

  final geoLocator =
  Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? _currentPosition;
  String currentAddress = "";
  String? customerId;
  String? userName;
  int? orgId;
  String? countryId;
  double? taxPec;
  String? address;
  String? fillAddress;
  String? postalCode;
  String? emailId;
  String? priceSettingCode;
  String? termCode;
  String? branchCode;
  String? customerCode;

  String currentDate =
  DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

  String? companyBranch = '';
  SignatureCImage? sign1;
  double taxValue = 0;
  double boxtotal = 0;
  double unittotal = 0;
  double subtotal = 0;
  double taxPerc = 0;
  double grandTotal = 0;
  double totalcount = 0;
  double total = 0;
  var a = 0;
  var b = 0;
  List<ProductListModel> productList = [];

  var summaryListUnitPrice;
  var summaryListCartPrice;
  var summaryListTotalPrice;
  var summaryListTotalCount;

  String? customerSignature;
  String? userSignature;
  var fullAddress;
  Offset _tapPosition = Offset.zero;
  String?  currencyId;

  DateTime? date;

  String?  remark;

  @override
  void initState() {
    super.initState();
    print("--------------chgecking");
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Timer(const Duration(seconds: 3),
    //           () =>PreferenceHelper.showLoader());
    // });
    locationPermission();
    getUserData();
    summeryScreenController = Get.put(SummeryScreenController());
    // summeryController =
    //     Get.put(SalesOrderCreateCustomerController());
    // productController =
    //     Get.put(SalesOrderCreateProductController());
    customerController = Get.find<SalesOrderCreateCustomerController>();
    productController = Get.put(SalesOrderCreateProductController());
    customerCodeListModel =
        customerController.customerCodeListModel.value!.toList();
    remark = customerController.remarkcontroller.text;
    date = customerController.orderDate;
    print("customerCodeListModel.first.name");
    print(customerCodeListModel.first.name);
    productList = summeryScreenController.productService.productListItems;
    summeryScreenController.productService.productListChangeStream.listen((
        _) {});
    if (customerCodeListModel.first.taxTypeId !=
        null) {
      print("customerCodeListModel.first.taxTypeId");
      print("......${customerCodeListModel.first.taxTypeId}.....");
      if (customerCodeListModel.first.taxTypeId!.isNotEmpty){

        summeryScreenController.getTaxDetails(customerCodeListModel.first.taxTypeId ?? "")
            .then((value) {
          setState(() {});
        });
      } else {
        summeryScreenController.taxpercentage = 7;
        summeryScreenController.tax = "I";
        // summeryScreenController.taxName = "Inclusive";
      }
    } else {
      summeryScreenController.taxpercentage = 7;
      summeryScreenController.tax = "I";
      // summeryScreenController.taxName = "Inclusive";
    }
    fullAddress =
    "${customerCodeListModel.first.addressLine1 ?? ""}"
        ","
        "${customerCodeListModel.first.addressLine2 ?? ""}"
        ","
        "${customerCodeListModel.first.addressLine3 ?? ""}";
  }


  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Timer(const Duration(seconds: 3),
      //           () =>PreferenceHelper.showLoader());
      // });
      locationPermission();
      getUserData();
      summeryScreenController = Get.put(SummeryScreenController());
      // summeryController =
      //     Get.put(SalesOrderCreateCustomerController());
      // productController =
      //     Get.put(SalesOrderCreateProductController());
      customerController = Get.find<SalesOrderCreateCustomerController>();
      productController = Get.put(SalesOrderCreateProductController());
      customerCodeListModel =
          customerController.customerCodeListModel.value!.toList();
      remark = customerController.remarkcontroller.text;
      date = customerController.orderDate;
      date = customerController.orderDate;
      currencyId = customerController.currencyNamecontroller.text;
      print("customerCodeListModel.first.name");
      print(customerCodeListModel.first.name);
      productList = summeryScreenController.productService.productListItems;
      summeryScreenController.productService.productListChangeStream.listen((
          _) {});
      if (customerCodeListModel.first.taxTypeId !=
          null) {
        print("customerCodeListModel.first.taxTypeId");
        print("......${customerCodeListModel.first.taxTypeId}.....");
        if (customerCodeListModel.first.taxTypeId!.isNotEmpty){

          summeryScreenController.getTaxDetails(customerCodeListModel.first.taxTypeId ?? "")
              .then((value) {
            setState(() {});
          });
        } else {
          summeryScreenController.taxpercentage = 7;
          summeryScreenController.tax = "I";
          // summeryScreenController.taxName = "Inclusive";
        }
      } else {
        summeryScreenController.taxpercentage = 7;
        summeryScreenController.tax = "I";
        // summeryScreenController.taxName = "Inclusive";
      }
      fullAddress =
      "${customerCodeListModel.first.addressLine1 ?? ""}"
          ","
          "${customerCodeListModel.first.addressLine2 ?? ""}"
          ","
          "${customerCodeListModel.first.addressLine3 ?? ""}";
    });
  }


  @override
  Widget build(BuildContext context) {
    double taxValue = 0;
    double boxtotal = 0;
    double unittotal = 0;
    double subtotal = 0;
    double grandTotal = 0;

    for (var element in productList) {
      unittotal += element.lsCount! * element.sellingCost!;
      boxtotal += element.ctCount! * element.sellingBoxCost!;
      subtotal = unittotal + boxtotal;
      taxValue = (subtotal * summeryScreenController.taxpercentage) / 100;
      if (summeryScreenController?.tax == "I") {
        grandTotal = subtotal;
      } else if (summeryScreenController.tax == "E") {
        grandTotal = subtotal + taxValue;
      } else if (summeryScreenController.tax == "Z") {
        grandTotal = subtotal + taxValue;
      } else {
        grandTotal = subtotal + taxValue;
      }
    }

    // if (customerCodeListModel.first.currencyId == "SGD") {
    //   // currencyId = customerCodeListModel.first.currencyId;
    //   currencyId = "Singapore Dollar";
    // }
    return GetBuilder<SummeryScreenController>(builder: (logic) {
      if (summeryScreenController.isLoading.value == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      // if (customerCodeListModel.first.code=="") {
      //   return Container(
      //     color: MyColors.white,
      //     child: Center(child: PreferenceHelper.showLoader()),
      //   );
      // }
      return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Customer Details",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: MyFont.myFont2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 0.5,
                                    color: MyColors.white),
                              ),
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     size: 20,
                              //     color: MyColors.white,
                              //   ),
                              //   onPressed: () {
                              //     Get.toNamed(AppRoutes.bottomNavBar,
                              //         arguments: summeryController
                              //             .customerCodeListModel.value?.first.code);
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: MyColors.mainTheme,
                shadowColor: Colors.grey,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: MyColors.white),
                  onPressed: () {
                    showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25)),
                              side: BorderSide(
                                width: 2,
                                color: MyColors.lightmainTheme,
                              ),
                            ),
                            title: const Text('Do you want to go Sales Order?'),
                            actionsAlignment: MainAxisAlignment.spaceAround,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    // Navigator.pop(context, true);
                                    Get.toNamed(AppRoutes.salesOrderScreen);
                                    productController.clearData();
                                    customerController.clearData();
                                    summeryScreenController.productService
                                        .clearProductList();
                                  });
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    // bottomNavBar
                                    Get.offAndToNamed(AppRoutes.bottomNavBar);
                                  });
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        });
                  },
                ),
                titleTextStyle: TextStyle(
                    fontFamily: MyFont.myFont2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.white),
                title: const Text(
                  'Sales Summary',
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.save,
                        size: 25,
                        color: MyColors.white,
                      ),
                      onPressed: () {
                        if (productList.isEmpty) {
                          productList.clear();
                          Get.showSnackbar(
                            const GetSnackBar(
                              margin: EdgeInsets.all(10),
                              borderRadius: 10,
                              backgroundColor: Colors.red,
                              snackPosition: SnackPosition.TOP,
                              message: "Please select atleast one product",
                              icon: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Get.toNamed(AppRoutes.bottomNavBar1);
                        } else {
                          var taxTypeId =
                          (customerCodeListModel.first.taxTypeId!.isNotEmpty)
                              ? int.parse(
                              customerCodeListModel.first.taxTypeId ??
                                  "")
                              : 0;


                          summeryScreenController.salesOrderListModel =
                              SalesOrderListModel(
                                salesOrderDetail: summeryScreenController
                                    .productService.productListItems
                                    .map((e) =>
                                    SalesOrderModel(
                                        orgId: orgId,
                                        tranNo: "",
                                        slNo: e.slNO,
                                        productCode: e.code,
                                        productName: e.name,
                                        boxCount: e.pcsPerCarton ?? 0,
                                        pcsQty: e.lsCount!,
                                        boxQty: e.ctCount!,
                                        qty: ((e.ctCount! * e.pcsPerCarton!)
                                            .toInt() + e.lsCount!),
                                        foc: int.parse(e.foc!),
                                        exchange: int.parse(e.exchange!),
                                        boxPrice: e.sellingBoxCost,
                                        price: e.sellingCost!,
                                        total: (e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        itemDiscount: 0,
                                        itemDiscountPerc: 0,
                                        subTotal: (e.lsCount! *
                                            e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        tax: (((e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            summeryScreenController
                                                .taxpercentage
                                                .toDouble() /
                                            100),
                                        netTotal: (((e.lsCount! *
                                            e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            summeryScreenController
                                                .taxpercentage
                                                .toDouble() /
                                            100) +
                                            ((e.lsCount! * e.sellingCost!) +
                                                (e.ctCount! *
                                                    e.sellingBoxCost!)),
                                        fPrice: e.sellingCost,
                                        fBoxPrice: e.sellingBoxCost,
                                        fTotal: (e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        fTax: (((e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            summeryScreenController
                                                .taxpercentage.toDouble() /
                                            100),
                                        fNetTotal: (((e.lsCount! *
                                            e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            summeryScreenController
                                                .taxpercentage.toDouble() /
                                            100) +
                                            ((e.lsCount! * e.sellingCost!) +
                                                (e.ctCount! *
                                                    e.sellingBoxCost!)),
                                        createdBy:userName??"",
                                        createdOn: currentDate,
                                        changedBy:userName??"",
                                        changedOn: currentDate,
                                        stockQty: 0,
                                        stockBoxQty: 0,
                                        weight: 0,
                                        remarks: remark,
                                        taxPerc: e.taxPerc,
                                        fSubTotal: (e.lsCount! *
                                            e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        fItemDiscount: 0,
                                        stockPcsQty: 0))
                                    .toList(),
                                billDiscount: 0,
                                orgId: orgId,
                                tranNo: "",
                                tranDate: currentDate,
                                customerId: customerCodeListModel.first.code ??
                                    "",
                                customerName: customerCodeListModel.first
                                    .name ?? "",
                                customerAddress: fullAddress,
                                locationCode: companyBranch,
                                taxCode: taxTypeId,
                                taxType: summeryScreenController.tax,
                                taxPerc: summeryScreenController.taxpercentage,
                                currencyCode: customerCodeListModel.first
                                    .currencyId ?? "SGD",
                                currencyRate: 1,
                                total: grandTotal,
                                discount: 0,
                                discountPerc: 0,
                                subTotal: subtotal,
                                tax: taxValue,
                                netTotal: grandTotal,
                                fTotal: grandTotal,
                                fDiscount: 0,
                                fSubTotal: subtotal,
                                fTax: taxValue,
                                fNetTotal: grandTotal,
                                referenceNo: "",
                                remarks: remark,
                                createdFrom: "M",
                                isActive: true,
                                createdBy:userName??"",
                                createdOn: currentDate,
                                changedBy: userName??"",
                                changedOn: currentDate,
                                assignTo:userName??"",
                                tranDateString: currentDate,
                                status: 0,
                                isUpdate: false,
                                customerShipToId: 0,
                                customerShipToAddress: currentAddress,
                                priceSettingCode: "",
                                termCode: "",
                                invoiceType: true,
                                latitude: _currentPosition?.latitude,
                                longitude: _currentPosition?.longitude,
                                signatureimage: customerSignature,
                                cameraimage: pickedFile?.path ?? "",
                                summaryRemarks: customerCodeListModel.first
                                    .remarks ?? "",
                                addressLine1: customerCodeListModel
                                    .first.addressLine1 ??
                                    "",
                              );
                          summeryScreenController.salesOrderApi();
                          productController.clearData();
                          customerController.clearData();
                        }
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: MyColors.mainTheme),
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Sub Total',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "\$ ${subtotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tax',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "\$ ${taxValue.toStringAsFixed(2)}",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Net Total',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "\$ ${grandTotal.toStringAsFixed(2)}",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.white),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              backgroundColor: MyColors.white,
              body: RefreshIndicator(
                onRefresh: _refreshData,
                child: WillPopScope(
                  onWillPop: () async {
                    final shouldPop = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            side: BorderSide(
                              width: 2,
                              color: MyColors.lightmainTheme,
                            ),
                          ),
                          title: const Text('Do you want to go Sales Order?'),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Navigator.pop(context, true);
                                Get.toNamed(AppRoutes.salesOrderScreen);
                                productController.clearData();
                                customerController.clearData();
                                summeryScreenController.productService
                                    .clearProductList();
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Get.offAndToNamed(AppRoutes.bottomNavBar0);
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                    return shouldPop!;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Customer Code",
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                  color: MyColors.mainTheme),
                                            ),
                                          ),
                                          Text(
                                            " :  ",
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontFamily: MyFont.myFont2,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 5.5,
                                        child: Text(

                                          customerCodeListModel.first.code ??
                                              "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width(context) / 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date   :",
                                          style: TextStyle(
                                              decoration: TextDecoration
                                                  .none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.mainTheme),
                                        ),
                                        Text(formatDate(
                                            date.toString() ??
                                                ""),

                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                        width: width(context) / 3.5,
                                        child: Text(
                                          "Customer Name",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.mainTheme),
                                        ),
                                      ),
                                      Text(
                                        " :  ",
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: MyFont.myFont2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            color: MyColors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width(context) / 2,
                                    child: Text(

                                      customerCodeListModel.first.name ??
                                          "",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: MyFont.myFont2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          color: MyColors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                        width: width(context) / 3.5,
                                        child: Text(
                                          "Currency",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.mainTheme),
                                        ),
                                      ),
                                      Text(
                                        " :  ",
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: MyFont.myFont2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            color: MyColors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width(context) / 2,
                                    child: Text(
                                      currencyId ?? "Singapore Dollar",
                                      // "${customerCodeListModel.first.currencyId ?? "SingaporeDollar"}",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: MyFont.myFont2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          color: MyColors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(
                                        width: width(context) / 3.5,
                                        child: Text(
                                          "Address",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                              color: MyColors.mainTheme),
                                        ),
                                      ),
                                      Text(
                                        " :  ",
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontFamily: MyFont.myFont2,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            color: MyColors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width(context) / 2,
                                    child: Text(
                                      "${customerCodeListModel.first
                                          .addressLine1 ?? ""}"
                                          ","
                                          "${customerCodeListModel.first
                                          .addressLine2 ?? ""}"
                                          ","
                                          "${customerCodeListModel.first
                                          .addressLine3 ?? ""}",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: MyFont.myFont2,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        color: MyColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: width(context),
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                              color: MyColors.mainTheme),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                ),
                                child: Text(
                                  'Product Details',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 0.5,
                                      color: MyColors.white),
                                ),
                              ),
                              // IconButton(
                              //   icon: const Icon(
                              //     Icons.cleaning_services,
                              //     size: 18,
                              //     color: MyColors.white,
                              //   ),
                              //   onPressed: () {
                              //     summeryScreenController.productService.productListItems
                              //         .clear();
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          color: MyColors.lightmainTheme2,
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(0.3),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(0.2),
                                },
                                children: [
                                  TableRow(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Code',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Description',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                },
                                children: [
                                  TableRow(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Carton',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Unit',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              const SizedBox(height: 5),
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: FlexColumnWidth(),
                                },
                                children: [
                                  TableRow(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'C Price',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'U Price',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Amt',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: MyFont.myFont2),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ],
                          ),
                        ),

                        listView(),


                        // productDetailsList(),
                        SizedBox(
                          height: height(context) / 40,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(
                            //     top: 10,
                            //     bottom: 10,
                            //     left: 10,
                            //     right: 10,
                            //   ),
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: MyColors.greyText),
                            //       borderRadius: BorderRadius.circular(20),
                            //       color: MyColors.white),
                            //   padding: const EdgeInsets.symmetric(
                            //       vertical: 15, horizontal: 10),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       SizedBox(
                            //         width: width(context) / 1.3,
                            //         child: Text(
                            //           currentAddress,
                            //           textAlign: TextAlign.start,
                            //           style: TextStyle(
                            //               decoration: TextDecoration.none,
                            //               fontFamily: MyFont.myFont2,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 14,
                            //               color: MyColors.black),
                            //         ),
                            //       ),
                            //       const Icon(
                            //         Icons.location_on,
                            //         color: MyColors.pink,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           "Image",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             fontFamily: MyFont.myFont,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 15,
                            //             color: MyColors.black,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Container(
                            //         alignment: Alignment.center,
                            //         child: Text(
                            //           "Singnature",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             fontFamily: MyFont.myFont,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 15,
                            //             color: MyColors.black,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: height(context) / 9,
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      left: 10,
                                      right: 5,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: MyColors.greyText),
                                        borderRadius: BorderRadius.circular(20),
                                        color: MyColors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: MyColors.pink,
                                        ),
                                        SingleChildScrollView(
                                          child: SizedBox(
                                            width: width(context) / 5.8,
                                            child: Text(
                                              currentAddress,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  color: MyColors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _getImage(true);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 5,
                                        right: 5,
                                      ),
                                      height: height(context) / 9,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyColors.greyText),
                                          borderRadius: BorderRadius.circular(
                                              20),
                                          color: MyColors.white),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Container(
                                        child: (pickedFile == null)
                                            ? Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              Assets.upLoadImage,
                                              // fit: BoxFit.fill,
                                              scale: 4,
                                            ),
                                          ],
                                        )
                                            : pickedFile != null
                                            ? Image.file(
                                          File(pickedFile!.path),
                                          fit: BoxFit.fill,
                                        )
                                            : Container(
                                            color: Colors.grey,
                                            child: const Icon(
                                              Icons.person,
                                              size: 70,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (
                                                context) => const SignatureScreen(),
                                          )).then((value) {
                                        setState(() {
                                          sign1 = value as SignatureCImage;
                                          Uint8List customerSignatureUint8List =
                                          Uint8List.fromList(
                                              sign1!
                                                  .customerSignatureExportedImage!);
                                          customerSignature =
                                              base64Encode(
                                                  customerSignatureUint8List);
                                          Uint8List userSignatureUint8List =
                                          Uint8List.fromList(
                                              sign1!
                                                  .userSignatureExportedImage!);
                                          userSignature =
                                              base64Encode(
                                                  userSignatureUint8List);
                                        });
                                      });
                                    },
                                    child: Builder(builder: (context) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 5,
                                          right: 10,
                                        ),
                                        height: height(context) / 9,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: MyColors.greyText),
                                            borderRadius: BorderRadius.circular(
                                                20),
                                            color: MyColors.white),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 05, horizontal: 20),
                                        child: (sign1
                                            ?.userSignatureExportedImage !=
                                            null &&
                                            sign1
                                                ?.customerSignatureExportedImage !=
                                                null)
                                            ? Column(
                                          children: [
                                            Text(
                                              "Customer Signature",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: MyFont.myFont2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 5,
                                                color: MyColors.black,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: MyColors.white,
                                              ),
                                              width: width(context),
                                              height: 25,
                                              child: Image.memory(
                                                sign1!
                                                    .customerSignatureExportedImage!,
                                                scale: 2,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              "User Signature",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: MyFont.myFont2,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 5,
                                                color: MyColors.black,
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: MyColors.white,
                                              ),
                                              width: width(context),
                                              height: 25,
                                              child: Image.memory(
                                                sign1!
                                                    .userSignatureExportedImage!,
                                                scale: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                            : Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              Assets.signatureImage,
                                              // fit: BoxFit.fill,
                                              scale: 3,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // InkWell(
                            //   onTap: () {
                            //
                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color: MyColors.pink),
                            //     padding: const EdgeInsets.symmetric(
                            //         vertical: 15, horizontal: 35),
                            //     child: Text(
                            //       'Cancel',
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(
                            //           decoration: TextDecoration.none,
                            //           fontFamily: MyFont.myFont2,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 14,
                            //           color: MyColors.white),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 20,
                            // ),
                            InkWell(
                              onTap: () {
                                if (productList.isEmpty) {
                                  productList.clear();
                                  Get.showSnackbar(
                                    const GetSnackBar(
                                      margin: EdgeInsets.all(10),
                                      borderRadius: 10,
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.TOP,
                                      message: "Please select atleast one product",
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Get.toNamed(AppRoutes.bottomNavBar1);
                                } else {
                                  var taxTypeId = (customerCodeListModel
                                      .first.taxTypeId!.isNotEmpty)
                                      ? int.parse(customerCodeListModel
                                      .first.taxTypeId ??
                                      "")
                                      : 0;

                                  summeryScreenController.salesOrderListModel =
                                      SalesOrderListModel(
                                        salesOrderDetail: summeryScreenController
                                            .productService.productListItems
                                            .map((e) =>
                                            SalesOrderModel(
                                                orgId: orgId,
                                                tranNo: "",
                                                slNo: e.slNO,
                                                productCode: e.code,
                                                productName: e.name,
                                                boxCount: e.pcsPerCarton ?? 0,
                                                boxQty: e.ctCount!,
                                                pcsQty: e.lsCount!,
                                                qty: (e.ctCount! *
                                                    e.pcsPerCarton!).toInt() +
                                                    e.lsCount!,
                                                foc: int.parse(e.foc!),
                                                exchange: int.parse(e.exchange!),
                                                boxPrice: e.sellingBoxCost,
                                                price: e.sellingCost!,
                                                total: (e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!),
                                                itemDiscount: 0,
                                                itemDiscountPerc: 0,
                                                subTotal: (e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!),
                                                tax: (((e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!)) *
                                                    summeryScreenController
                                                        .taxpercentage
                                                        .toDouble() /
                                                    100),
                                                netTotal: (((e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!)) *
                                                    summeryScreenController
                                                        .taxpercentage
                                                        .toDouble() /
                                                    100) +
                                                    ((e.lsCount! *
                                                        e.sellingCost!) +
                                                        (e.ctCount! *
                                                            e.sellingBoxCost!)),
                                                fPrice: e.sellingCost,
                                                fBoxPrice: e.sellingBoxCost,
                                                fTotal: (e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!),
                                                fTax: (((e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!)) *
                                                    summeryScreenController
                                                        .taxpercentage
                                                        .toDouble() / 100),
                                                fNetTotal: (((e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!)) *
                                                    summeryScreenController
                                                        .taxpercentage
                                                        .toDouble() / 100) +
                                                    ((e.lsCount! *
                                                        e.sellingCost!) +
                                                        (e.ctCount! *
                                                            e.sellingBoxCost!)),
                                                createdBy:userName??"",
                                                createdOn: currentDate,
                                                changedBy:userName??"",
                                                changedOn: currentDate,
                                                stockQty: 0,
                                                stockBoxQty: 0,
                                                weight: 0,
                                                remarks: remark,
                                                taxPerc: e.taxPerc,
                                                fSubTotal: (e.lsCount! *
                                                    e.sellingCost!) +
                                                    (e.ctCount! *
                                                        e.sellingBoxCost!),
                                                fItemDiscount: 0,
                                                stockPcsQty: 0))
                                            .toList(),
                                        billDiscount: 0,
                                        orgId: orgId,
                                        tranNo: "",
                                        tranDate: currentDate,
                                        customerId: customerCodeListModel.first
                                            .code ??
                                            "",
                                        customerName: customerCodeListModel
                                            .first.name ??
                                            "",
                                        customerAddress: fullAddress,
                                        locationCode: companyBranch,
                                        taxCode: taxTypeId,
                                        taxType: summeryScreenController.tax,
                                        taxPerc: summeryScreenController
                                            .taxpercentage,
                                        currencyCode: customerCodeListModel
                                            .first.currencyId ??
                                            "SGD",
                                        currencyRate: 1,
                                        total: grandTotal,
                                        discount: 0,
                                        discountPerc: 0,
                                        subTotal: subtotal,
                                        tax: taxValue,
                                        netTotal: grandTotal,
                                        fTotal: grandTotal,
                                        fDiscount: 0,
                                        fSubTotal: subtotal,
                                        fTax: taxValue,
                                        fNetTotal: grandTotal,
                                        referenceNo: "",
                                        remarks: remark,
                                        createdFrom: "M",
                                        isActive: true,
                                        createdBy:userName??"",
                                        createdOn: currentDate,
                                        changedBy: userName??"",
                                        changedOn: currentDate,
                                        assignTo:userName??"",
                                        tranDateString: currentDate,
                                        status: 0,
                                        isUpdate: false,
                                        customerShipToId: 0,
                                        customerShipToAddress: currentAddress,
                                        priceSettingCode: "",
                                        termCode: "",
                                        invoiceType: true,
                                        latitude: _currentPosition?.latitude,
                                        longitude: _currentPosition?.longitude,
                                        signatureimage: customerSignature ?? "",
                                        cameraimage: pickedFile?.path ?? "",
                                        summaryRemarks: customerCodeListModel
                                            .first.remarks ?? "",
                                        addressLine1: customerCodeListModel
                                            .first.addressLine1 ??
                                            "",
                                      );
                                  summeryScreenController.salesOrderApi();
                                  productController.clearData();
                                  customerController.clearData();
                                  // print("||||||||||||||||||||||");
                                  // print(sign1!.customerSignatureExportedImage!);
                                  // print("||||||||||||||||||||||");
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: MyColors.pink),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40),
                                child: Text(
                                  'Save',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      );
    }
    );
  }

  listView() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: summeryScreenController.productService.productListItems
              .length,
          itemBuilder: (context, index) {
            ProductListModel currentItem =
            summeryScreenController.productService.productListItems[index];
            summaryListUnitPrice =
                currentItem.lsCount! * currentItem.sellingCost!;
            summaryListCartPrice =
                currentItem.ctCount! * currentItem.sellingBoxCost!;
            total = summaryListUnitPrice + summaryListCartPrice;
            print("currentItem.lsCount=================================");
            print(currentItem.lsCount);
            print("currentItem.lsCount=================================");

            return Container(
              // color: MyColors.greyText,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(0.3),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(0.2),
                    },
                    children: [
                      TableRow(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.code ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.name ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(child: const Icon(
                            Icons.clear,
                            size: 20,
                            color: MyColors.red,
                          ),
                            onTap: () {
                              if (index >= 0 && index <
                                  summeryScreenController.productService
                                      .productListItems.length) {
                                setState(() {
                                  summeryScreenController.productService
                                      .productListItems.removeAt(index);
                                });
                              }
                            },
                          ),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.ctCount.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.lsCount.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.qtCount.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                      ])
                    ],
                  ),
                  const SizedBox(height: 5),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.sellingBoxCost?.toStringAsFixed(2) ??
                                "0.00",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentItem.sellingCost?.toStringAsFixed(2) ??
                                "0.00",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            total.toStringAsFixed(2) ?? "0.00",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFont.myFont2),
                          ),
                        ),
                      ])
                    ],
                  ),
                  const Divider()
                ],
              ),
            );
          }),
    );
  }

  // listView() {
  //   return SizedBox(
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: productList.length,
  //         itemBuilder: (context, index) {
  //           ProductListModel currentItem = productList[index];
  //           print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  //           print(currentItem.lsCount);
  //           print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  //
  //           summaryListUnitPrice =
  //               currentItem.lsCount! * currentItem.sellingCost!;
  //           summaryListCartPrice =
  //               currentItem.ctCount! * currentItem.sellingBoxCost!;
  //
  //           total = summaryListUnitPrice + summaryListCartPrice;
  //           print("currentItem.lsCount=================================");
  //           print(currentItem.lsCount);
  //           print("currentItem.lsCount=================================");
  //
  //           return Container(
  //             color: Colors.white,
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(0.3),
  //                     1: FlexColumnWidth(),
  //                     2: FlexColumnWidth(0.2),
  //                   },
  //                   children: [
  //                     TableRow(children: [
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.code ?? "",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.name ?? "",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: IconButton(
  //                           icon: const Icon(
  //                             Icons.clear,
  //                             size: 20,
  //                             color: MyColors.red,
  //                           ),
  //                           onPressed: () {
  //
  //                               summeryScreenController
  //                                   .productService.productListItems
  //                                   .removeAt(index);
  //                               productController.clearData();
  //
  //                           },
  //                         ),
  //                       ),
  //                     ]),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(),
  //                     1: FlexColumnWidth(),
  //                     2: FlexColumnWidth(),
  //                   },
  //                   children: [
  //                     TableRow(children: [
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.ctCount.toString(),
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.lsCount.toString(),
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.qtCount.toString(),
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                     ])
  //                   ],
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Table(
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(),
  //                     1: FlexColumnWidth(),
  //                     2: FlexColumnWidth(),
  //                   },
  //                   children: [
  //                     TableRow(children: [
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.sellingBoxCost?.toStringAsFixed(2) ??
  //                               "0.00",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           currentItem.sellingCost?.toStringAsFixed(2) ??
  //                               "0.00",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           total.toStringAsFixed(2) ?? "0.00",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: MyFont.myFont2),
  //                         ),
  //                       ),
  //                     ])
  //                   ],
  //                 ),
  //                 const Divider()
  //               ],
  //             ),
  //           );
  //         }),
  //   );
  // }

  // productDetailsList() {
  //   return ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: productList.length,
  //       itemBuilder: (context, index) {
  //         ProductListModel _currentItem = productList[index];
  //         // unittotal =
  //         //     productList[index].lsCount * productList[index].sellingCost!;
  //         // boxtotal =
  //         //     productList[index].ctCount * productList[index].sellingBoxCost!;
  //         //
  //         // total = unittotal + boxtotal;
  //
  //         return Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 2,
  //                 blurRadius: 5,
  //                 offset: const Offset(0, 3),
  //               ),
  //             ],
  //           ),
  //           margin: const EdgeInsets.only(
  //             top: 10,
  //             left: 15,
  //             right: 15,
  //           ),
  //           padding: const EdgeInsets.all(15),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       SizedBox(
  //                         width: width(context) / 4,
  //                         child: Text(
  //                           "Product Name",
  //                           style: TextStyle(
  //                               decoration: TextDecoration.none,
  //                               fontFamily: MyFont.myFont,
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 12,
  //                               letterSpacing: 0.5,
  //                               color: MyColors.mainTheme),
  //                         ),
  //                       ),
  //                       Text(
  //                         " : ",
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 12,
  //                             letterSpacing: 0.5,
  //                             color: MyColors.black),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     width: width(context) / 2,
  //                     child: Text(
  //                       _currentItem.name ?? "",
  //                       style: TextStyle(
  //                           decoration: TextDecoration.none,
  //                           fontFamily: MyFont.myFont,
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 12,
  //                           letterSpacing: 0.5,
  //                           color: MyColors.black),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             child: Text(
  //                               "Product Code",
  //                               style: TextStyle(
  //                                   decoration: TextDecoration.none,
  //                                   fontFamily: MyFont.myFont,
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 12,
  //                                   letterSpacing: 0.5,
  //                                   color: MyColors.mainTheme),
  //                             ),
  //                           ),
  //                           Text(
  //                             " : ",
  //                             style: TextStyle(
  //                                 decoration: TextDecoration.none,
  //                                 fontFamily: MyFont.myFont,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 12,
  //                                 letterSpacing: 0.5,
  //                                 color: MyColors.black),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         child: Text(
  //                           _currentItem.code ?? "",
  //                           style: TextStyle(
  //                               decoration: TextDecoration.none,
  //                               fontFamily: MyFont.myFont,
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 12,
  //                               letterSpacing: 0.5,
  //                               color: MyColors.black),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           SizedBox(
  //                             child: Text(
  //                               "S.No",
  //                               style: TextStyle(
  //                                   decoration: TextDecoration.none,
  //                                   fontFamily: MyFont.myFont,
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 12,
  //                                   letterSpacing: 0.5,
  //                                   color: MyColors.mainTheme),
  //                             ),
  //                           ),
  //                           Text(
  //                             " : ",
  //                             style: TextStyle(
  //                                 decoration: TextDecoration.none,
  //                                 fontFamily: MyFont.myFont,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 12,
  //                                 letterSpacing: 0.5,
  //                                 color: MyColors.black),
  //                           ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         child: Text(
  //                           "${index += 1}",
  //                           style: TextStyle(
  //                               decoration: TextDecoration.none,
  //                               fontFamily: MyFont.myFont,
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 12,
  //                               letterSpacing: 0.5,
  //                               color: MyColors.black),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //                 decoration: const BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(5),
  //                         topRight: Radius.circular(5)),
  //                     color: MyColors.mainTheme),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         "CQty",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         "LQty",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         "Qty",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         "Foc",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.white),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 7,
  //                       child: Text(
  //                         "Exchange",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.white),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  //                 decoration: const BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                         bottomLeft: Radius.circular(5),
  //                         bottomRight: Radius.circular(5)),
  //                     color: MyColors.greyIcon),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         _currentItem.cartOnCount ?? "0",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.black),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         _currentItem.looseCount ?? "0",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.black),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         _currentItem.quantity ?? "0",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.black),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 10,
  //                       child: Text(
  //                         _currentItem.foc ?? "0",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.black),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       width: width(context) / 7,
  //                       child: Text(
  //                         _currentItem.exchange ?? "0",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             decoration: TextDecoration.none,
  //                             fontFamily: MyFont.myFont,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 10,
  //                             color: MyColors.black),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

  _showDialogToGetImage(BuildContext context) {
    Widget cameraButton = InkWell(
      onTap: () {
        _getImage(true);
        Navigator.of(context).pop();
      },
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: Icon(Icons.camera_alt_outlined, size: 40),
      ),
    );

    Widget Clear = InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const Icon(Icons.clear_rounded),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text("Click Image"), Clear],
        ),
      ),
      content: cameraButton,
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _getImage(bool isCamera) async {
    final picker = ImagePicker();
    pickedFile = await picker.pickImage(
        imageQuality: Platform.isAndroid ? 40 : 30,
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {

      });
    } else {
      debugPrint('No image selected.');
    }
  }

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      getAddressFromLatLng();
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        currentAddress =
        "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place
            .subLocality}";
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void locationPermission() async {
    PermissionStatus locationStatus = await Permission.location.request();

    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (locationStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('location Permission');
      }
      // showPlacePicker();
      getCurrentLocation();
      if (_currentPosition != null) {
        Text(currentAddress, style: const TextStyle(fontSize: 20.0));
      } else {
        const Text("Couldn't fetch the location");
      }
    }

    if (locationStatus == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Permission Required'),
      ));
    }
    if (locationStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }


  getUserData() async {
    await PreferenceHelper.getUserData().then((value) {
      customerId = value?.userRolecode;
      userName = value?.name;

      emailId = value?.mail;
      postalCode = value?.postalCode;
      address = "${value?.addressLine1}"
          ","
          "${value?.addressLine2}"
          ","
          "${value?.addressLine3}";
      countryId = value?.country;
      countryId = value?.country;
      orgId = value?.orgId;
    });
    companyBranch = await PreferenceHelper.getBranchCodeString();
    print(companyBranch);
    print("companyBranch__________________________________");
    // companyBranch = await PreferenceHelper.getBanchNameString();
    // print(companyBranch);
    // print("companyBranch__________________________________");
  }

  void _getTapPosition(LongPressDownDetails tapPosition) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(tapPosition
          .globalPosition); // store the tap positon in offset variable
      print(_tapPosition);
    });
  }

  void _showContextMenu(BuildContext context, index,
      ProductListModel productList) async {
    final RenderObject? overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject();

    return showMenu(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 2, color: MyColors.lightmainTheme)),
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          PopupMenuItem(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAndToNamed(
                          AppRoutes.bottomNavBar1, arguments: productList.code);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            IconAssets.editIcon,
                            color: MyColors.pink, scale: 1.3,
                          ),
                          SizedBox(
                            width: width(context) / 30,
                          ),
                          Text(
                            'Edit',
                            style: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: MyColors.mainTheme),
                          ),
                        ]),
                  ),
                ],
              )),
          PopupMenuItem(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      summeryScreenController
                          .productService.productListItems
                          .removeAt(index);
                      FocusScope.of(context).unfocus();
                      productController.clearData();
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            IconAssets.editIcon,
                            color: MyColors.pink, scale: 1.3,
                          ),
                          SizedBox(
                            width: width(context) / 30,
                          ),
                          Text(
                            'Remove',
                            style: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: MyColors.mainTheme),
                          ),
                        ]),
                  ),
                ],
              )),
        ]);
  }

}


