import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Custom_widgets/custom_textField_1.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Helper/valitation.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_customer/sales_order_create_customer_controller.dart';
import 'package:JNB/widgets/search_dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Const/app_route.dart';
import 'sales_order_create_Product_controller.dart';

class SalesOrderProductScreen extends StatefulWidget {
  const SalesOrderProductScreen({super.key});

  @override
  State<SalesOrderProductScreen> createState() =>
      _SalesOrderProductScreenState();
}

class _SalesOrderProductScreenState extends State<SalesOrderProductScreen> {
  //   with AutomaticKeepAliveClientMixin<SalesOrderProductScreen> {
  //
  // @override
  // bool get wantKeepAlive => true;
  late SalesOrderCreateProductController salesOrderCreateProductController;
  late SalesOrderCreateCustomerController salesOrderCreateCustomerController;

  int? ls;
  int? cc;
  int? qty;

  @override
  void initState() {
    super.initState();
    salesOrderCreateProductController =
        Get.put(SalesOrderCreateProductController());

    salesOrderCreateProductController.getOrderProductList();
    salesOrderCreateCustomerController =
        Get.find<SalesOrderCreateCustomerController>();

    salesOrderCreateProductController.clearData();
    salesOrderCreateProductController.productService.productListChangeStream
        .listen((_) {});
    if (salesOrderCreateProductController.cartonCountController.text == "" &&
        salesOrderCreateProductController.cartonCountController.text == null) {
      salesOrderCreateProductController.cartonCountController.text = "0";
    }
    if (salesOrderCreateProductController.looseCountController.text == "" &&
        salesOrderCreateProductController.looseCountController.text == null) {
      salesOrderCreateProductController.looseCountController.text = "0";
    }
    if (salesOrderCreateProductController.qtyCountController.text == "" &&
        salesOrderCreateProductController.qtyCountController.text == null) {
      salesOrderCreateProductController.qtyCountController.text = "0";
    }
    if (salesOrderCreateProductController.exchangeController.text == "" &&
        salesOrderCreateProductController.exchangeController.text == null) {
      salesOrderCreateProductController.exchangeController.text = "0";
    }
    if (salesOrderCreateProductController.focController.text == "" &&
        salesOrderCreateProductController.focController.text == null) {
      salesOrderCreateProductController.focController.text = "0";
    }
  }

  firstUnitCalculation(String value) {
    if (value == "") {
      value = "0";
    }
    double unitQty = double.parse(value);
    print("UnitQty====$unitQty");
    if (salesOrderCreateProductController.cartonCountController.text != "" &&
        salesOrderCreateProductController.cartonCountController.text != "0") {
      double countOfPcsPerCarton =
          double.parse(salesOrderCreateProductController.pcsController.text);
      double cartonQty = double.parse(
          salesOrderCreateProductController.cartonCountController.text);

      ///TotalCartonQty
      double totalCartonQty = countOfPcsPerCarton * cartonQty;
      print("TotalCartonQty>>>>>>>>>>>>>>$totalCartonQty");

      ///TotalQuantity
      double totalQty = unitQty + totalCartonQty;
      salesOrderCreateProductController.qtyCountController.text =
          totalQty.toStringAsFixed(0);
    } else {
      print("value=======$value");

      salesOrderCreateProductController.qtyCountController.text =
          unitQty.toStringAsFixed(0);
    }
  }

  firstCartonCalculation(String value) {
    print("value2====FirstCartonCalculation=======$value");

    if (value == "") {
      print("123456qwertyuio7890");
      value = "0";
    }
    double cartonQty = double.parse(value);
    if (salesOrderCreateProductController.looseCountController.text != "" &&
        salesOrderCreateProductController.looseCountController.text != "0") {
      print("value3===========$value");

      double countOfPcsPerCarton =
          double.parse(salesOrderCreateProductController.pcsController.text);
      double unitQty = double.parse(
          salesOrderCreateProductController.looseCountController.text);
      if (salesOrderCreateProductController.cartonCountController.text != "0") {
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        double cartQty = double.parse(
            salesOrderCreateProductController.cartonCountController.text);
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$cartQty");

        ///TotalCartonQty
        double totalCartonQty = countOfPcsPerCarton * cartQty;
        print("TotalCartonQty>>>>>>>>>>>>>>$totalCartonQty");

        ///TotalQuantity
        double totalQty = unitQty + totalCartonQty;
        salesOrderCreateProductController.qtyCountController.text =
            totalQty.toStringAsFixed(0);
      } else {
        double totalQty = unitQty;
        salesOrderCreateProductController.qtyCountController.text =
            totalQty.toStringAsFixed(0);
      }
    } else {
      print("value4===========$value");

      double countOfPcsPerCarton =
          double.parse(salesOrderCreateProductController.pcsController.text);
      double totalCartonQty = cartonQty * countOfPcsPerCarton;

      salesOrderCreateProductController.qtyCountController.text =
          totalCartonQty.toStringAsFixed(0);
    }
  }

