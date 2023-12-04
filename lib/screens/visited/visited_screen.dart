import 'dart:convert';
import 'dart:io';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Custom_widgets/custom_textField_2.dart';
import 'package:JNB/Custom_widgets/search_textField.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/visied/not_visied_model.dart';
import 'package:JNB/screens/signature/signature_screen.dart';
import 'package:JNB/screens/visited/visited_screen_controller.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class VisitedScreen extends StatefulWidget {
  const VisitedScreen({
    super.key,
  });

  @override
  State<VisitedScreen> createState() => _VisitedScreenState();
}

class _VisitedScreenState extends State<VisitedScreen> {
  late VisitedScreenController visitedScreenController;
  String orderDate = "";
  String currentAddress = "";
  XFile? pickedFile;
  final geoLocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? _currentPosition;
  String? customerSignature;
  String? userSignature;
  int? orgId;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? name;
  String? userRolecode;
  String? uniqueNo;
  String? orgName;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _scrollThreshold = 200.0;
  final ScrollController _scrollController = ScrollController();

  SignatureCImage? sign;

  String? branchName;
  getUserData() async {
    await PreferenceHelper.getUserData().then((value) => setState(() {
          name = value?.name;
          orgId = value?.orgId;
          userRolecode = value?.userRolecode;
          orgName = value?.organisationName;
          uniqueNo = value?.uniqueNo;
          addressLine1 = value?.addressLine1;
          addressLine2 = value?.addressLine2;
          addressLine3 = value?.addressLine3;
        }));
    branchName = await PreferenceHelper.getBranchNameString();
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

  String search = "";
  List<GetAllNotVisitedListModel> filterList(String query) {
    return visitedScreenController.notVisitedListModel.where((item) {
      return item.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print("=========================================start");
      if (visitedScreenController.currentPage <=
              visitedScreenController.totalPages &&
          !visitedScreenController.status.isLoadingMore) {
        print(
            "=========================================start111111111111111111");
        await visitedScreenController.getAllVisitedNotVisitedCustomersList(
            currentDate: currentDate, isPagination: true,code: "",name: "");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    locationPermission(context);
    getUserData();
    visitedScreenController = Get.put(VisitedScreenController());
    visitedScreenController.currentPage = 1;
    visitedScreenController.getAllVisitedNotVisitedCustomersList(
        currentDate: currentDate, isPagination: false,code: "",name: "");
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    locationPermission(context);
    getUserData();
    visitedScreenController = Get.put(VisitedScreenController());
    visitedScreenController.currentPage = 1;
    visitedScreenController.getAllVisitedNotVisitedCustomersList(
        currentDate: currentDate, isPagination: false,code: "",name: "");
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VisitedScreenController>(builder: (logic) {
      if (visitedScreenController.status.isLoading) {
        return Container(
          color: MyColors.white,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return SafeArea(
          child: Scaffold(
        key: visitedScreenController.visitedScaffoldKey,
        resizeToAvoidBottomInset: false,
        drawer: getDrawer(context, name, branchName),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SearchTextField(
              keyboardType: TextInputType.text,
              hintText: "Search Customer",
              prefixIcon: const Icon(
                Icons.search,
                color: MyColors.pink,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  visitedScreenController.searchController.clear();
                  visitedScreenController.currentPage = 1;
                  visitedScreenController.getAllVisitedNotVisitedCustomersList(
                    name: "", code: "", isPagination: false,currentDate: currentDate,);
                },
                child: const Icon(
                  Icons.clear,
                  color: MyColors.pink,
                ),
              ),
              controller: visitedScreenController.searchController,
              inputBorder: InputBorder.none,
              onChanged: (String value) {
                visitedScreenController.currentPage = 1;
                  visitedScreenController.getAllVisitedNotVisitedCustomersList(
                      currentDate: currentDate, isPagination: false,code: "",name: value);
      if (value.isEmpty && value == null) {
        visitedScreenController.currentPage = 1;
        visitedScreenController.getAllVisitedNotVisitedCustomersList(
            name: "", code: "", isPagination: false,currentDate: currentDate,);
      }
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
              visitedScreenController.visitedScaffoldKey.currentState
                  ?.openDrawer();
            },
            child: Image.asset(
              Assets.icon1,
              scale: 1,
            ),
          ),
          title: Text('Visited',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFont.myFont2,
                  color: MyColors.white)),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  visitedScreenController.isVisited.value =
                      !visitedScreenController.isVisited.value;
                });
                visitedScreenController.selectedmoledl = visitedScreenController
                    .notVisitedListModel
                    .where((element) => element.visitedDate != null)
                    .toList();
                print("visitedScreenController.selectedmoledl");
                print(visitedScreenController.selectedmoledl.length);
              },
              child: Icon(
                  visitedScreenController.isVisited.value
                      ? Icons.filter_alt_outlined
                      : Icons.filter_alt_off_outlined,
                  color: MyColors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () async {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    setState(() {
                      visitedScreenController.orderDate = value!;
                      orderDate =
                          '${visitedScreenController.orderDate.day}-${visitedScreenController.orderDate.month}-${visitedScreenController.orderDate.year}';
                      orderDate =
                          '${visitedScreenController.orderDate.year}-${visitedScreenController.orderDate.month}-${visitedScreenController.orderDate.day}';
                      visitedScreenController
                          .getAllVisitedNotVisitedCustomersList(
                              currentDate: orderDate, isPagination: false,code: "",name: "");
                      print(orderDate);
                    });
                  });
                },
                child: const Icon(Icons.calendar_month_rounded,
                    color: MyColors.white),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: list(),
          ),
        ),
      ));
    });
  }

  list() {
    if (visitedScreenController.notVisitedListModel.isNotEmpty &&
        filterList(search).isNotEmpty) {
      return Column(
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: visitedScreenController.isVisited.value
                  ? (search.isEmpty
                      ? visitedScreenController.notVisitedListModel.length
                      : filterList(search).length)
                  : visitedScreenController.selectedmoledl.length,
              itemBuilder: (context, index) {
                final item = visitedScreenController.isVisited.value
                    ? (search.isEmpty
                        ? visitedScreenController.notVisitedListModel[index]
                        : filterList(search)[index])
                    : visitedScreenController.selectedmoledl[index];

                String visitedDate = item.visitedDate ?? "";

                return Container(
                  decoration: BoxDecoration(
                    color: item.visitedDate != null
                        ? MyColors.visitedClr
                        : MyColors.notVisitedClr,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width(context) / 2,
                            child: Text(
                              item.customerName ?? "No customer Name",
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
                              color: MyColors.mainTheme,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                editPopupMenu3Button(context, item),
                              ],
                            ),
                          )
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
                                child: Text(
                                  "Code",
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
                                " : ",
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
                            child: Text(
                              item.customerCode ?? "No Customer Code",
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
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child:
                                Icon(Icons.location_on, color: MyColors.pink),
                          ),
                          SizedBox(width: width(context) / 40),
                          SizedBox(
                            width: width(context) / 1.4,
                            child: Text(
                              "${item.addressLine1}"
                              ","
                              "${item.addressLine2}"
                              ","
                              "${item.addressLine3}",
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
                      item.visitedDate != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        "Visited Date",
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
                                      " : ",
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
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    visitedDate.substring(0, 10),
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: MyFont.myFont2,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        color: MyColors.black),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    child: Text(
                                      "Trans No.",
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
                                    " : ",
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
                                child: Text(
                                  item.tranNo ?? "",
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
                          item.visitedDate != null
                              ? Text(
                                  "Visited",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      letterSpacing: 0.5,
                                      color: MyColors.mainTheme),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          if (visitedScreenController.status.isLoadingMore)
            Container(
              color: MyColors.white,
              child: Center(child: PreferenceHelper.showLoader()),
            ),
        ],
      );
    } else {
      if (visitedScreenController.status.isLoadingMore ||
          visitedScreenController.status.isLoading) {
        return Container();
      }
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 150),
          child: Text("No Data Found"),
        ),
      );
    }
  }

  editPopupMenu3Button(
      context, GetAllNotVisitedListModel getAllNotVisitedListModel) {
    return SizedBox(
      height: 25,
      width: 28,
      child: PopupMenuButton(
        splashRadius: 10,
        color: MyColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            width: 2,
            color: MyColors.lightmainTheme,
          ),
        ),
        iconSize: 25,
        padding: const EdgeInsets.all(1),
        icon: const Icon(
          Icons.arrow_drop_down_rounded,
          color: MyColors.white,
        ),
        offset: const Offset(0, 30),
        itemBuilder: (_) => <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () {
              Navigator.pop(context);
              Get.offAndToNamed(AppRoutes.bottomNavBar,
                  arguments: getAllNotVisitedListModel.customerCode);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Icon(
                    Icons.select_all_outlined,
                    color: MyColors.pink,
                  ),
                  SizedBox(
                    width: width(context) / 30,
                  ),
                  Text(
                    'Sales Order ',
                    style: TextStyle(
                        fontFamily: MyFont.myFont2,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: MyColors.mainTheme),
                  ),
                ]),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
          // PopupMenuItem(
          //   child: GestureDetector(
          //     onTap: () async {
          //       if (getAllNotVisitedListModel.visitedDate != null) {
          //         await visitedScreenController.getAllVisitedCustomersListCode(
          //             getAllNotVisitedListModel.customerCode);
          //       }
          //       if (getAllNotVisitedListModel.visitedDate != null &&
          //           visitedScreenController.data != null) {
          //         bottomAboutProduct(context, visitedScreenController.data!);
          //       }
          //     },
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //           Icon(
          //             Icons.view_kanban_outlined,
          //             color: getAllNotVisitedListModel.visitedDate != null
          //                 ? MyColors.pink
          //                 : MyColors.pink.withOpacity(0.5),
          //           ),
          //           SizedBox(
          //             width: width(context) / 30,
          //           ),
          //           Text(
          //             'View Visited',
          //             style: TextStyle(
          //                 fontFamily: MyFont.myFont2,
          //                 fontWeight: FontWeight.w900,
          //                 fontSize: 15,
          //                 color: getAllNotVisitedListModel.visitedDate != null
          //                     ? MyColors.mainTheme
          //                     : MyColors.mainTheme.withOpacity(0.5)),
          //           ),
          //         ]),
          //         const Divider(
          //           thickness: 1,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          PopupMenuItem(
            onTap: () {
              // if (getAllNotVisitedListModel.visitedDate == null) {
              //   Navigator.pop(context);
              //   bottomAboutProduct(context, getAllNotVisitedListModel);
              // }
              // Navigator.pop(context);
              bottomAboutProduct(context, getAllNotVisitedListModel);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(
                    //   Icons.view_in_ar_sharp,
                    //   color: getAllNotVisitedListModel.visitedDate == null
                    //       ? MyColors.pink
                    //       : MyColors.pink.withOpacity(0.5),
                    // ),
                    const Icon(Icons.view_in_ar_sharp, color: MyColors.pink),
                    SizedBox(
                      width: width(context) / 30,
                    ),
                    Text(
                      'Visited',
                      style: TextStyle(
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: MyColors.mainTheme),
                    ),
                  ],
                ),
                // const Divider(
                //   thickness: 1,
                // ),
              ],
            ),
          ),
          // PopupMenuItem(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           const Icon(
          //             Icons.location_on_outlined,
          //             color: MyColors.pink,
          //           ),
          //           SizedBox(
          //             width: width(context) / 30,
          //           ),
          //           Text(
          //             'Location',
          //             style: TextStyle(
          //                 fontFamily: MyFont.myFont2,
          //                 fontWeight: FontWeight.w900,
          //                 fontSize: 15,
          //                 color: MyColors.mainTheme),
          //           ),
          //         ],
          //       ),
          //       const Divider(
          //         thickness: 1,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  bottomAboutProduct(
      context, GetAllNotVisitedListModel getAllNotVisitedListModel) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: MyColors.mainTheme,
                      ),
                      height: 50,
                      width: width(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width(context) / 1.2,
                            child: Text(
                              getAllNotVisitedListModel.customerName ?? "",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: MyColors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.clear,
                                color: MyColors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height(context) / 40,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height(context) / 80,
                        ),
                        SizedBox(
                          height: height(context) / 8,
                          child: CustomTextField2(
                            filled: false,
                            readOnly: false,
                            maxLines: 7,
                            inputBorder: const OutlineInputBorder(),
                            controller:
                                visitedScreenController.remarkController,
                            keyboardType: TextInputType.text,
                            labelText: "Remark",
                            hintText: "Text Here",
                            suffixIcon: const Icon(
                              Icons.edit,
                              color: MyColors.mainTheme,
                              size: 18,
                            ),
                          ),
                        ),
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
                        //           "Signature",
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
                                    border:
                                        Border.all(color: MyColors.greyText),
                                    borderRadius: BorderRadius.circular(20),
                                    color: MyColors.white),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      border:
                                          Border.all(color: MyColors.greyText),
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
                                      sign = value as SignatureCImage;
                                      Uint8List customerSignatureUint8List =
                                          Uint8List.fromList(sign!
                                              .customerSignatureExportedImage!);
                                      customerSignature = base64Encode(
                                          customerSignatureUint8List);
                                      Uint8List userSignatureUint8List =
                                          Uint8List.fromList(sign!
                                              .userSignatureExportedImage!);
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
                                        border: Border.all(
                                            color: MyColors.greyText),
                                        borderRadius: BorderRadius.circular(20),
                                        color: MyColors.white),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 05, horizontal: 20),
                                    child: (sign?.userSignatureExportedImage !=
                                                null &&
                                            sign?.customerSignatureExportedImage !=
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
                                                  sign!
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
                                                  sign!
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
                        SizedBox(
                          height: height(context) / 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  Get.back();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: MyColors.pink),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 35),
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: MyFont.myFont2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: MyColors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                if (visitedScreenController
                                        .remarkController.text ==
                                    "") {
                                  Get.showSnackbar(
                                    const GetSnackBar(
                                      margin: EdgeInsets.all(10),
                                      borderRadius: 10,
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.TOP,
                                      message: "Please Completed all field",
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  visitedScreenController
                                          .getAllNotVisitedListModel =
                                      GetAllNotVisitedListModel(
                                    orgId: orgId,
                                    visitedNo: 0,
                                    visitedDate: currentDate,
                                    remarks: visitedScreenController
                                        .remarkController.text,
                                    changedBy: "admin",
                                    createdOn: currentDate,
                                    createdBy: "admin",
                                    changedOn: currentDate,
                                    tranType: "V",
                                    customerCode:
                                        getAllNotVisitedListModel.customerCode,
                                    customerName:
                                        getAllNotVisitedListModel.customerName,
                                    tranNo: getAllNotVisitedListModel.tranNo,
                                    latitude: _currentPosition?.latitude,
                                    longitude: _currentPosition?.longitude,
                                    customerSign: customerSignature ?? "",
                                    userSign: userSignature ?? "",
                                    addressLine1:
                                        getAllNotVisitedListModel.addressLine1,
                                    addressLine2:
                                        getAllNotVisitedListModel.addressLine2,
                                    addressLine3:
                                        getAllNotVisitedListModel.addressLine3,
                                  );
                                  visitedScreenController
                                      .createCustomerVisitedApi();
                                  Navigator.pop(context);
                                  visitedScreenController.currentPage = 1;
                                  visitedScreenController
                                      .getAllVisitedNotVisitedCustomersList(
                                          currentDate: currentDate,
                                          isPagination: false,code: "",name: "");

                                  Get.showSnackbar(
                                    GetSnackBar(
                                      margin: const EdgeInsets.all(10),
                                      borderRadius: 10,
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.TOP,
                                      message:
                                          "${getAllNotVisitedListModel.customerCode}"
                                          "Visited SucessFully",
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  // visitedScreenController
                                  //     .getAllVisitedNotVisitedCustomersList(
                                  //         currentDate: currentDate,
                                  //         isPagination: false);
                                  visitedScreenController.clear();
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
                          height: 18,
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  // //ImagePicker
  // _showDialogToGetImage(BuildContext context) {
  //   // set up the buttons
  //   Widget cameraButton = InkWell(
  //     onTap: () {
  //       _getImage(true);
  //       Navigator.of(context).pop();
  //     },
  //     child: const Padding(
  //       padding: EdgeInsets.all(15),
  //       child: Icon(Icons.camera_alt_outlined, size: 40),
  //     ),
  //   );
  //
  //   Widget Clear = InkWell(
  //     onTap: () {
  //       Navigator.of(context).pop();
  //     },
  //     child: const Icon(Icons.clear_rounded),
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [const Text("Click Image"), Clear],
  //       ),
  //     ),
  //     content: cameraButton,
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

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
}
