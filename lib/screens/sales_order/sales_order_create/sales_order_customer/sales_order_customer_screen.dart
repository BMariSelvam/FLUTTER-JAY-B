import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Custom_widgets/custom_textField_2.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/widgets/search_dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'sales_order_create_customer_controller.dart';

class SelectOrderCustomerScreen extends StatefulWidget {
  const SelectOrderCustomerScreen({super.key});

  @override
  State<SelectOrderCustomerScreen> createState() =>
      _SelectOrderCustomerScreenState();
}

class _SelectOrderCustomerScreenState extends State<SelectOrderCustomerScreen> {
  late SalesOrderCreateCustomerController salesOrderCreateCustomerController;

  String deliveryDate = "";
  String orderDate = "";
  String? customerCodePassing;

  @override
  void initState() {
    super.initState();
    salesOrderCreateCustomerController =
        Get.put(SalesOrderCreateCustomerController());

    salesOrderCreateCustomerController.getOrderCustomerList(
      "",
    );
    String? customerCodePassing = Get.arguments as String?;
    salesOrderCreateCustomerController.datecontroller.text =
        salesOrderCreateCustomerController.orderDate.toString();
    salesOrderCreateCustomerController.deliveryDatecontroller.text =
        salesOrderCreateCustomerController.deliveryDate.toString();
    salesOrderCreateCustomerController.datecontroller.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now().toLocal());
    salesOrderCreateCustomerController.deliveryDatecontroller.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now().toLocal());

    if (customerCodePassing != null) {
      salesOrderCreateCustomerController
          .getCustomersByCodeList(customerCodePassing);
    }
    salesOrderCreateCustomerController.currencyNamecontroller.text =
        "Singapore Dollar";
    salesOrderCreateCustomerController.countryNamecontroller.text = "Singapore";
    salesOrderCreateCustomerController.productService.productListChangeStream
        .listen((_) {});
  }

  calculation() {
    if (salesOrderCreateCustomerController.creditLimit == null &&
        salesOrderCreateCustomerController.outstandingAmount == null &&
        salesOrderCreateCustomerController.creditLimit == 0.0 &&
        salesOrderCreateCustomerController.outstandingAmount == 0.0) {
      salesOrderCreateCustomerController.creditLimit = 0.00;
      salesOrderCreateCustomerController.outstandingAmount = 0.00;
      salesOrderCreateCustomerController.balance = 0.00;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesOrderCreateCustomerController>(
      builder: (logic) {
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
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: MyColors.greyIcon,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                salesOrderCreateCustomerController.creditLimit
                                    .toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.mainTheme,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Credit Limit",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                salesOrderCreateCustomerController
                                    .outstandingAmount
                                    .toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.mainTheme,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Outstanding",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                salesOrderCreateCustomerController.balance
                                    .toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.mainTheme,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Balance",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: MyColors.mainTheme,
            shadowColor: MyColors.mainTheme,
            leading: GestureDetector(
              onTap: () {
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
                              salesOrderCreateCustomerController.clearData();
                              salesOrderCreateCustomerController.productService
                                  .clearProductList();
                            });
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                              // Get.offAndToNamed(AppRoutes.bottomNavBar0);
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
            //   icon: const Icon(Icons.arrow_back_ios_new_rounded,
            //       size: 18, color: MyColors.white),
            //   onPressed: () {
            //     Get.back();
            //   },
            // ),
            titleTextStyle: TextStyle(
                fontFamily: MyFont.myFont2,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: hexStringToColor('FFFFFF')),
            title: const Text(
              'Sales Order',
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
                          salesOrderCreateCustomerController.clearData();
                          salesOrderCreateCustomerController.productService
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
                  Obx(
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
                              salesOrderCreateCustomerController.clearData();
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
                        items: salesOrderCreateCustomerController
                            .customerListModel.value,
                        color: Colors.black54,
                        selectedItem:
                            salesOrderCreateCustomerController.customer ??
                                salesOrderCreateCustomerController
                                    .customerCodeListModel.value?.first,
                        isValidator: true,
                        onAddPressed: (value) {
                          setState(() {
                            salesOrderCreateCustomerController.CustomerName =
                                "";
                            salesOrderCreateCustomerController.customer = value;
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            salesOrderCreateCustomerController.value = value;
                            salesOrderCreateCustomerController.customer = value;
                            salesOrderCreateCustomerController.CustomerName =
                                value.name;
                          });
                          setState(
                            () {
                              salesOrderCreateCustomerController.customerCode =
                                  "${value.code}";
                              salesOrderCreateCustomerController
                                  .getCustomersByCodeList(
                                      salesOrderCreateCustomerController
                                          .customerCode);
                              salesOrderCreateCustomerController
                                  .productService.productListItems
                                  .clear();
                            },
                          );
                        },
                      );
                    },
                  ),
                  Column(
                    children: [
                      CustomTextField2(
                        inputBorder: const OutlineInputBorder(),
                        controller: salesOrderCreateCustomerController
                            .customerNamecontroller,
                        keyboardType: TextInputType.text,
                        labelText: "Customer Name",
                        hintText: 'Customer Name',
                        filled: false,
                        readOnly: true,
                        onTap: () {
                          if (salesOrderCreateCustomerController.customer ==
                                  null &&
                              salesOrderCreateCustomerController
                                      .customerCodeListModel.value?.first ==
                                  null &&
                              salesOrderCreateCustomerController.CustomerName ==
                                  "") {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please Select Customer",
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
                      CustomTextField2(
                        inputBorder: const OutlineInputBorder(),
                        controller: salesOrderCreateCustomerController
                            .customerAddresscontroller,
                        keyboardType: TextInputType.text,
                        labelText: "Customer Address",
                        hintText: 'Customer Address',
                        filled: false,
                        readOnly: true,
                        onTap: () {
                          if (salesOrderCreateCustomerController.customer ==
                                  null &&
                              salesOrderCreateCustomerController
                                      .customerCodeListModel.value?.first ==
                                  null &&
                              salesOrderCreateCustomerController.CustomerName ==
                                  "") {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please Select Customer",
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField2(
                              filled: false,
                              readOnly: true,
                              inputBorder: const OutlineInputBorder(),
                              controller: salesOrderCreateCustomerController
                                  .datecontroller,
                              keyboardType: TextInputType.datetime,
                              hintText: "Date",
                              labelText: "Date",
                              suffixIcon: const Icon(Icons.date_range,
                                  color: MyColors.mainTheme),
                              // onTap: () async {
                              //   showDatePicker(
                              //           context: context,
                              //           initialDate: DateTime.now(),
                              //           firstDate: DateTime.now(),
                              //           lastDate: DateTime(2100))
                              //       .then((value) {
                              //     setState(() {
                              //       salesOrderCreateCustomerController
                              //           .orderDate = value!;
                              //       salesOrderCreateCustomerController
                              //               .datecontroller.text =
                              //           '${salesOrderCreateCustomerController.orderDate.day}-${salesOrderCreateCustomerController.orderDate.month}-${salesOrderCreateCustomerController.orderDate.year}';
                              //       salesOrderCreateCustomerController
                              //               .dates =
                              //           '${salesOrderCreateCustomerController.orderDate.year}-${salesOrderCreateCustomerController.orderDate.month}-${salesOrderCreateCustomerController.orderDate.day}';
                              //     });
                              //   });
                              // },
                            ),
                          ),
                          Expanded(
                            child: CustomTextField2(
                              filled: false,
                              readOnly: true,
                              inputBorder: const OutlineInputBorder(),
                              controller: salesOrderCreateCustomerController
                                  .deliveryDatecontroller,
                              keyboardType: TextInputType.datetime,
                              labelText: "Delivery Date",
                              hintText: "Delivery Date",
                              suffixIcon: const Icon(Icons.date_range,
                                  color: MyColors.mainTheme),
                              // onTap: () async {
                              //   showDatePicker(
                              //           context: context,
                              //           initialDate: widget
                              //               .salesOrderCreateCustomerController
                              //               .orderDate,
                              //           firstDate: widget
                              //               .salesOrderCreateCustomerController
                              //               .orderDate,
                              //           lastDate: DateTime(2100))
                              //       .then((value) {
                              //     setState(() {
                              //       salesOrderCreateCustomerController
                              //           .deliveryDate = value!;
                              //
                              //       salesOrderCreateCustomerController
                              //               .deliveryDatecontroller.text =
                              //           '${salesOrderCreateCustomerController.deliveryDate.day}-${salesOrderCreateCustomerController.deliveryDate.month}-${salesOrderCreateCustomerController.deliveryDate.year}';
                              //
                              //       salesOrderCreateCustomerController
                              //               .deliveryDates =
                              //           '${salesOrderCreateCustomerController.deliveryDate.year}-${salesOrderCreateCustomerController.deliveryDate.month}-${salesOrderCreateCustomerController.deliveryDate.day}';
                              //     });
                              //   });
                              // },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                            child: Text(
                              'Currency Code',
                              style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: MyColors.pink),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField2(
                        inputBorder: const OutlineInputBorder(),
                        controller: salesOrderCreateCustomerController
                            .currencyNamecontroller,
                        keyboardType: TextInputType.text,
                        labelText: "Currency Name",
                        hintText: 'Currency Name',
                        filled: false,
                        readOnly: true,
                        onTap: () {
                          if (salesOrderCreateCustomerController.customer ==
                                  null &&
                              salesOrderCreateCustomerController
                                      .customerCodeListModel.value?.first ==
                                  null &&
                              salesOrderCreateCustomerController.CustomerName ==
                                  "") {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please Select Customer",
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
                      CustomTextField2(
                        inputBorder: const OutlineInputBorder(),
                        controller: salesOrderCreateCustomerController
                            .countryNamecontroller,
                        keyboardType: TextInputType.text,
                        labelText: "Country Name",
                        hintText: 'Country Name',
                        filled: false,
                        readOnly: true,
                        onTap: () {
                          if (salesOrderCreateCustomerController.customer ==
                                  null &&
                              salesOrderCreateCustomerController
                                      .customerCodeListModel.value?.first ==
                                  null &&
                              salesOrderCreateCustomerController.CustomerName ==
                                  "") {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please Select Customer",
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
                      CustomTextField2(
                        filled: false,
                        readOnly:
                            salesOrderCreateCustomerController.customer ==
                                        null &&
                                    salesOrderCreateCustomerController
                                            .customerCodeListModel
                                            .value
                                            ?.first ==
                                        null &&
                                    salesOrderCreateCustomerController
                                            .CustomerName ==
                                        ""
                                ? true
                                : false,
                        maxLines: 7,
                        inputBorder: const OutlineInputBorder(),
                        controller:
                            salesOrderCreateCustomerController.remarkcontroller,
                        keyboardType: TextInputType.text,
                        labelText: "Remark",
                        hintText: "Text Here",
                        suffixIcon: const Icon(
                          Icons.edit,
                          color: MyColors.mainTheme,
                          size: 18,
                        ),
                        onTap: () {
                          if (salesOrderCreateCustomerController.customer ==
                                  null &&
                              salesOrderCreateCustomerController
                                      .customerCodeListModel.value?.first ==
                                  null &&
                              salesOrderCreateCustomerController.CustomerName ==
                                  "") {
                            Get.showSnackbar(
                              const GetSnackBar(
                                margin: EdgeInsets.all(10),
                                borderRadius: 10,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                message: "Please Select Customer",
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