  reverseCalculation(String value) {
    print(value);

    if (value == "") {
      value = "0";
    }
    double qty = double.parse(value);
    double countOfPcsPerCarton =
        double.parse(salesOrderCreateProductController.pcsController.text);
    if (countOfPcsPerCarton != 1) {
      double oneCartonQty =
          double.parse(salesOrderCreateProductController.pcsController.text);
      double boxSplit = (qty / oneCartonQty);
      if (oneCartonQty <= qty) {
        int roundedValue = boxSplit.toInt();
        salesOrderCreateProductController.cartonCountController.text =
            roundedValue.toStringAsFixed(0);
        double splitUnit = qty % oneCartonQty;
        salesOrderCreateProductController.looseCountController.text =
            splitUnit.toStringAsFixed(0);
      } else {
        double splitUnit = qty % oneCartonQty;
        salesOrderCreateProductController.looseCountController.text =
            splitUnit.toStringAsFixed(0);
        salesOrderCreateProductController.cartonCountController.text = '';
      }
    }
  }

  totalFun() {
    double? cartonPrice =
        salesOrderCreateProductController.productList?.sellingBoxCost;
    double? unitPrice =
        salesOrderCreateProductController.productList?.sellingCost;
    int cartonQty = int.tryParse(
            salesOrderCreateProductController.cartonCountController.text) ??
        0;
    int unitQty = int.tryParse(
            salesOrderCreateProductController.looseCountController.text) ??
        0;

    if (salesOrderCreateProductController.looseCountController.text == "") {
      salesOrderCreateProductController.subTotal = cartonQty * cartonPrice!;
      salesOrderCreateProductController.tax =
          salesOrderCreateProductController.subTotal *
              double.parse(salesOrderCreateProductController
                  .productListCodeModel.value!.first.taxPerc
                  .toString()) /
              100;

      salesOrderCreateProductController.netTotal =
          salesOrderCreateProductController.subTotal +
              salesOrderCreateProductController.tax;
    } else if (salesOrderCreateProductController.cartonCountController.text ==
        "") {
      salesOrderCreateProductController.subTotal = unitQty * unitPrice!;
      salesOrderCreateProductController.tax =
          salesOrderCreateProductController.subTotal *
              double.parse(salesOrderCreateProductController
                  .productListCodeModel.value!.first.taxPerc
                  .toString()) /
              100;

      salesOrderCreateProductController.netTotal =
          salesOrderCreateProductController.subTotal +
              salesOrderCreateProductController.tax;
    } else {
      salesOrderCreateProductController.subTotal =
          (cartonQty * cartonPrice!) + (unitQty * unitPrice!);
      salesOrderCreateProductController.tax =
          salesOrderCreateProductController.subTotal *
              double.parse(salesOrderCreateProductController
                  .productListCodeModel.value!.first.taxPerc
                  .toString()) /
              100;

      salesOrderCreateProductController.netTotal =
          salesOrderCreateProductController.subTotal +
              salesOrderCreateProductController.tax;
    }
    // print(
    //     "cartonCountController...............${controller.cartonCountController.text}");
    // // Ensure non-negative quantities
    // cartonQty = cartonQty < 0 ? 0 : cartonQty;
    // unitQty = unitQty < 0 ? 0 : unitQty;
    // totalPrice = cartonQty.toDouble();
  }

