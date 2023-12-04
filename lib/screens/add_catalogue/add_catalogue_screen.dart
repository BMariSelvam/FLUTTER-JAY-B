import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Custom_widgets/custom_textField_1.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Helper/valitation.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/screens/add_catalogue/add_catalogue_controller.dart';
import 'package:JNB/screens/cart/cart_screen.dart';
import 'package:JNB/screens/catalogue/catalogue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/fonts.dart';
import '../../Const/size.dart';

class AddCatalogue extends StatefulWidget {
  const AddCatalogue({Key? key}) : super(key: key);

  @override
  State<AddCatalogue> createState() => _AddCatalogueState();
}

class _AddCatalogueState extends State<AddCatalogue> {
  late AboutProductController aboutProductController;
  late ProductListModel productModel;
  late ProductController productController;
  int? ls;
  int? cc;
  int? qty;

  @override
  void initState() {
    super.initState();
    aboutProductController = Get.put(AboutProductController());
    productModel = Get.arguments as ProductListModel;
    initialValue();
    aboutProductController.productService.productListChangeStream.listen((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutProductController>(builder: (logic) {
      if (logic.status.isLoadingMore == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: MyColors.mainTheme,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: MyColors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'Products',
            style: TextStyle(
                fontFamily: MyFont.myFont2,
                fontWeight: FontWeight.bold,
                color: MyColors.white),
          ),
          actions: [buildAppBarCartButton()],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
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
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
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
                      Image.asset(
                        Assets.noimage,
                        scale: 4,
                      ),
                      SizedBox(height: height(context) / 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              productModel.name ?? "",
                              style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.mainTheme),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(context) / 50),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextFormField(
                                inputFormatters: [NumericInputFormatter()],
                                filled: true,
                                obscureText: false,
                                keyboardInput: TextInputType.number,
                                controller: aboutProductController
                                    .cartonCountController,
                                hintText: "0",
                                labelText: "Carton",
                                readOnly: false,
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
                                controller:
                                    aboutProductController.looseCountController,
                                hintText: "0",
                                labelText: "Loose",
                                readOnly: false,
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
                                controller: (productModel.pcsPerCarton == 1)
                                    ? aboutProductController
                                        .looseCountController
                                    : aboutProductController.qtyCountController,
                                labelText: "Qty",
                                readOnly: false,
                                onChanged: (value) async {
                                  reverseCalculation(value);
                                  updateTotal();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(context) / 150),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextFormField(
                                inputFormatters: [NumericInputFormatter()],
                                filled: true,
                                obscureText: false,
                                keyboardInput: TextInputType.number,
                                controller:
                                    aboutProductController.focController,
                                hintText: "0",
                                labelText: "Foc",
                                readOnly: false,
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
                                controller:
                                    aboutProductController.exchangeController,
                                hintText: "0",
                                labelText: "Exchange",
                                readOnly: false,
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
                                controller:
                                    aboutProductController.pcsController,
                                labelText: "Pcs",
                                readOnly: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height(context) / 50),
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
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextFormField(
                                inputFormatters: [NumericInputFormatter()],
                                fillColor: productModel.pcsPerCarton == 1
                                    ? MyColors.greyText
                                    : MyColors.white,
                                filled: true,
                                obscureText: false,
                                keyboardInput: TextInputType.number,
                                controller: aboutProductController
                                    .cartonPriceController,
                                readOnly: productModel.pcsPerCarton == 1
                                    ? true
                                    : false,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextFormField(
                                inputFormatters: [NumericInputFormatter()],
                                fillColor: productModel.pcsPerCarton == 1
                                    ? MyColors.greyText
                                    : MyColors.white,
                                filled: true,
                                obscureText: false,
                                keyboardInput: TextInputType.number,
                                controller:
                                    aboutProductController.loosePriceController,
                                readOnly: productModel.pcsPerCarton == 1
                                    ? true
                                    : false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
            //                 "\$ ${aboutProductController.subTotal.toStringAsFixed(2)}",
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
            //                 "\$ ${aboutProductController.tax.toStringAsFixed(2)}",
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
            //                 "\$ ${aboutProductController.netTotal.toStringAsFixed(2)}",
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
      );
    });
  }

  firstUnitCalculation(String value) {
    setState(() {
      if (value == "") {
        value = "0";
      }
      double unitQty = double.parse(value);
      print("UnitQty====$unitQty");
      if (aboutProductController.cartonCountController.text != "" &&
          aboutProductController.cartonCountController.text != "0") {
        double countOfPcsPerCarton =
            double.parse(aboutProductController.pcsController.text);
        double cartonQty =
            double.parse(aboutProductController.cartonCountController.text);

        ///TotalCartonQty
        double totalCartonQty = countOfPcsPerCarton * cartonQty;
        print("TotalCartonQty>>>>>>>>>>>>>>${totalCartonQty}");

        ///TotalQuantity
        double totalQty = unitQty + totalCartonQty;
        aboutProductController.qtyCountController.text =
            totalQty.toStringAsFixed(0);
      } else {
        print("value=======$value");

        aboutProductController.qtyCountController.text =
            unitQty.toStringAsFixed(0);
      }
    });
  }

  firstCartonCalculation(String value) {
    print("value2====FirstCartonCalculation=======$value");

    setState(() {
      if (value == "") {
        value = "0";
      }
      double cartonQty = double.parse(value);
      if (aboutProductController.looseCountController.text != "" &&
          aboutProductController.looseCountController.text != "0") {
        print("value3===========$value");

        double countOfPcsPerCarton =
            double.parse(aboutProductController.pcsController.text);
        double unitQty =
            double.parse(aboutProductController.looseCountController.text);
        double cartonQty =
            double.parse(aboutProductController.cartonCountController.text);

        ///TotalCartonQty
        double totalCartonQty = countOfPcsPerCarton * cartonQty;
        print("TotalCartonQty>>>>>>>>>>>>>>${totalCartonQty}");

        ///TotalQuantity
        double totalQty = unitQty + totalCartonQty;
        aboutProductController.qtyCountController.text =
            totalQty.toStringAsFixed(0);
      } else {
        print("value4===========$value");

        double countOfPcsPerCarton =
            double.parse(aboutProductController.pcsController.text);
        double totalCartonQty = cartonQty * countOfPcsPerCarton;

        aboutProductController.qtyCountController.text =
            totalCartonQty.toStringAsFixed(0);
      }
    });
  }

  reverseCalculation(String value) {
    print(value);
    setState(() {
      if (value == "") {
        value = "0";
      }
      double qty = double.parse(value);
      double countOfPcsPerCarton =
          double.parse(aboutProductController.pcsController.text);
      if (countOfPcsPerCarton != 1) {
        double oneCartonQty =
            double.parse(aboutProductController.pcsController.text);
        double boxSplit = (qty / oneCartonQty);
        if (oneCartonQty <= qty) {
          int roundedValue = boxSplit.toInt();
          aboutProductController.cartonCountController.text =
              roundedValue.toStringAsFixed(0);
          double splitUnit = qty % oneCartonQty;
          aboutProductController.looseCountController.text =
              splitUnit.toStringAsFixed(0);
        } else {
          double splitUnit = qty % oneCartonQty;
          aboutProductController.looseCountController.text =
              splitUnit.toStringAsFixed(0);
          aboutProductController.cartonCountController.text = '';
        }
      }
    });
  }

  totalFun() {
    double? cartonPrice = productModel.sellingBoxCost;
    double? unitPrice = productModel.sellingCost;
    int cartonQty =
        int.tryParse(aboutProductController.cartonCountController.text) ?? 0;
    int unitQty =
        int.tryParse(aboutProductController.looseCountController.text) ?? 0;

    if (aboutProductController.looseCountController.text == "") {
      aboutProductController.subTotal = cartonQty * cartonPrice!;
      aboutProductController.tax = aboutProductController.subTotal *
          double.parse(productModel.taxPerc.toString()) /
          100;

      aboutProductController.netTotal =
          aboutProductController.subTotal + aboutProductController.tax;
    } else if (aboutProductController.cartonCountController.text == "") {
      aboutProductController.subTotal = unitQty * unitPrice!;
      aboutProductController.tax = aboutProductController.subTotal *
          double.parse(productModel.taxPerc.toString()) /
          100;
      aboutProductController.netTotal =
          aboutProductController.subTotal + aboutProductController.tax;
    } else {
      aboutProductController.subTotal =
          (cartonQty * cartonPrice!) + (unitQty * unitPrice!);
      aboutProductController.tax = aboutProductController.subTotal *
          double.parse(productModel.taxPerc.toString()) /
          100;

      aboutProductController.netTotal =
          aboutProductController.subTotal + aboutProductController.tax;
    }
  }

  void updateTotal() {
    setState(() {
      totalFun();
    });
  }

  onTap() async {
    FocusScope.of(context).unfocus();
    ProductListModel? selectedProduct = productModel;
    if (selectedProduct != null &&
        aboutProductController.qtyCountController.text.isNotEmpty &&
        aboutProductController.qtyCountController.text != "0") {
      if (aboutProductController.qtyCountController.text == "" &&
          aboutProductController.looseCountController.text == "" &&
          aboutProductController.cartonCountController.text == "" &&
          aboutProductController.exchangeController.text == "" &&
          aboutProductController.focController.text == "") {
        aboutProductController.qtyCountController.text == "0";
        aboutProductController.looseCountController.text == "0";
        aboutProductController.cartonCountController.text == "0";
        aboutProductController.exchangeController.text == "0";
        aboutProductController.focController.text == "0";
      }
      if (aboutProductController.cartonCountController.text.isEmpty &&
          aboutProductController.cartonCountController.text == null) {
        aboutProductController.cartonCountController.text = "0";
      }
      if (aboutProductController.looseCountController.text.isEmpty &&
          aboutProductController.looseCountController.text == null) {
        aboutProductController.looseCountController.text = "0";
      }
      if (aboutProductController.qtyCountController.text.isEmpty &&
          aboutProductController.qtyCountController.text == null) {
        aboutProductController.qtyCountController.text = "0";
      }

      if (aboutProductController.exchangeController.text.isEmpty &&
          aboutProductController.exchangeController.text == null) {
        aboutProductController.exchangeController.text = "0";
      }
      if (aboutProductController.focController.text.isEmpty &&
          aboutProductController.focController.text == null) {
        aboutProductController.focController.text = "0";
      }
      //    if (aboutProductController.productNameController.text.isEmpty) {
      //      Fluttertoast.showToast(
      //          msg: 'Please select Product', gravity: ToastGravity.CENTER);
      // }
      selectedProduct?.quantity =
          aboutProductController.qtyCountController.text;
      selectedProduct?.looseCount =
          aboutProductController.looseCountController.text;
      selectedProduct?.cartOnCount =
          aboutProductController.cartonCountController.text;
      selectedProduct?.foc = aboutProductController.focController.text;
      selectedProduct?.exchange =
          aboutProductController.exchangeController.text;

      selectedProduct?.taxPerc = aboutProductController.tax;
      ls = (aboutProductController.looseCountController.text.isNotEmpty)
          ? int.parse(aboutProductController.looseCountController.text)
          : 0;
      cc = (aboutProductController.cartonCountController.text.isNotEmpty)
          ? int.parse(aboutProductController.cartonCountController.text)
          : 0;
      qty = (aboutProductController.qtyCountController.text.isNotEmpty)
          ? int.parse(aboutProductController.qtyCountController.text)
          : 0;

      selectedProduct?.lsCount = ls ?? 0;
      selectedProduct?.ctCount = cc ?? 0;
      selectedProduct?.qtCount = qty ?? 0;

      bool isAlreadyAdded = aboutProductController
          .productService.productListItems
          .any((element) => element?.code == selectedProduct.code);
      if (!isAlreadyAdded) {
        aboutProductController.productService
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
        // var ietm = aboutProductController.productService.productListItems
        //     .indexWhere((element) => element.code == selectedProduct.code);
        // aboutProductController.productService.productListItems[ietm] =
        //     selectedProduct;
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

      setState(() {
        aboutProductController.clearData();
      });
    } else if (aboutProductController.qtyCountController.text == "0") {
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
  }

  initialValue() {
    aboutProductController.pcsController.text =
        productModel.pcsPerCarton?.toStringAsFixed(0) ?? "0";
    aboutProductController.loosePriceController.text =
        productModel.sellingCost?.toStringAsFixed(2) ?? "0.00";
    aboutProductController.cartonPriceController.text =
        productModel.sellingBoxCost?.toStringAsFixed(2) ?? "0.00";
  }

  Widget buildAppBarCartButton() {
    return GestureDetector(
      onTap: () async {
        if (aboutProductController.productService.productListItems.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ));
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
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 11.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 11.0),
              child: Icon(
                Icons.shopping_cart,
                color: MyColors.white,
                size: 23,
              ),
            ),
            if (aboutProductController
                .productService.productListItems.isNotEmpty)
              Positioned(
                top: 10,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffc32c37),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Center(
                    child: Text(
                      aboutProductController
                          .productService.productListItems.length
                          .toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: MyColors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
