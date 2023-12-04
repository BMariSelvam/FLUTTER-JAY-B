import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/sales_order/sales_order_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Helper/extension.dart';
import 'sales_order_screen/print_preview_controller.dart';

class PrintPreviewScreen extends StatefulWidget {
  const PrintPreviewScreen({
    super.key,
  });

  @override
  State<PrintPreviewScreen> createState() => _PrintPreviewScreenState();
}

class _PrintPreviewScreenState extends State<PrintPreviewScreen> {
  late SalesOrderListModel salesOrderListModel;
  late PrintPreviewController printPreviewController;

  String? companyName;
  String? companyBranchName;

  @override
  void initState() {
    super.initState();
    getUserData();
    salesOrderListModel = Get.arguments as SalesOrderListModel;
    printPreviewController = Get.put(PrintPreviewController());
    printPreviewController.getSalesOrderListCode(salesOrderListModel.tranNo);
  }

  calculation() {}
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrintPreviewController>(builder: (logic) {
      if (logic.status.isLoading == true ||
          logic.status.isLoadingMore == true) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.only(right: 20),
            //     child: GestureDetector(
            //       onTap: () {},
            //       child: const Icon(
            //         Icons.print,
            //         color: MyColors.white,
            //         size: 25,
            //       ),
            //     ),
            //   ),
            //   // buildAppBarCartButton()
            // ],
            toolbarHeight: 80,
            elevation: 0,
            backgroundColor: MyColors.mainTheme,
            flexibleSpace: Container(),
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: MyColors.white,
              ),
            ),
            title: Text("Sales Order",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: MyFont.myFont2,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                )),
          ),
          backgroundColor: MyColors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Text(companyName ?? "",
                      // "JAY & B TRADING PTE LTD",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: MyColors.mainTheme)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 8),
                  child: Text(companyBranchName ?? "",
                      // "JNB lINK POSITION",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: MyColors.mainTheme)),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width(context) / 3.5,
                                child: Text(
                                  "SalesOrder No",
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
                              salesOrderListModel.tranNo ?? "",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width(context) / 3.5,
                                child: Text(
                                  "SalesOrder Date",
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
                              formatDate(
                                salesOrderListModel.tranDate
                                        ?.substring(0, 10) ??
                                    "",
                              ),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: width(context) / 3.5,
                                child: Text(
                                  "Customer Code",
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
                              salesOrderListModel.customerId ?? "",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              salesOrderListModel.customerName ?? "",
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
                    ],
                  ),
                ),
                Container(
                  color: MyColors.mainTheme,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(0.5),
                          1: FlexColumnWidth(0.8),
                          2: FlexColumnWidth(0.5),
                          3: FlexColumnWidth(0.5),
                          4: FlexColumnWidth(0.5),
                          5: FlexColumnWidth(0.5),
                          6: FlexColumnWidth(0.5),
                        },
                        children: [
                          TableRow(children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'SlNo.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Description',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CQty',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'LQty',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CPrice',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'LPrice',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: MyFont.myFont2),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                productDetailsList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width(context) / 5,
                                    child: Text(
                                      "Sub Total",
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
                                width: width(context) / 4,
                                child: Text(
                                  "\$ ${salesOrderListModel.subTotal?.toStringAsFixed(2) ?? ""}",
                                  textAlign: TextAlign.end,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width(context) / 5,
                                    child: Text(
                                      "Tax",
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
                                width: width(context) / 4,
                                child: Text(
                                  "\$ ${salesOrderListModel.tax?.toStringAsFixed(2) ?? ""}",
                                  textAlign: TextAlign.end,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width(context) / 5,
                                    child: Text(
                                      "Net Total ",
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
                                width: width(context) / 4,
                                child: Text(
                                  "\$ ${salesOrderListModel.netTotal?.toStringAsFixed(2) ?? ""}",
                                  textAlign: TextAlign.end,
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
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width(context) / 5.5,
                            child: Text(
                              "Remarks",
                              textAlign: TextAlign.center,
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
                            ":  ",
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
                        width: width(context) / 1.5,
                        child: Text(
                          salesOrderListModel.remarks ?? "",
                          textAlign: TextAlign.start,
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
                ),
                const SizedBox(height: 50),
              ],
            ),
          ));
    });
  }

  productDetailsList() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: printPreviewController
            .salesOrderListCodeModel.value?.first.salesOrderDetail?.length,
        itemBuilder: (context, index) {
          var qty = printPreviewController.salesOrderListCodeModel.value?.first
              .salesOrderDetail?[index].boxQty;
          return Container(
            color: MyColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(0.8),
                    2: FlexColumnWidth(0.5),
                    3: FlexColumnWidth(0.5),
                    4: FlexColumnWidth(0.5),
                    5: FlexColumnWidth(0.5),
                    6: FlexColumnWidth(0.5),
                  },
                  children: [
                    TableRow(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${printPreviewController.salesOrderListCodeModel.value?.first.salesOrderDetail?[index].slNo ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          printPreviewController
                                  .salesOrderListCodeModel
                                  .value
                                  ?.first
                                  .salesOrderDetail?[index]
                                  .productName ??
                              "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${printPreviewController.salesOrderListCodeModel.value?.first.salesOrderDetail?[index].boxQty ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${printPreviewController.salesOrderListCodeModel.value?.first.salesOrderDetail?[index].pcsQty ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${printPreviewController.salesOrderListCodeModel.value?.first.salesOrderDetail?[index].qty ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          printPreviewController.salesOrderListCodeModel.value
                                  ?.first.salesOrderDetail?[index].boxPrice
                                  ?.toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          printPreviewController.salesOrderListCodeModel.value
                                  ?.first.salesOrderDetail?[index].price
                                  ?.toStringAsFixed(2) ??
                              "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              fontFamily: MyFont.myFont2),
                        ),
                      ),
                    ]),
                  ],
                ),
                const Divider(
                  thickness: 0.5,
                  color: MyColors.greyText,
                )
              ],
            ),
          );
        });
  }

  getUserData() async {
    await PreferenceHelper.getUserData().then((value) {
      companyName = value?.organisationName;
    });
    companyBranchName = await PreferenceHelper.getBranchNameString();
    print(companyBranchName);
    print("companyBranchName__________________________________");
  }
}
