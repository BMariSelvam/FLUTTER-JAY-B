import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/screens/catalogue/catalogue_screen.dart';
import 'package:JNB/screens/customer/customer_list_screen.dart';
import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_screen.dart';
import 'package:JNB/screens/visited/visited_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

getDrawer(context, userName, branchName) {
  return Drawer(
    width: width(context) / 1.3,
    child: Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.greyBackground)),
      child: Column(
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(
                            Icons.arrow_right_alt_rounded,
                            color: MyColors.pink,
                            size: 30,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          Assets.appBarCompIcon,
                          scale: .8,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    userName ?? "",
                    style: TextStyle(
                        fontFamily: MyFont.myFont2,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: MyColors.mainTheme),
                  ),
                  SizedBox(
                    height: height(context) / 50,
                  ),
                  Text(branchName ?? "",
                      style: TextStyle(
                          fontFamily: MyFont.myFont2,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: MyColors.black)),
                  SizedBox(
                    height: height(context) / 50,
                  ),
                  const Divider(
                    thickness: 1,
                    color: MyColors.greyText,
                  ),
                  listTile(
                      const Icon(
                        Icons.dashboard_customize,
                        color: MyColors.pink,
                        size: 20,
                      ),
                      'Dashboard',
                      () => Get.offAllNamed(AppRoutes.dashBoardScreen)),
                  listTile(
                    const Icon(
                      Icons.select_all_outlined,
                      color: MyColors.pink,
                      size: 20,
                    ),
                    'Sales Order',
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SalesOrderScreen(),
                          ));
                    },
                  ),
                  listTile(
                      const Icon(
                        Icons.groups,
                        color: MyColors.pink,
                        size: 20,
                      ),
                      'Customer',
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerListScreen(),
                            ));

                      }),
                  listTile(
                      const Icon(
                        Icons.category_rounded,
                        color: MyColors.pink,
                        size: 20,
                      ),
                      'Catalogue',
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CatalogueScreen(),
                            ));
                      }),
                  listTile(
                      const Icon(
                        Icons.view_in_ar_sharp,
                        color: MyColors.pink,
                        size: 20,
                      ),
                      'Visited',
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VisitedScreen(),
                          ));
                      }),
                ],
              ),
            ],
          ),
          const Spacer(),
          listTile(
              const Icon(
                Icons.logout_outlined,
                color: MyColors.pink,
                size: 20,
              ),
              'Logout',
              () => Get.offAllNamed(AppRoutes.loginScreen)),
        ],
      ),
    ),
  );
}

ListTile listTile(Widget leading, String name, Function()? onTap) {
  bool isSelected = false;
  return ListTile(
    onTap: onTap,
    leading: leading,
    title: Text(
      name,
      style: TextStyle(
          fontFamily: MyFont.myFont2,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? hexStringToColor('202020')
              : hexStringToColor('5F5F5F')),
    ),
  );
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:JNB/Const/app_route.dart';
// import 'package:JNB/Const/assets.dart';
// import 'package:JNB/Const/colors.dart';
// import 'package:JNB/Const/fonts.dart';
// import 'package:JNB/Const/size.dart';
// import 'package:JNB/Helper/preference_helper.dart';
// import 'package:JNB/Model/login_model.dart';
// import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_screen.dart';
//
// class Drawer extends StatefulWidget {
//   const Drawer({super.key, required double width, required Container child});
//
//   @override
//   State<Drawer> createState() => _DrawerState();
// }
//
// class _DrawerState extends State<Drawer> {
//   int? orgId;
//   String? orgName;
//   String? orgBranch;
//   @override
//   void initState() {
//     getUserData();
//     super.initState();
//   }
//
//   getUserData() async {
//     await PreferenceHelper.getUserData().then((value) => setState(() {
//       orgId = value?.orgId;
//       orgName = value?.organisationName;
//       orgBranch = value?.name;
//     }));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       width: width(context) / 1.3,
//       child: Container(
//         padding: const EdgeInsets.only(left: 10),
//         decoration: BoxDecoration(
//             color: MyColors.white,
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: MyColors.greyBackground)),
//         child: Column(
//           children: [
//             Column(
//               children: [
//                 DrawerHeader(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             GestureDetector(
//                                 onTap: () => Get.back(),
//                                 child: const Icon(
//                                   Icons.arrow_right_alt_rounded,
//                                   color: MyColors.pink,
//                                   size: 30,
//                                 ))
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5),
//                               child: Image.asset(
//                                 Assets.appBarCompIcon,
//                                 scale: .8,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       '$orgName',
//                       style: TextStyle(
//                           fontFamily: MyFont.myFont2,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: MyColors.mainTheme),
//                     ),
//                     SizedBox(
//                       height: height(context) / 50,
//                     ),
//                     Text('$orgBranch',
//                         style: TextStyle(
//                             fontFamily: MyFont.myFont2,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: MyColors.black)),
//                     SizedBox(
//                       height: height(context) / 50,
//                     ),
//                     const Divider(
//                       thickness: 1,
//                       color: MyColors.greyText,
//                     ),
//                     listTile(
//                         const Icon(
//                           Icons.dashboard_customize,
//                           color: MyColors.pink,
//                           size: 20,
//                         ),
//                         'Dashboard',
//                             () => Get.offAllNamed(AppRoutes.dashBoardScreen)),
//                     listTile(
//                       const Icon(
//                         Icons.select_all_outlined,
//                         color: MyColors.pink,
//                         size: 20,
//                       ),
//                       'Sales Order',
//                           () {
//                         Navigator.pop(context);
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SalesOrderScreen(),
//                             ));
//                       },
//                     ),
//                     listTile(
//                         const Icon(
//                           Icons.groups,
//                           color: MyColors.pink,
//                           size: 20,
//                         ),
//                         'Customer',
//                             () => Get.offAllNamed(AppRoutes.customerListScreen)),
//                     listTile(
//                         const Icon(
//                           Icons.category_rounded,
//                           color: MyColors.pink,
//                           size: 20,
//                         ),
//                         'Catalogue',
//                             () => Get.offAllNamed(AppRoutes.catalogueScreen)),
//                     listTile(
//                         const Icon(
//                           Icons.video_collection_sharp,
//                           color: MyColors.pink,
//                           size: 20,
//                         ),
//                         'Visited',
//                             () => Get.offAllNamed(AppRoutes.visitedScreen)),
//                   ],
//                 ),
//               ],
//             ),
//             const Spacer(),
//             listTile(
//                 const Icon(
//                   Icons.logout_outlined,
//                   color: MyColors.pink,
//                   size: 20,
//                 ),
//                 'Logout',
//                     () => Get.offAllNamed(AppRoutes.loginScreen)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// getDrawer(context) async {
//   LoginUser? loginUser;
//   String? companyName;
//   String? companyLogo;
//   String? companyBranch;
//   loginUser = await PreferenceHelper.getUserData();
//
//   return;
// }
//
// listTile(Widget leading, String name, Function()? onTap) {
//   bool isSelected = false;
//   return ListTile(
//     onTap: onTap,
//     leading: leading,
//     title: Text(
//       name,
//       style: TextStyle(
//           fontFamily: MyFont.myFont2,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: isSelected
//               ? hexStringToColor('202020')
//               : hexStringToColor('5F5F5F')),
//     ),
//   );
// }
