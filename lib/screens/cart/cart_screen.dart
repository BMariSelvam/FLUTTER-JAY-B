import 'dart:convert';
import 'dart:io';

import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:JNB/Model/sales_order/sales_order_model.dart';
import 'package:JNB/screens/cart/cart_screen_controller.dart';
import 'package:JNB/screens/signature/signature_screen.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:JNB/widgets/search_dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CarScreenController carScreenController;
  double total = 0;
  var summaryListUnitPrice;
  var summaryListCartPrice;
  List<ProductListModel> productList = [];
  XFile? pickedFile;
  String currentAddress = "";
  SignatureCImage? sign1;

  final geoLocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? _currentPosition;
  double taxValue = 0;
  double boxtotal = 0;
  double unittotal = 0;
  double subtotal = 0;
  double taxPerc = 0;
  double grandTotal = 0;
  double totalcount = 0;
  String currentDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
  String? customerSignature;
  String? userSignature;
  var fullAddress;

  @override
  void initState() {
    super.initState();
    getUserData();
    locationPermission(context);
    carScreenController = Get.put(CarScreenController());
    carScreenController.getOrderCustomerList("");
    productList = carScreenController.productService.productListItems;
    carScreenController.productService.productListChangeStream.listen((_) {
      setState(() {});
    });
    if (carScreenController.customerCodeListModel.value?.first.taxTypeId !=
        null) {
      if(carScreenController.customerCodeListModel.value!.first.taxTypeId!.isNotEmpty){
        carScreenController
            .getTaxDetails(carScreenController
            .customerCodeListModel.value?.first.taxTypeId ??
            "")
            .then((value) {
          setState(() {});
        });
      }else {
        carScreenController.taxpercentage = 7;
        carScreenController.taxName = "I";
        // summeryScreenController.taxName = "Inclusive";
      }
    }else {
      carScreenController.taxpercentage = 7;
      carScreenController.taxName = "I";
      // summeryScreenController.taxName = "Inclusive";
    }
    fullAddress =
    "${carScreenController.customerCodeListModel.value?.first.addressLine1 ?? ""}"
        ","
        "${carScreenController.customerCodeListModel.value?.first.addressLine2 ?? ""}"
        ","
        "${carScreenController.customerCodeListModel.value?.first.addressLine3 ?? ""}";

  }

  String? name;
  int? org;
  String? branchName = "";
  String search = "";
  List<ProductListModel> filterList(String query) {
    return carScreenController.productService.productListItems.where((item) {
      return item.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
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
      taxValue = (subtotal * carScreenController.taxpercentage) / 100;
      if (carScreenController.taxName == "I") {
        grandTotal = subtotal;
      } else if (carScreenController.taxName == "E") {
        grandTotal = subtotal + taxValue;
      } else if (carScreenController.taxName == "Z") {
        grandTotal = subtotal + taxValue;
      } else {
        grandTotal = subtotal + taxValue;
      }
    }

    return GetBuilder<CarScreenController>(builder: (logic) {
      if (logic.status.isLoading == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return WillPopScope(
        onWillPop: () async {
          // final shouldPop = await showDialog<bool>(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: const Text('Do you want to go Catalogue?'),
          //       actionsAlignment: MainAxisAlignment.spaceAround,
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //               Get.offAndToNamed(AppRoutes.catalogueScreen);
          //           },
          //           child: const Text('Yes'),
          //         ),
          //         TextButton(
          //           onPressed: () {
          //             setState(() {
          //               Navigator.pop(context);
          //               // Get.offAndToNamed(AppRoutes.bottomNavBar0);
          //             });
          //           },
          //           child: const Text('No'),
          //         ),
          //       ],
          //     );
          //   },
          // );
          // return shouldPop!;
          return true;
        },
        child: Scaffold(
            drawer: getDrawer(context, name, branchName),
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Obx(
                  () {
                    return SearchDropdownTextField<CustomerListModel>(
                      hintText: 'Select Customer',
                      hintTextStyle: TextStyle(
                        fontFamily: MyFont.myFont2,
                        color: MyColors.greyText,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textStyle: TextStyle(
                        fontFamily: MyFont.myFont2,
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                        fontSize: 13,
                      ),
                      // prefixIcon: const Icon(
                      //   Icons.search,
                      //   color: MyColors.pink,
                      // ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            carScreenController.clearData();
                          });
                        },
                        child: const Icon(
                          Icons.clear,
                          color: MyColors.pink,
                        ),
                      ),
                      inputBorder: BorderSide.none,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      items: carScreenController.customerListModel.value,
                      color: Colors.black54,
                      selectedItem: carScreenController.customer ??
                          carScreenController.customerCodeListModel.value?.first,
                      isValidator: true,
                      errorMessage: '*',
                      onAddPressed: (value) {
                        setState(() {
                          carScreenController.CustomerName = "";
                          carScreenController.customer = value;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          carScreenController.customer = value;
                          carScreenController.CustomerName = value.name;
                        });
                        setState(
                          () {
                            carScreenController.customerCode = "${value.code}";
                            carScreenController.getCustomersByCodeList(
                                carScreenController.customerCode);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              centerTitle: true,
              toolbarHeight: 100,
              elevation: 0,
              backgroundColor: MyColors.mainTheme,
              flexibleSpace: Container(),
              leading: GestureDetector(
                onTap: () {
                 Navigator.pop(context);
                  // carScreenController.scaffoldKey.currentState?.openDrawer();
                },
                child:const Icon(Icons.arrow_back_ios_rounded,color: MyColors.white,),
                // Image.asset(
                //   Assets.icon1,
                //   scale: 1,
                // ),
              ),
              title: Text('Cart',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFont.myFont2,
                      color: MyColors.white)),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap:() {
                      if (carScreenController.customer != null) {
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
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          var taxTypeId = (carScreenController.customerCodeListModel
                              .value!.first.taxTypeId!.isNotEmpty)
                              ? int.parse(carScreenController.customerCodeListModel
                              .value?.first.taxTypeId ??
                              "")
                              : 0;
                          carScreenController.salesOrderListModel =
                              SalesOrderListModel(
                                salesOrderDetail: carScreenController
                                    .productService.productListItems
                                    .map((e) => SalesOrderModel(
                                    orgId: org,
                                    tranNo: "",
                                    slNo: e.slNO,
                                    productCode: e.code,
                                    productName: e.name,
                                    boxCount: e.pcsPerCarton ?? 0,
                                    pcsQty: e.lsCount!,
                                    qty: (e.ctCount! * e.pcsPerCarton!).toInt() + e.lsCount!,

                                    foc: 0,
                                    exchange: 0,
                                    boxPrice: e.sellingBoxCost,
                                    price: e.sellingCost!,
                                    total: (e.lsCount! * e.sellingCost!) +
                                        (e.ctCount! * e.sellingBoxCost!),
                                    itemDiscount: 0,
                                    itemDiscountPerc: 0,
                                    subTotal: (e.lsCount! * e.sellingCost!) +
                                        (e.ctCount! * e.sellingBoxCost!),
                                    tax: (((e.lsCount! * e.sellingCost!) +
                                        (e.ctCount! * e.sellingBoxCost!)) *
                                        carScreenController.taxpercentage
                                            .toDouble() /
                                        100),
                                    netTotal: (((e.lsCount! * e.sellingCost!) +
                                        (e.ctCount! * e.sellingBoxCost!)) *
                                        carScreenController.taxpercentage
                                            .toDouble() /
                                        100) +
                                        ((e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)),
                                    fPrice: e.sellingCost,
                                    fBoxPrice: e.sellingBoxCost,
                                    fTotal: (e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!),
                                    fTax: (((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)) * carScreenController.taxpercentage.toDouble() / 100),
                                    fNetTotal: (((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)) * carScreenController.taxpercentage.toDouble() / 100) + ((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)),
                                    createdBy: "admin",
                                    createdOn: currentDate,
                                    changedBy: "admin",
                                    changedOn: currentDate,
                                    stockQty: 0,
                                    stockBoxQty: 0,
                                    weight: 0,
                                    remarks:carScreenController
                                        .customerCodeListModel.value?.first.remarks??"",
                                    boxQty: (e.ctCount! * e.pcsPerCarton!).toInt(),
                                    taxPerc: e.taxPerc,
                                    fSubTotal: (e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!),
                                    fItemDiscount: 0,
                                    stockPcsQty: 0))
                                    .toList(),
                                billDiscount: 0,
                                orgId: org,
                                tranNo: "",
                                tranDate: currentDate,
                                customerId: carScreenController
                                    .customerCodeListModel.value?.first.code ??
                                    "",
                                customerName: carScreenController
                                    .customerCodeListModel.value?.first.name ??
                                    "",
                                customerAddress: fullAddress,
                                locationCode: branchName,
                                taxCode: taxTypeId,
                                taxType: carScreenController.tax,
                                taxPerc: carScreenController.taxpercentage,
                                currencyCode: carScreenController
                                    .customerCodeListModel.value?.first.currencyId ??
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
                                remarks: "",
                                createdFrom: "M",
                                isActive: true,
                                createdBy: "admin",
                                createdOn: currentDate,
                                changedBy: "admin",
                                changedOn: currentDate,
                                assignTo: "admin",
                                tranDateString: currentDate,
                                status: 0,
                                isUpdate: false,
                                customerShipToId: 0,
                                customerShipToAddress: fullAddress,
                                priceSettingCode: "",
                                termCode: "",
                                invoiceType: true,
                                latitude: _currentPosition?.latitude,
                                longitude: _currentPosition?.longitude,
                                signatureimage: customerSignature,
                                cameraimage: pickedFile?.path ?? "",
                                summaryRemarks:carScreenController
                                    .customerCodeListModel.value?.first.remarks??"",
                                addressLine1: carScreenController.customerCodeListModel
                                    .value?.first.addressLine1 ??
                                    "",
                              );
                          carScreenController.salesOrderApi();
                        }
                      } else {
                        Get.showSnackbar(
                          const GetSnackBar(
                            margin: EdgeInsets.all(10),
                            borderRadius: 10,
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.TOP,
                            message: "Please select Customer",
                            icon: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );

                      }
                    },
                    child: const Icon(Icons.save, color: MyColors.white),
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
                            'SubTotal',
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: MyColors.lightmainTheme,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                  border: Border.all(color: MyColors.greyText),
                                  borderRadius: BorderRadius.circular(20),
                                  color: MyColors.white),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            decoration: TextDecoration.none,
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
                                setState(() {
                                  _getImage(true);
                                });
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
                                    border: Border.all(color: MyColors.greyText),
                                    borderRadius: BorderRadius.circular(20),
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
                                      builder: (context) =>
                                          const SignatureScreen(),
                                    )).then((value) {
                                  setState(() {
                                    sign1 = value as SignatureCImage;
                                    Uint8List customerSignatureUint8List =
                                        Uint8List.fromList(sign1!
                                            .customerSignatureExportedImage!);
                                    customerSignature =
                                        base64Encode(customerSignatureUint8List);
                                    Uint8List userSignatureUint8List =
                                        Uint8List.fromList(
                                            sign1!.userSignatureExportedImage!);
                                    userSignature =
                                        base64Encode(userSignatureUint8List);
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
                                      border:
                                          Border.all(color: MyColors.greyText),
                                      borderRadius: BorderRadius.circular(20),
                                      color: MyColors.white),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 05, horizontal: 20),
                                  child: (sign1?.userSignatureExportedImage !=
                                              null &&
                                          sign1?.customerSignatureExportedImage !=
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
                      InkWell(
                        onTap: () {
                          if (carScreenController.customer != null) {

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
                                  duration: Duration(seconds: 1),
                                ),
                              );

                            } else {
                              var taxTypeId = (carScreenController.customerCodeListModel
                                  .value!.first.taxTypeId!.isNotEmpty)
                                  ? int.parse(carScreenController.customerCodeListModel
                                  .value?.first.taxTypeId ??
                                  "")
                                  : 0;
                              carScreenController.salesOrderListModel =
                                  SalesOrderListModel(
                                    salesOrderDetail: carScreenController
                                        .productService.productListItems
                                        .map((e) => SalesOrderModel(
                                        orgId: org,
                                        tranNo: "",
                                        slNo: e.slNO,
                                        productCode: e.code,
                                        productName: e.name,
                                        boxCount: e.pcsPerCarton ?? 0,
                                        pcsQty: e.lsCount!,
                                        qty: (e.ctCount! * e.pcsPerCarton!).toInt() + e.lsCount!,

                                        foc: 0,
                                        exchange: 0,
                                        boxPrice: e.sellingBoxCost,
                                        price: e.sellingCost!,
                                        total: (e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        itemDiscount: 0,
                                        itemDiscountPerc: 0,
                                        subTotal: (e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!),
                                        tax: (((e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            carScreenController.taxpercentage
                                                .toDouble() /
                                            100),
                                        netTotal: (((e.lsCount! * e.sellingCost!) +
                                            (e.ctCount! * e.sellingBoxCost!)) *
                                            carScreenController.taxpercentage
                                                .toDouble() /
                                            100) +
                                            ((e.lsCount! * e.sellingCost!) +
                                                (e.ctCount! * e.sellingBoxCost!)),
                                        fPrice: e.sellingCost,
                                        fBoxPrice: e.sellingBoxCost,
                                        fTotal: (e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!),
                                        fTax: (((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)) * carScreenController.taxpercentage.toDouble() / 100),
                                        fNetTotal: (((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)) * carScreenController.taxpercentage.toDouble() / 100) + ((e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!)),
                                        createdBy: "admin",
                                        createdOn: currentDate,
                                        changedBy: "admin",
                                        changedOn: currentDate,
                                        stockQty: 0,
                                        stockBoxQty: 0,
                                        weight: 0,
                                        remarks:carScreenController
                                            .customerCodeListModel.value?.first.remarks??"",
                                        boxQty: (e.ctCount! * e.pcsPerCarton!).toInt(),
                                        taxPerc: e.taxPerc,
                                        fSubTotal: (e.lsCount! * e.sellingCost!) + (e.ctCount! * e.sellingBoxCost!),
                                        fItemDiscount: 0,
                                        stockPcsQty: 0))
                                        .toList(),
                                    billDiscount: 0,
                                    orgId: org,
                                    tranNo: "",
                                    tranDate: currentDate,
                                    customerId: carScreenController
                                        .customerCodeListModel.value?.first.code ??
                                        "",
                                    customerName: carScreenController
                                        .customerCodeListModel.value?.first.name ??
                                        "",
                                    customerAddress: fullAddress,
                                    locationCode: branchName,
                                    taxCode: taxTypeId,
                                    taxType: carScreenController.tax,
                                    taxPerc: carScreenController.taxpercentage,
                                    currencyCode: carScreenController
                                        .customerCodeListModel.value?.first.currencyId ??
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
                                    remarks: "",
                                    createdFrom: "M",
                                    isActive: true,
                                    createdBy: "admin",
                                    createdOn: currentDate,
                                    changedBy: "admin",
                                    changedOn: currentDate,
                                    assignTo: "admin",
                                    tranDateString: currentDate,
                                    status: 0,
                                    isUpdate: false,
                                    customerShipToId: 0,
                                    customerShipToAddress: fullAddress,
                                    priceSettingCode: "",
                                    termCode: "",
                                    invoiceType: true,
                                    latitude: _currentPosition?.latitude,
                                    longitude: _currentPosition?.longitude,
                                    signatureimage: customerSignature,
                                    cameraimage: pickedFile?.path ?? "",
                                    summaryRemarks:carScreenController
                                        .customerCodeListModel.value?.first.remarks??"",
                                    addressLine1: carScreenController.customerCodeListModel
                                        .value?.first.addressLine1 ??
                                        "",
                                  );
                              carScreenController.salesOrderApi();
                            }
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please select Customer",
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );

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
            )),
      );
    });
  }

  listView() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: carScreenController.productService.productListItems.length,
          itemBuilder: (context, index) {
            ProductListModel currentItem =
                carScreenController.productService.productListItems[index];
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
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 20,
                              color: MyColors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                carScreenController
                                    .productService.productListItems
                                    .removeAt(index);
                              });
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
                            total.toStringAsFixed(2),
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
      setState(() {});
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
        "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void locationPermission(context) async {
    PermissionStatus locationStatus = await Permission.location.request();

    if (locationStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('location Permission');
      }
      // showPlacePicker();
      getCurrentLocation();
      if (_currentPosition != null) {
        Text(currentAddress, style: const TextStyle(fontSize: 20.0));
      } else {
        const Text("Could'nt fetch the location");
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
    await PreferenceHelper.getUserData().then((value) => setState(() {
          name = value?.name;
          org = value?.orgId;
        }));
    branchName = await PreferenceHelper.getBranchCodeString();
  }


}