  void updateTotal() {
    setState(() {
      totalFun();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesOrderCreateProductController>(builder: (logic) {
      if (logic.status.isLoading == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 15,
                          left: 15,
                        ),
                        child: Text(
                          "Product Information",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.5,
                              color: MyColors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  onTap();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: MyColors.pink,
                                    borderRadius: BorderRadius.circular(
                                        50), // Button border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                        fontFamily: MyFont.myFont2,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: MyColors.mainTheme,
          shadowColor: Colors.grey,
          leading: GestureDetector(
            onTap: () {
              // Get.offAndToNamed(AppRoutes.bottomNavBar);
              showDialog<bool>(
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
                          setState(() {
                            // Navigator.pop(context, true);
                            Get.toNamed(AppRoutes.salesOrderScreen);

                            salesOrderCreateProductController.clearData();
                            salesOrderCreateCustomerController.clearData();
                            salesOrderCreateProductController.productService
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
                },
              );
            },
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     size: 18,
          //     color: MyColors.white,
          //   ),
          //   onPressed: () {
          //     Get.back();
          //   },
          // ),
          titleTextStyle: TextStyle(
              fontFamily: MyFont.myFont2,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.white),
          title: const Text(
            'Product',
          ),
        ),
        backgroundColor: MyColors.white,
        body: WillPopScope(
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
                        salesOrderCreateProductController.clearData();
                        salesOrderCreateCustomerController.clearData();
                        salesOrderCreateProductController.productService
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height(context) / 80,
                      ),
                      Obx(
                        () {
                          return SearchDropdownTextField<ProductListModel>(
                            hintText: 'Select Product',
                            hintTextStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                color: MyColors.greyText,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                            textStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.bold,
                                color: MyColors.black,
                                fontSize: 13),
                            // prefixIcon: const Icon(
                            //   Icons.search,
                            //   color: MyColors.pink,
                            // ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  salesOrderCreateProductController.clearData();
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
                            items: salesOrderCreateProductController
                                .productListModel.value,
                            color: Colors.black54,
                            selectedItem:
                                salesOrderCreateProductController.productList ??
                                    salesOrderCreateProductController
                                        .productListCodeModel.value?.first,
                            isValidator: false,
                            onAddPressed: (value) {
                              setState(() {
                                salesOrderCreateProductController.productName =
                                    "";
                                salesOrderCreateProductController.productList =
                                    value;
                              });
                            },
                            onChanged: (value) {
                              FocusScope.of(context).unfocus();
                              salesOrderCreateProductController.value = value;
                              salesOrderCreateProductController.productList =
                                  value;

                              salesOrderCreateProductController.productName =
                                  value.name;

                              setState(
                                () {
                                  salesOrderCreateProductController
                                      .productCodeController
                                      .text = "${value.code}";
                                  salesOrderCreateProductController
                                      .getOrderProductCodeList(
                                          salesOrderCreateProductController
                                              .productCodeController.text);
                                  salesOrderCreateProductController
                                      .cartonCountController
                                      .clear();
                                  salesOrderCreateProductController
                                      .looseCountController
                                      .clear();
                                  salesOrderCreateProductController
                                      .qtyCountController
                                      .clear();
                                  salesOrderCreateProductController
                                      .focController
                                      .clear();
                                  salesOrderCreateProductController
                                      .exchangeController
                                      .clear();
                                },
                              );
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 8,
                          bottom: 8,
                        ),
                        child: CustomTextFormField(
                          inputFormatters: [NumericInputFormatter()],
                          filled: true,
                          obscureText: false,
                          keyboardInput: TextInputType.number,
                          controller: salesOrderCreateProductController
                              .productNameController,
                          hintText: "Product Name",
                          labelText: "Product Name",
                          readOnly: true,
                          onTap: () {
                            if (salesOrderCreateProductController
                                        .productList ==
                                    null &&
                                salesOrderCreateProductController
                                        .productListCodeModel.value?.first ==
                                    null &&
                                salesOrderCreateProductController.productName ==
                                    "") {
                              Get.showSnackbar(
                                const GetSnackBar(
                                  margin: EdgeInsets.all(10),
                                  borderRadius: 10,
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.TOP,
                                  message: "Please Select Product Name",
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 8,
                          bottom: 8,
                        ),
                        child: CustomTextFormField(
                          inputFormatters: [NumericInputFormatter()],
                          filled: true,
                          obscureText: false,
                          keyboardInput: TextInputType.number,
                          controller: salesOrderCreateProductController
                              .productCodeController,
                          hintText: "Product Code",
                          labelText: "Product Code",
                          readOnly: true,
                          onTap: () {
                            if (salesOrderCreateProductController
                                        .productList ==
                                    null &&
                                salesOrderCreateProductController
                                        .productListCodeModel.value?.first ==
                                    null &&
                                salesOrderCreateProductController.productName ==
                                    "") {
                              Get.showSnackbar(
                                const GetSnackBar(
                                  margin: EdgeInsets.all(10),
                                  borderRadius: 10,
                                  backgroundColor: Colors.red,
                                  snackPosition: SnackPosition.TOP,
                                  message: "Please Select Product Name",
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController.cartonCountController,
                                  hintText: "0",
                                  labelText: "Carton",
                                  readOnly: false,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  onChanged: (value) async {
                                    firstCartonCalculation(value);
                                    updateTotal();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .looseCountController,
                                  hintText: "0",
                                  labelText: "Loose",
                                  readOnly: false,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  onChanged: (value) async {
                                    firstUnitCalculation(value);
                                    updateTotal();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: (salesOrderCreateProductController
                                              .productList?.pcsPerCarton ==
                                          1)
                                      ? salesOrderCreateProductController
                                          .looseCountController
                                      : salesOrderCreateProductController
                                          .qtyCountController,
                                  labelText: "Qty",
                                  readOnly: false,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  onChanged: (value) async {
                                    reverseCalculation(value);
                                    updateTotal();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .focController,
                                  hintText: "0",
                                  labelText: "Foc",
                                  readOnly: false,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .exchangeController,
                                  hintText: "0",
                                  labelText: "Exchange",
                                  readOnly: false,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .pcsController,
                                  labelText: "Pcs",
                                  readOnly: true,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Carton Price',
                                  style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: MyColors.mainTheme),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Loose Price',
                                  style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: MyColors.mainTheme),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .cartonPriceController,
                                  readOnly: true,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextFormField(
                                  inputFormatters: [NumericInputFormatter()],
                                  filled: true,
                                  obscureText: false,
                                  keyboardInput: TextInputType.number,
                                  controller: salesOrderCreateProductController
                                      .loosePriceController,
                                  readOnly: true,
                                  onTap: () {
                                    if (salesOrderCreateProductController
                                                .productList ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productListCodeModel
                                                .value
                                                ?.first ==
                                            null &&
                                        salesOrderCreateProductController
                                                .productName ==
                                            "") {
                                      Get.showSnackbar(
                                        const GetSnackBar(
                                          margin: EdgeInsets.all(10),
                                          borderRadius: 10,
                                          backgroundColor: Colors.red,
                                          snackPosition: SnackPosition.TOP,
                                          message: "Please Select Product Name",
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.toNamed(AppRoutes.bottomNavBar2);
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.all(12),
                      //     margin: const EdgeInsets.only(
                      //       top: 20,
                      //       bottom: 20,
                      //       right: 10,
                      //       left: 10,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       color: MyColors.pink,
                      //     ),
                      //     child: Text(
                      //       "Next",
                      //       style: TextStyle(
                      //           decoration: TextDecoration.none,
                      //           fontFamily: MyFont.myFont2,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           letterSpacing: 0.5,
                      //           color: MyColors.white),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(10),
              //   decoration: const BoxDecoration(
              //     color: MyColors.mainTheme,
              //     borderRadius: BorderRadius.only(
              //       topRight: Radius.circular(10),
              //       topLeft: Radius.circular(10),
              //     ),
              //   ),
              //   child: Table(
              //     children: [
              //       TableRow(children: [
              //         Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'Sub Total',
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15,
              //                     color: MyColors.white),
              //               ),
              //               const SizedBox(height: 10),
              //               Text(
              //                 "\$ ${salesOrderCreateProductController.subTotal.toStringAsFixed(2)}",
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 12,
              //                     color: MyColors.white),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'Tax',
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15,
              //                     color: MyColors.white),
              //               ),
              //               const SizedBox(height: 10),
              //               Text(
              //                 "\$ ${salesOrderCreateProductController.tax.toStringAsFixed(2)}",
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 12,
              //                     color: MyColors.white),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.all(10),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'Net Total',
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 15,
              //                     color: MyColors.white),
              //               ),
              //               const SizedBox(height: 10),
              //               Text(
              //                 "\$ ${salesOrderCreateProductController.netTotal.toStringAsFixed(2)}",
              //                 style: TextStyle(
              //                     decoration: TextDecoration.none,
              //                     fontFamily: MyFont.myFont,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 12,
              //                     color: MyColors.white),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ]),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  onTap() async {
    FocusScope.of(context).unfocus();
    ProductListModel? selectedProduct =
        salesOrderCreateProductController.productList;
    if (selectedProduct != null &&
        salesOrderCreateProductController.qtyCountController.text.isNotEmpty &&
        salesOrderCreateProductController.qtyCountController.text != "0") {
      setState(() {
        if (salesOrderCreateProductController.qtyCountController.text == "" &&
            salesOrderCreateProductController.looseCountController.text == "" &&
            salesOrderCreateProductController.cartonCountController.text ==
                "" &&
            salesOrderCreateProductController.exchangeController.text == "" &&
            salesOrderCreateProductController.focController.text == "") {
          salesOrderCreateProductController.qtyCountController.text == "0";
          salesOrderCreateProductController.looseCountController.text == "0";
          salesOrderCreateProductController.cartonCountController.text == "0";
          salesOrderCreateProductController.exchangeController.text == "0";
          salesOrderCreateProductController.focController.text == "0";
        }
        if (salesOrderCreateProductController
                .cartonCountController.text.isEmpty &&
            salesOrderCreateProductController.cartonCountController.text ==
                null) {
          salesOrderCreateProductController.cartonCountController.text = "0";
        }
        if (salesOrderCreateProductController
                .looseCountController.text.isEmpty &&
            salesOrderCreateProductController.looseCountController.text ==
                null) {
          salesOrderCreateProductController.looseCountController.text = "0";
        }
        if (salesOrderCreateProductController.qtyCountController.text.isEmpty &&
            salesOrderCreateProductController.qtyCountController.text == null) {
          salesOrderCreateProductController.qtyCountController.text = "0";
        }
        if (salesOrderCreateProductController.exchangeController.text.isEmpty &&
            salesOrderCreateProductController.exchangeController.text == null) {
          salesOrderCreateProductController.exchangeController.text = "0";
        }
        if (salesOrderCreateProductController.focController.text.isEmpty &&
            salesOrderCreateProductController.focController.text == null) {
          salesOrderCreateProductController.focController.text = "0";
        }
        //    if (salesOrderCreateProductController.productNameController.text.isEmpty) {
        //      Fluttertoast.showToast(
        //          msg: 'Please select Product', gravity: ToastGravity.CENTER);
        // }

        selectedProduct?.quantity =
            salesOrderCreateProductController.qtyCountController.text;
        selectedProduct?.looseCount =
            salesOrderCreateProductController.looseCountController.text;
        selectedProduct?.cartOnCount =
            salesOrderCreateProductController.cartonCountController.text;
        selectedProduct?.foc =
            salesOrderCreateProductController.focController.text;
        selectedProduct?.exchange =
            salesOrderCreateProductController.exchangeController.text;

        selectedProduct?.taxPerc = salesOrderCreateProductController.tax;
        ls = (salesOrderCreateProductController
                .looseCountController.text.isNotEmpty)
            ? int.parse(
                salesOrderCreateProductController.looseCountController.text)
            : 0;
        cc = (salesOrderCreateProductController
                .cartonCountController.text.isNotEmpty)
            ? int.parse(
                salesOrderCreateProductController.cartonCountController.text)
            : 0;
        qty = (salesOrderCreateProductController
                .qtyCountController.text.isNotEmpty)
            ? int.parse(
                salesOrderCreateProductController.qtyCountController.text)
            : 0;

        selectedProduct?.lsCount = ls ?? 0;
        selectedProduct?.ctCount = cc ?? 0;
        selectedProduct?.qtCount = qty ?? 0;

        bool isAlreadyAdded = salesOrderCreateProductController
            .productService.productListItems
            .any((element) => element.code == selectedProduct.code);
        if (!isAlreadyAdded) {
          salesOrderCreateProductController.productService
              .addToProductList(productList: selectedProduct!);
          Get.showSnackbar(
            const GetSnackBar(
              margin: EdgeInsets.all(10),
              borderRadius: 10,
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.TOP,
              message: "Product Successfully added",
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (isAlreadyAdded) {
          var ietm = salesOrderCreateProductController
              .productService.productListItems
              .indexWhere((element) => element.code == selectedProduct.code);

          salesOrderCreateProductController
              .productService.productListItems[ietm] = selectedProduct;

          Get.showSnackbar(
            const GetSnackBar(
              margin: EdgeInsets.all(10),
              borderRadius: 10,
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.TOP,
              message: "Product Successfully Updated",
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          Get.showSnackbar(
            const GetSnackBar(
              margin: EdgeInsets.all(10),
              borderRadius: 10,
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP,
              message: "This Product is already added",
              icon: Icon(
                Icons.error,
                color: Colors.white,
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
        // await PreferenceHelper.saveCartData(
        //     salesOrderCreateProductController.addProductModel);
        setState(() {
          salesOrderCreateProductController.clearData();
        });
      });
    } else if (salesOrderCreateProductController.qtyCountController.text ==
        "0") {
      Get.showSnackbar(
        const GetSnackBar(
          margin: EdgeInsets.all(10),
          borderRadius: 10,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
          message: "Please add Qty",
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
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
    }
    print("=================");
    print(salesOrderCreateProductController
        .productService.productListItems.length);
    print(salesOrderCreateProductController
        .productService.productListItems.first.name);
    print(salesOrderCreateProductController
        .productService.productListItems.first.qtCount);
    print(salesOrderCreateProductController.productService.productListItems.first.ctCount);
    print( selectedProduct?.ctCount);
    print(salesOrderCreateProductController.productService.productListItems.first.cartOnCount);
  }

  // onTap() async {
  //   FocusScope.of(context).unfocus();
  //   ProductListModel? selectedProduct =
  //       salesOrderCreateProductController.productList;
  //   if (selectedProduct != null &&
  //       salesOrderCreateProductController.qtyCountController.text.isNotEmpty) {
  //     if (salesOrderCreateProductController.qtyCountController.text == "" &&
  //         salesOrderCreateProductController.looseCountController.text == "" &&
  //         salesOrderCreateProductController.cartonCountController.text == "" &&
  //         salesOrderCreateProductController.exchangeController.text == "" &&
  //         salesOrderCreateProductController.focController.text == "") {
  //       salesOrderCreateProductController.qtyCountController.text == "0";
  //       salesOrderCreateProductController.looseCountController.text == "0";
  //       salesOrderCreateProductController.cartonCountController.text == "0";
  //       salesOrderCreateProductController.exchangeController.text == "0";
  //       salesOrderCreateProductController.focController.text == "0";
  //     }
  //     if (salesOrderCreateProductController
  //             .cartonCountController.text.isEmpty &&
  //         salesOrderCreateProductController.cartonCountController.text ==
  //             null) {
  //       salesOrderCreateProductController.cartonCountController.text = "0";
  //     }
  //     if (salesOrderCreateProductController.looseCountController.text.isEmpty &&
  //         salesOrderCreateProductController.looseCountController.text == null) {
  //       salesOrderCreateProductController.looseCountController.text = "0";
  //     }
  //     if (salesOrderCreateProductController.qtyCountController.text.isEmpty &&
  //         salesOrderCreateProductController.qtyCountController.text == null) {
  //       salesOrderCreateProductController.qtyCountController.text = "0";
  //     }
  //
  //     if (salesOrderCreateProductController.exchangeController.text.isEmpty &&
  //         salesOrderCreateProductController.exchangeController.text == null) {
  //       salesOrderCreateProductController.exchangeController.text = "0";
  //     }
  //     if (salesOrderCreateProductController.focController.text.isEmpty &&
  //         salesOrderCreateProductController.focController.text == null) {
  //       salesOrderCreateProductController.focController.text = "0";
  //     }
  //     //    if (salesOrderCreateProductController.productNameController.text.isEmpty) {
  //     //      Fluttertoast.showToast(
  //     //          msg: 'Please select Product', gravity: ToastGravity.CENTER);
  //     // }
  //
  //     selectedProduct.quantity =
  //         salesOrderCreateProductController.qtyCountController.text;
  //     selectedProduct.looseCount =
  //         salesOrderCreateProductController.looseCountController.text;
  //     selectedProduct.cartOnCount =
  //         salesOrderCreateProductController.cartonCountController.text;
  //     selectedProduct.foc =
  //         salesOrderCreateProductController.focController.text;
  //     selectedProduct.exchange =
  //         salesOrderCreateProductController.exchangeController.text;
  //
  //     // if (salesOrderCreateProductController.productService.productListItems.any(
  //     //     (element) => element.productCode == selectedProduct!.productCode)) {
  //     //   var selectedIndex = salesOrderCreateProductController
  //     //       .productService.productListItems
  //     //       .indexWhere((element) =>
  //     //           element.productCode == selectedProduct!.productCode);
  //     //   salesOrderCreateProductController.productService.productListItems
  //     //       .removeAt(selectedIndex);
  //     // }
  //
  //     selectedProduct.taxPerc = salesOrderCreateProductController.tax;
  //     ls = (salesOrderCreateProductController
  //             .looseCountController.text.isNotEmpty)
  //         ? int.parse(
  //             salesOrderCreateProductController.looseCountController.text)
  //         : 0;
  //     cc = (salesOrderCreateProductController
  //             .cartonCountController.text.isNotEmpty)
  //         ? int.parse(
  //             salesOrderCreateProductController.cartonCountController.text)
  //         : 0;
  //     qty = (salesOrderCreateProductController
  //             .qtyCountController.text.isNotEmpty)
  //         ? int.parse(salesOrderCreateProductController.qtyCountController.text)
  //         : 0;
  //
  //     selectedProduct.lsCount = ls ?? 0;
  //     selectedProduct.ctCount = cc ?? 0;
  //     selectedProduct.qtCount = qty ?? 0;
  //
  //     bool isAlreadyAdded = salesOrderCreateProductController
  //         .productService.productListItems
  //         .any((element) => element.code == selectedProduct.code);
  //     if (!isAlreadyAdded) {
  //       salesOrderCreateProductController.productService
  //           .addToProductList(productList: selectedProduct!);
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           margin: EdgeInsets.all(10),
  //           borderRadius: 10,
  //           backgroundColor: Colors.green,
  //           snackPosition: SnackPosition.TOP,
  //           message: "Product Successfully added",
  //           icon: Icon(
  //             Icons.check,
  //             color: Colors.white,
  //           ),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } else if (isAlreadyAdded) {
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           margin: EdgeInsets.all(10),
  //           borderRadius: 10,
  //           backgroundColor: Colors.green,
  //           snackPosition: SnackPosition.TOP,
  //           message: "Product Successfully Updated",
  //           icon: Icon(
  //             Icons.check,
  //             color: Colors.white,
  //           ),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     } else {
  //       Get.showSnackbar(
  //         const GetSnackBar(
  //           margin: EdgeInsets.all(10),
  //           borderRadius: 10,
  //           backgroundColor: Colors.red,
  //           snackPosition: SnackPosition.TOP,
  //           message: "This Product is already added",
  //           icon: Icon(
  //             Icons.error,
  //             color: Colors.white,
  //           ),
  //           duration: Duration(seconds: 2),
  //         ),
  //       );
  //     }
  //
  //     await PreferenceHelper.saveCartData(
  //         salesOrderCreateProductController.addProductModel);
  //     setState(() {
  //       salesOrderCreateProductController.clearData();
  //     });
  //   } else {
  //     Get.showSnackbar(
  //       const GetSnackBar(
  //         margin: EdgeInsets.all(10),
  //         borderRadius: 10,
  //         backgroundColor: Colors.red,
  //         snackPosition: SnackPosition.TOP,
  //         message: "Please select atleast one product",
  //         icon: Icon(
  //           Icons.error,
  //           color: Colors.white,
  //         ),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }
}
