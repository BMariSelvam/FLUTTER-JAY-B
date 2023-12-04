import 'package:JNB/Const/colors.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_customer/sales_order_create_customer_controller.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_customer/sales_order_customer_screen.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_product/sales_order_product_screen.dart';
import 'package:JNB/screens/sales_order/sales_order_create/sales_order_summary/sales_order_summery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class BottomNavBar extends StatefulWidget {
//   int? intex;
//   BottomNavBar({this.intex = 0, Key? key}) : super(key: key);
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   List<Widget> tab = [];
//   late SalesOrderCreateCustomerController salesOrderCreateCustomerController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     salesOrderCreateCustomerController = Get.put(SalesOrderCreateCustomerController());
//
//     tab = [
//       SelectOrderCustomerScreen(salesOrderCreateCustomerController: salesOrderCreateCustomerController),
//       const SalesOrderProductScreen(),
//       const SalesOrderSummaryScreen()
//     ];
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     salesOrderCreateCustomerController.clearData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: widget.intex,
//         children: tab,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedLabelStyle: const TextStyle(color: MyColors.white),
//         backgroundColor: MyColors.lightmainTheme2,
//         elevation: 25,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             activeIcon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child: Icon(Icons.group, size: 28, color: MyColors.mainTheme),
//             ),
//             icon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child:
//                   Icon(Icons.group, size: 28, color: MyColors.lightmainTheme),
//             ),
//             label: 'Customer',
//           ),
//           BottomNavigationBarItem(
//             activeIcon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child: Icon(Icons.pages_rounded,
//                   size: 28, color: MyColors.mainTheme),
//             ),
//             icon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child: Icon(Icons.pages_rounded,
//                   size: 28, color: MyColors.lightmainTheme),
//             ),
//             label: 'Product',
//           ),
//           BottomNavigationBarItem(
//             activeIcon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child: Icon(
//                 Icons.pie_chart,
//                 color: MyColors.mainTheme,
//                 size: 28,
//               ),
//             ),
//             icon: Padding(
//               padding: EdgeInsets.only(top: 1),
//               child: Icon(
//                 Icons.pie_chart,
//                 color: MyColors.lightmainTheme,
//                 size: 28,
//               ),
//             ),
//             label: 'Summary',
//           ),
//         ],
//         currentIndex: widget.intex!,
//         selectedItemColor: MyColors.mainTheme,
//         onTap: onItemTapped,
//       ),
//     );
//   }
//
//   onItemTapped(int index) {
//     if (salesOrderCreateCustomerController.isChecked == true) {
//       print(index);
//       print(widget.intex);
//       setState(() {
//         widget.intex = index;
//       });
//     } else {
//       // show toast for select customer
//       Get.showSnackbar(
//         const GetSnackBar(
//           margin: EdgeInsets.all(10),
//           borderRadius: 10,
//           backgroundColor: Colors.red,
//           snackPosition: SnackPosition.TOP,
//           message: "Please Select Customer",
//           icon: Icon(
//             Icons.error,
//             color: Colors.white,
//           ),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }
//
//   // onItemTapped(int index) {
//   //   print(index);
//   //   print(widget.intex);
//   //   setState(() {
//   //     widget.intex = index;
//   //   });
//   // }
//   iconBackground(String iconName, String image) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: hexStringToColor("FFFFFF"),
//           borderRadius: BorderRadius.circular(75)),
//       child: Column(
//         children: [
//           Image.asset(
//             image,
//             scale: 1.8,
//           ),
//           Text(iconName),
//         ],
//       ),
//     );
//   }
// }

class BottomNavBar extends StatefulWidget {
  // int currentIndex;
  // int previousIndex;

  BottomNavBar({
    // this.currentIndex = 0,
    // this.previousIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late SalesOrderCreateCustomerController salesOrderCreateCustomerController;
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesOrderCreateCustomerController =
        Get.put(SalesOrderCreateCustomerController());
  }

  void _onItemTapped(int index) async {
    if (salesOrderCreateCustomerController.isChecked == true) {
      setState(() {
        currentIndex = index;
      });
    } else {
      // show toast for select customer
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
  }

  final tab = [
    SelectOrderCustomerScreen(),
    const SalesOrderProductScreen(),
    const SalesOrderSummaryScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tab.elementAt(currentIndex),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.group, size: 28, color: MyColors.mainTheme),
              ),
              icon: Padding(
                padding: EdgeInsets.only(top: 1),
                child:
                    Icon(Icons.group, size: 28, color: MyColors.lightmainTheme),
              ),
              label: 'Customer',
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.pages_rounded,
                    size: 28, color: MyColors.mainTheme),
              ),
              icon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(Icons.pages_rounded,
                    size: 28, color: MyColors.lightmainTheme),
              ),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.pie_chart,
                  color: MyColors.mainTheme,
                  size: 28,
                ),
              ),
              icon: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.pie_chart,
                  color: MyColors.lightmainTheme,
                  size: 28,
                ),
              ),
              label: 'Summary',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: MyColors.primaryCustom,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
