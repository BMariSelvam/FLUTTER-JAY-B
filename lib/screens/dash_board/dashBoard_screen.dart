import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/screens/catalogue/catalogue_screen.dart';
import 'package:JNB/screens/customer/customer_list_screen.dart';
import 'package:JNB/screens/sales_order/sales_order_screen/sales_order_screen.dart';
import 'package:JNB/screens/visited/visited_screen.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> dashboardScaffoldKey = GlobalKey<ScaffoldState>();
  String? name;
  String? branchName;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await PreferenceHelper.getUserData().then((value) => setState(() {
          name = value?.name;
        }));
    branchName = await PreferenceHelper.getBranchNameString();
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Do you want to go exit?'),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, true);
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
        key: dashboardScaffoldKey,
        drawer: getDrawer(context, name, branchName),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: MyColors.mainTheme,
          flexibleSpace: Container(),
          leading: GestureDetector(
            onTap: () {
              dashboardScaffoldKey.currentState?.openDrawer();
            },
            child: Image.asset(
              Assets.icon1,
              scale: 1,
            ),
          ),
          title: Image.asset(
            Assets.logo2,
            scale: 5,
            color: MyColors.lightmainTheme2,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Primary Information",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: MyFont.myFont2,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: MyColors.mainTheme,
                  ),
                ),
              ),
              SizedBox(
                height: height(context) / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height(context) / 4.4,
                    width: width(context) / 2.8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SalesOrderScreen(),
                            ));
                      },
                      child: Card(
                        color: MyColors.lightmainTheme2,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: MyColors.white,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 12, top: 12, bottom: 12, right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              children: [
                                Container(
                                    height: height(context) / 12,
                                    width: width(context) / 6,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color: MyColors.white),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.select_all_outlined,
                                      color: MyColors.pink,
                                      size: 30,
                                    )),
                                SizedBox(
                                  height: height(context) / 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Sales Order",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(context) / 4.4,
                    width: width(context) / 2.8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerListScreen(),
                            ));
                      },
                      child: Card(
                        color: MyColors.lightmainTheme2,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: MyColors.white,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 12, top: 12, bottom: 12, right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              children: [
                                Container(
                                  height: height(context) / 12,
                                  width: width(context) / 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      color: MyColors.white),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.groups,
                                    color: MyColors.pink,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) / 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Customer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height(context) / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height(context) / 4.4,
                    width: width(context) / 2.8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CatalogueScreen(),
                            ));
                      },
                      child: Card(
                        color: MyColors.lightmainTheme2,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: MyColors.white,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 12, top: 12, bottom: 12, right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              children: [
                                Container(
                                    height: height(context) / 12,
                                    width: width(context) / 6,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color: MyColors.white),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.category_rounded,
                                      color: MyColors.pink,
                                      size: 30,
                                    )),
                                SizedBox(
                                  height: height(context) / 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Catalogue",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(context) / 4.4,
                    width: width(context) / 2.8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VisitedScreen(),
                            ));
                      },
                      child: Card(
                        color: MyColors.lightmainTheme2,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: MyColors.white,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 12, top: 12, bottom: 12, right: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              children: [
                                Container(
                                  height: height(context) / 12,
                                  width: width(context) / 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      color: MyColors.white),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.view_in_ar_sharp,
                                    color: MyColors.pink,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) / 40,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Visited",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.black,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height(context) / 50,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       height: height(context) / 4.4,
              //       width: width(context) / 2.8,
              //       child: InkWell(
              //         onTap: () {},
              //         child: Card(
              //           color: MyColors.lightmainTheme2,
              //           elevation: 1,
              //           shape: RoundedRectangleBorder(
              //             side: const BorderSide(
              //               color: MyColors.white,
              //             ),
              //             borderRadius:
              //                 BorderRadius.circular(20.0), //<-- SEE HERE
              //           ),
              //           child: Container(
              //               margin: const EdgeInsets.only(
              //                   left: 12, top: 12, bottom: 12, right: 12),
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 10, vertical: 8),
              //               child: Column(
              //                 children: [
              //                   Container(
              //                       height: height(context) / 12,
              //                       width: width(context) / 6,
              //                       decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(200),
              //                           color: MyColors.white),
              //                       alignment: Alignment.center,
              //                       child: const Icon(
              //                         Icons.settings_suggest,
              //                         color: MyColors.pink,
              //                         size: 30,
              //                       )),
              //                   SizedBox(
              //                     height: height(context) / 40,
              //                   ),
              //                   Container(
              //                     alignment: Alignment.center,
              //                     child: Text(
              //                       "Setting",
              //                       textAlign: TextAlign.center,
              //                       style: TextStyle(
              //                         fontFamily: MyFont.myFont2,
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 15,
              //                         color: MyColors.black,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // categoryHeadGrid() {
  //   return Container(
  //     padding: const EdgeInsets.all(10),
  //     margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
  //     child: GridView.builder(
  //         padding: const EdgeInsets.all(0),
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: 4,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           crossAxisSpacing: 15,
  //           mainAxisSpacing: 15,
  //           childAspectRatio: 1,
  //         ),
  //         itemBuilder: (context, index) {
  //           return InkWell(
  //             onTap: () {
  //               Get.toNamed(exploreNewCategories[index].onTap);
  //             },
  //             child: Card(
  //               color: MyColors.white,
  //               elevation: 5,
  //               shadowColor: MyColors.greyText,
  //               shape: RoundedRectangleBorder(
  //                 side: const BorderSide(
  //                   color: MyColors.white,
  //                 ),
  //                 borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
  //               ),
  //               child: Container(
  //                 margin: const EdgeInsets.only(
  //                     left: 12, top: 12, bottom: 12, right: 12),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //                 child: Column(
  //                   children: [
  //                     Container(
  //                         height: height(context) / 12,
  //                         width: width(context) / 6,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(100),
  //                           color: exploreNewCategories[index].color,
  //                         ),
  //                         alignment: Alignment.center,
  //                         child: Image.asset(
  //                           exploreNewCategories[index].image,
  //                           alignment: Alignment.center,
  //                           scale: 2,
  //                         )),
  //                     SizedBox(
  //                       height: height(context) / 40,
  //                     ),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       child: Text(
  //                         exploreNewCategories[index].name,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontFamily: MyFont.myFont,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 15,
  //                           color: MyColors.black,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

  // ListTile listTile(Widget leading, String name, Function()? onTap) {
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
  List<Grid> exploreNewCategories = [
    Grid(
        name: 'Sales Order',
        image: Assets.appBarCompIcon,
        color: MyColors.lightmainTheme,
        onTap: AppRoutes.customerListScreen),
    Grid(
        name: 'Customer',
        image: Assets.appBarCompIcon,
        color: MyColors.lightmainTheme,
        onTap: AppRoutes.customerListScreen),
    Grid(
        name: 'Catalogue',
        image: Assets.appBarCompIcon,
        color: MyColors.lightmainTheme,
        onTap: AppRoutes.customerListScreen),
    Grid(
        name: 'visited',
        image: Assets.appBarCompIcon,
        color: MyColors.lightmainTheme,
        onTap: AppRoutes.customerListScreen),
  ];
}
