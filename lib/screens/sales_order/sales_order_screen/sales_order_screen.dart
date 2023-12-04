import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Custom_widgets/custom_button.dart';
import 'package:JNB/Custom_widgets/custom_textField_1.dart';
import 'package:JNB/Custom_widgets/custom_textField_2.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_screen_controller.dart';
import 'package:JNB/widgets/bottom_nav_bar.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:JNB/widgets/search_dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({
    super.key,
  });

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  late SalesOrderController salesOrderController;
  String? customerCode;
  String date = "";
  String toDate = "";

  String? name;
  String? branchName;
  String currentDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
  getUserData() async {
    await PreferenceHelper.getUserData().then((value) => setState(() {
          name = value?.name;
        }));
    branchName = await PreferenceHelper.getBranchNameString();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    salesOrderController = Get.put(SalesOrderController());
    salesOrderController.getOrderCustomerList("");
    salesOrderController.getOrderCodeList(
        customerCode: "",
        searchFromDate: currentDate,
        searchToDate: currentDate,
        isSearch: false);
    salesOrderController.isSelectedFilter = true;
    // getUserData();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    getUserData();
    salesOrderController = Get.put(SalesOrderController());
    salesOrderController.getOrderCustomerList("");
    salesOrderController.getOrderCodeList(
        customerCode: "",
        searchFromDate: currentDate,
        searchToDate: currentDate,
        isSearch: false);
    salesOrderController.isSelectedFilter = true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesOrderController>(builder: (logic) {
      if (logic.status.isLoading == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return WillPopScope(
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
                title: const Text('Do you want to go Dashboard?'),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Get.offAllNamed(AppRoutes.dashBoardScreen);
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
          return shouldPop!;
        },
        child: Scaffold(
          key: salesOrderController.salesOrderScaffoldKey,
          drawer: getDrawer(context, name, branchName),
          backgroundColor: MyColors.white,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: MyColors.mainTheme,
            flexibleSpace: Container(),
            leading: GestureDetector(
              onTap: () {
                salesOrderController.salesOrderScaffoldKey.currentState
                    ?.openDrawer();
              },
              child: Image.asset(
                Assets.icon1,
                scale: 1,
              ),
            ),
            // leading: GestureDetector(
            //   onTap: () {
            //     showDialog<bool>(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           shape: const RoundedRectangleBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(25)),
            //             side: BorderSide(
            //               width: 2,
            //               color: MyColors.lightmainTheme,
            //             ),
            //           ),
            //           title: const Text('Do you want to go Dashboard?'),
            //           actionsAlignment: MainAxisAlignment.spaceAround,
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 setState(() {
            //                   Get.offAllNamed(AppRoutes.dashBoardScreen);
            //                 });
            //               },
            //               child: const Text('Yes'),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 setState(() {
            //                   Navigator.pop(context);
            //                   // Get.offAndToNamed(AppRoutes.bottomNavBar0);
            //                 });
            //               },
            //               child: const Text('No'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   child: const Icon(Icons.arrow_back_ios_rounded),
            // ),
            title: Text('Sales Order',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFont.myFont2,
                    color: MyColors.white)),
            actions: [
              IconButton(
                icon: Icon(
                  salesOrderController.isSelectedFilter
                      ? Icons.filter_alt_outlined
                      : Icons.filter_alt_off_outlined,
                  color: MyColors.white,
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    salesOrderController.isSelectedFilter =
                        !salesOrderController.isSelectedFilter;
                    salesOrderController.clearData();
                    salesOrderController.getOrderCodeList(
                        customerCode: "",
                        searchFromDate: currentDate,
                        searchToDate: currentDate,
                        isSearch: false);
                  });
                },
              ),
            ],
          ),
          bottomNavigationBar: Container(
            width: width(context),
            color: MyColors.white,
            padding: const EdgeInsets.fromLTRB(40, 15, 40, 18),
            child: CustomButton(
              color: MyColors.pink,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(),
                    ));
              },
              title: 'Add',
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      salesOrderController.isSelectedFilter
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Obx(() {
                                    return SearchDropdownTextField<
                                            CustomerListModel>(
                                        hintText: 'Select Customer',
                                        hintTextStyle: TextStyle(
                                          fontFamily: MyFont.myFont2,
                                          color: MyColors.black,
                                          fontSize: 13,
                                        ),
                                        textStyle: TextStyle(
                                          fontFamily: MyFont.myFont2,
                                          color: MyColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        // prefixIcon: const Icon(
                                        //   Icons.search,
                                        //   color: MyColors.pink,
                                        // ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              salesOrderController.clearData();
                                              salesOrderController
                                                  .getOrderCodeList(
                                                      customerCode: "",
                                                      searchFromDate:
                                                          currentDate,
                                                      searchToDate: currentDate,
                                                      isSearch: false);
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
                                        items: salesOrderController
                                            .customerListModel.value,
                                        color: Colors.black54,
                                        selectedItem:
                                            salesOrderController.customerList,
                                        isValidator: true,
                                        onAddPressed: () {
                                          setState(() {
                                            salesOrderController.customerName =
                                                "";
                                            salesOrderController.customerList =
                                                null;
                                          });
                                        },
                                        onChanged: (value) {
                                          FocusScope.of(context).unfocus();
                                          salesOrderController.customerList =
                                              value;
                                          salesOrderController.customerName =
                                              value.name;
                                          setState(() {
                                            salesOrderController.customerName =
                                                value.name;
                                            salesOrderController
                                                .customerCodecontroller
                                                .text = value.code ?? "";
                                            customerCode = value.code;
                                          });
                                        });
                                  }),
                                  CustomTextField2(
                                    inputBorder: const OutlineInputBorder(),
                                    controller: salesOrderController
                                        .customerCodecontroller,
                                    keyboardType: TextInputType.text,
                                    labelText: "Customer Code",
                                    hintText: 'Customer Code',
                                    filled: false,
                                    readOnly: true,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: CustomTextFormField(
                                            controller: salesOrderController
                                                .fromDatecontroller,
                                            labelText: "From Date",
                                            hintText: "From Date",
                                            readOnly: true,
                                            inputFormatters: const [],
                                            suffixIcon: const Icon(
                                                Icons.calendar_month_outlined),
                                            onTap: () async {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now(),
                                              ).then((value) {
                                                setState(() {
                                                  salesOrderController
                                                      .selectedDate = value!;
                                                  salesOrderController
                                                          .fromDatecontroller
                                                          .text =
                                                      '${salesOrderController.selectedDate.day}-${salesOrderController.selectedDate.month}-${salesOrderController.selectedDate.year}';

                                                  salesOrderController.date =
                                                      '${salesOrderController.selectedDate.year}-${salesOrderController.selectedDate.month}-${salesOrderController.selectedDate.day}';
                                                });
                                              });
                                            },
                                            obscureText: false,
                                            filled: false,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: CustomTextFormField(
                                            controller: salesOrderController
                                                .toDatecontroller,
                                            labelText: "To Date",
                                            hintText: "To Date",
                                            readOnly: true,
                                            inputFormatters: const [],
                                            suffixIcon: const Icon(
                                                Icons.calendar_month_outlined),
                                            onTap: () async {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate:
                                                          salesOrderController
                                                              .selectedDate,
                                                      lastDate: DateTime.now())
                                                  .then((value) {
                                                setState(() {
                                                  salesOrderController
                                                      .selectedToDate = value!;
                                                  salesOrderController
                                                          .toDatecontroller
                                                          .text =
                                                      '${salesOrderController.selectedToDate.day}-${salesOrderController.selectedToDate.month}-${salesOrderController.selectedToDate.year}';

                                                  salesOrderController.toDate =
                                                      '${salesOrderController.selectedToDate.year}-${salesOrderController.selectedToDate.month}-${salesOrderController.selectedToDate.day}';
                                                });
                                              });
                                            },
                                            obscureText: false,
                                            filled: false,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (salesOrderController.customerList !=
                                          null) {
                                        salesOrderController.getOrderCodeList(
                                            customerCode: customerCode ?? "",
                                            searchFromDate:
                                                salesOrderController.date,
                                            searchToDate:
                                                salesOrderController.toDate,
                                            isSearch: true);
                                      } else {
                                        Get.showSnackbar(
                                          const GetSnackBar(
                                            margin: EdgeInsets.all(10),
                                            borderRadius: 10,
                                            backgroundColor: Colors.red,
                                            snackPosition: SnackPosition.TOP,
                                            message: "Select Customer Name",
                                            icon: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    child: (salesOrderController
                                                .isSearchFilter ==
                                            true)
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 21,
                                                  bottom: 21,
                                                  right: 10,
                                                  left: 10,
                                                ),
                                                height: height(context) / 28,
                                                width: width(context) / 15,
                                                color: MyColors.white,
                                                child: const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.pink)),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              right: 10,
                                              left: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: MyColors.pink,
                                            ),
                                            child: Text(
                                              "Search",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.5,
                                                  color: MyColors.white),
                                            ),
                                          ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: MyColors.greyText,
                                  ),
                                ],
                              ),
                            ),
                      (salesOrderController.salesOrderSearchListModel.value !=
                                  null &&
                              salesOrderController
                                  .salesOrderSearchListModel.value!.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: orderList(),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50, bottom: 15),
                                    child: Image.asset(Assets.orderEmpty,
                                        scale: .8),
                                  ),
                                  Text(
                                    "No Orders",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: MyFont.myFont2,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        color: MyColors.mainTheme),
                                  ),
                                ],
                              ),
                            ),
                    ]),
              ),
            ),
          ),
        ),
      );
    });
  }

  orderList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: salesOrderController.salesOrderSearchListModel.value?.length,
      itemBuilder: (context, index) {
        DateTime dateTime = DateFormat("yyyy-MM-dd").parse(salesOrderController
                .salesOrderSearchListModel.value?[index].tranDate
                .toString() ??
            "");
        String orderDate = DateFormat("dd-MM-yyyy").format(dateTime);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: const EdgeInsets.only(
            top: 10,
            left: 18,
            right: 18,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width(context) / 2.2,
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 15,
                      right: 10,
                      bottom: 5,
                    ),
                    child: Text(
                      salesOrderController.salesOrderSearchListModel
                              .value?[index].customerName ??
                          "",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: MyColors.mainTheme),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 1,
                      right: 10,
                    ),
                    padding: const EdgeInsets.only(
                      left: 1,
                      right: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: MyColors.lightmainTheme,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 5, right: 10, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(
                                Icons.edit_document,
                                color: MyColors.pink,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Option",
                                style: TextStyle(
                                    fontFamily: MyFont.myFont2,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                    color: MyColors.mainTheme),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        editPopupMenuButton(
                            context,
                            salesOrderController
                                .salesOrderSearchListModel.value![index]),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 15, top: 5, bottom: 10, right: 5),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.7),
                    1: FlexColumnWidth(1.4)
                  },
                  children: [
                    TableRow(children: [
                      Text(
                        'Order Number:',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: MyFont.myFont2,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: MyColors.greyText),
                      ),
                      Text('Date:',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: MyColors.greyText)),
                      Text('Net Total',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: MyColors.greyText)),
                    ]),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3, right: 3),
                          child: Text(
                              salesOrderController.salesOrderSearchListModel
                                      .value?[index].tranNo ??
                                  "",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, right: 3),
                          child: Text(orderDate,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: MyColors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, right: 3),
                          child: Text(
                            "\$ ${salesOrderController.salesOrderSearchListModel.value?[index].netTotal ?? ""}",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: MyColors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  editPopupMenuButton(
      BuildContext context, SalesOrderListModel salesOrderListModel) {
    return SizedBox(
        height: 25,
        width: 28,
        child: PopupMenuButton(
          splashRadius: 10,
          color: MyColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(width: 2, color: MyColors.lightmainTheme)),
          iconSize: 25,
          padding: const EdgeInsets.all(1),
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: MyColors.mainTheme,
          ),
          offset: const Offset(0, 30),
          itemBuilder: (_) => <PopupMenuEntry>[
            PopupMenuItem(
                onTap: () {
                  Get.toNamed(AppRoutes.PrintPreviewScreen,
                      arguments: salesOrderListModel);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Image.asset(
                        IconAssets.editIcon,
                        color: MyColors.pink,
                      ),
                      SizedBox(
                        width: width(context) / 30,
                      ),
                      Text(
                        'Print Preview',
                        style: TextStyle(
                            fontFamily: MyFont.myFont2,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: MyColors.mainTheme),
                      ),
                    ]),
                  ],
                )),
            // PopupMenuItem(
            //     child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //       Image.asset(
            //         IconAssets.createOrder,
            //         color: MyColors.pink,
            //         scale: 1.1,
            //       ),
            //       SizedBox(
            //         width: width(context) / 30,
            //       ),
            //       Text(
            //         'Create Order ',
            //         style: TextStyle(
            //             fontFamily: MyFont.myFont2,
            //             fontWeight: FontWeight.w900,
            //             fontSize: 15,
            //             color: MyColors.mainTheme),
            //       ),
            //     ]),
            //     Divider(
            //       thickness: 1,
            //     ),
            //   ],
            // )),
            // PopupMenuItem(
            //     child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //       Image.asset(
            //         IconAssets.createInvoice,
            //         color: MyColors.pink,
            //       ),
            //       SizedBox(
            //         width: width(context) / 30,
            //       ),
            //       Text(
            //         'Create Invoice',
            //         style: TextStyle(
            //             fontFamily: MyFont.myFont2,
            //             fontWeight: FontWeight.w900,
            //             fontSize: 15,
            //             color: MyColors.mainTheme),
            //       ),
            //     ]),
            //     Divider(
            //       thickness: 1,
            //     ),
            //   ],
            // )),
            // PopupMenuItem(
            //     child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //       Image.asset(
            //         IconAssets.createReceipt,
            //         color: MyColors.pink,
            //         scale: 1.6,
            //       ),
            //       SizedBox(
            //         width: width(context) / 30,
            //       ),
            //       Text(
            //         'Create Receipt',
            //         style: TextStyle(
            //             fontFamily: MyFont.myFont2,
            //             fontWeight: FontWeight.w900,
            //             fontSize: 15,
            //             color: MyColors.mainTheme),
            //       ),
            //     ]),
            //     Divider(
            //       thickness: 1,
            //     ),
            //   ],
            // )),
            // PopupMenuItem(
            //     child: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //       Image.asset(
            //         IconAssets.viewLocation,
            //         color: MyColors.pink,
            //         scale: 1.2,
            //       ),
            //       SizedBox(
            //         width: width(context) / 30,
            //       ),
            //       Text(
            //         'View Location',
            //         style: TextStyle(
            //             fontFamily: MyFont.myFont2,
            //             fontWeight: FontWeight.w900,
            //             fontSize: 15,
            //             color: MyColors.mainTheme),
            //       )
            //     ]),
            //     Divider(
            //       thickness: 1,
            //     ),
            //   ],
            // )),
            // PopupMenuItem(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Image.asset(
            //               IconAssets.delete,
            //               color: MyColors.pink,
            //               scale: 1.2,
            //             ),
            //             SizedBox(
            //               width: width(context) / 30,
            //             ),
            //             Text(
            //               'Delete',
            //               style: TextStyle(
            //                   fontFamily: MyFont.myFont2,
            //                   fontWeight: FontWeight.w900,
            //                   fontSize: 15,
            //                   color: MyColors.mainTheme),
            //             ),
            //           ]),
            //       Divider(
            //         thickness: 1,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ));
  }
}
