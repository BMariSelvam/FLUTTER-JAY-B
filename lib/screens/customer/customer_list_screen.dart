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
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/visied/not_visied_model.dart';
import 'package:JNB/screens/customer/customer_list_screen_controller.dart';
import 'package:JNB/screens/signature/signature_screen.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({
    super.key,
  });

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late CustomerScreenController customerScreenController;
  var item;
  var sortedItems;
  int? selectedRadio;
  bool isNum = false;
  bool isName = false;
  List<String> sort = [
    "Sort by Name",
    "Sort by Code",
  ];
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
  String currentDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
  SignatureCImage? sign;
  String? branchName;
  final _scrollThreshold = 200.0;
  final ScrollController _scrollController = ScrollController();
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
      if (customerScreenController.currentPage <=
              customerScreenController.totalPages &&
          !customerScreenController.status.isLoadingMore) {
        print(
            "=========================================start111111111111111111");
        await customerScreenController.getAllCustomersSearchList(
            name: "", code: "", isPagination: true);
      }
    }
  }

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
    return customerScreenController.notVisitedListModel.value!.where((item) {
      return item.customerName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    locationPermission(context);
    getUserData();
    customerScreenController = Get.put(CustomerScreenController());
    customerScreenController.currentPage = 1;
    customerScreenController.getAllCustomersSearchList(
        name: "", code: "", isPagination: false);
    _scrollController.addListener(_scrollListener);
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerScreenController>(builder: (logic) {
      if (customerScreenController.status.isLoading) {
        return Container(
          color: MyColors.tpt,
          child: Center(child: PreferenceHelper.showLoader()),
        );
      }
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        // onWillPop: () async {
        //   final shouldPop = await showDialog<bool>(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: const Text('Do you want to go Dashboard?'),
        //         actionsAlignment: MainAxisAlignment.spaceAround,
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               setState(() {
        //                 Get.offAllNamed(AppRoutes.dashBoardScreen);
        //               });
        //             },
        //             child: const Text('Yes'),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               setState(() {
        //                 Navigator.pop(context);
        //                 // Get.offAndToNamed(AppRoutes.bottomNavBar0);
        //               });
        //             },
        //             child: const Text('No'),
        //           ),
        //         ],
        //       );
        //     },
        //   );
        //   return shouldPop!;

        // },
        child: Scaffold(
          key: customerScreenController.customerScaffoldKey,
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
                suffixIcon: GestureDetector(
                  onTap: () {
                    customerScreenController.searchcontroller.clear();
                    customerScreenController.currentPage = 1;
                    customerScreenController.getAllCustomersSearchList(
                        name: "", code: "", isPagination: false);
                  },
                  child: const Icon(
                    Icons.clear,
                    color: MyColors.pink,
                  ),
                ),
                controller: customerScreenController.searchcontroller,
                inputBorder: InputBorder.none,
                onChanged: (value) {
                  customerScreenController.currentPage = 1;
                  customerScreenController.getAllCustomersSearchList(
                      name: value, code: "", isPagination: false);
                  if (value.isEmpty && value == null) {
                    customerScreenController.currentPage = 1;
                    customerScreenController.getAllCustomersSearchList(
                        name: "", code: "", isPagination: false);
                  }
                },
              ),
            ),
            centerTitle: true,
            toolbarHeight: 100,
            elevation: 0,
            backgroundColor: MyColors.mainTheme,
            leading: GestureDetector(
              onTap: () {
                customerScreenController.customerScaffoldKey.currentState
                    ?.openDrawer();
              },
              child: Image.asset(
                Assets.icon1,
                scale: 1,
              ),
            ),
            title: Image.asset(
              Assets.logo2,
              scale: 5,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    bottomFilterListProduct();
                  },
                  child: const Icon(Icons.format_list_numbered_rtl_rounded,
                      color: MyColors.greyIcon),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: list(),
            ),
          ),
        ),
      );
    });
  }

  list() {
    if ((customerScreenController.customerListModel.isNotEmpty)) {
      return Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: customerScreenController.customerListModel.length,
            itemBuilder: (context, index) {
              if (selectedRadio == 0) {
                sortedItems = customerScreenController.customerListModel;
                item = sortedItems?[index];
              } else if (selectedRadio == 1) {
                sortedItems = customerScreenController.customerListModel
                  ..sort((item1, item2) => item1.code!.compareTo(item2.code!));
                item = sortedItems?[index];
              } else {
                sortedItems = customerScreenController.customerListModel
                  ..sort((item1, item2) => item1.name!.compareTo(item2.name!));
                item = sortedItems?[index];
              }

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
                            item?.name ?? "",
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
                              editPopupMenuButton(
                                  context,
                                  customerScreenController
                                      .customerListModel[index],
                                  index),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Code       : ",
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Address  : ",
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
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: SizedBox(
                                    width: width(context) / 1.9,
                                    child: Text(
                                      item?.code ?? "",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: MyFont.myFont2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          color: MyColors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 10),
                                  child: SizedBox(
                                    width: width(context) / 1.9,
                                    child: Text(
                                      "${item?.addressLine1 ?? ""}"
                                      "${item?.addressLine2 ?? ""}"
                                      "${item?.addressLine3 ?? ""}",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: MyFont.myFont2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          color: MyColors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          if (customerScreenController.status.isLoadingMore)
            Container(
              color: MyColors.white,
              child: Center(child: PreferenceHelper.showLoader()),
            ),
        ],
      );
    } else {
      if (customerScreenController.status.isLoadingMore ||
          customerScreenController.status.isLoading) {
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

  bottomFilterListProduct() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            height: 155,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      title: const Text('Sort by Code'),
                      trailing: Radio<int>(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: MyColors
                            .mainTheme, // Change the active radio button color here
                        fillColor: MaterialStateProperty.all(MyColors
                            .mainTheme), // Change the fill color when selected
                        splashRadius:
                            20, // Change the splash radius when clicked
                        onChanged: (value) async {
                          setState(() {
                            selectedRadio = value;
                          });
                          await customerScreenController
                              .getAllCustomersSearchList(
                                  name: "", code: "", isPagination: false)
                              .then((value) => Get.back());
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      title: const Text('Sort by Name'),
                      trailing: Radio<int>(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: MyColors
                            .mainTheme, // Change the active radio button color here
                        fillColor: MaterialStateProperty.all(MyColors
                            .mainTheme), // Change the fill color when selected
                        splashRadius:
                            20, // Change the splash radius when clicked
                        onChanged: (value) async {
                          setState(() {
                            selectedRadio = value;
                          });
                          await customerScreenController
                              .getAllCustomersSearchList(
                                  name: "", code: "", isPagination: false)
                              .then((value) => Get.back());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  bottomAboutProducts(context, CustomerListModel customerListModel) {
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
                              customerListModel.name ?? "",
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
                          height: height(context) / 8,
                          child: CustomTextField2(
                            filled: false,
                            readOnly: false,
                            maxLines: 7,
                            inputBorder: const OutlineInputBorder(),
                            controller:
                                customerScreenController.remarkController,
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
                              // onTap: () {
                              //   if (customerScreenController
                              //           .remarkController.text ==
                              //       "") {
                              //     Get.showSnackbar(
                              //       const GetSnackBar(
                              //         margin: EdgeInsets.all(10),
                              //         borderRadius: 10,
                              //         backgroundColor: Colors.red,
                              //         snackPosition: SnackPosition.TOP,
                              //         message: "Please Completed all field",
                              //         icon: Icon(
                              //           Icons.error,
                              //           color: Colors.white,
                              //         ),
                              //         duration: Duration(seconds: 1),
                              //       ),
                              //     );
                              //   } else {
                              //     customerScreenController
                              //             .getAllNotVisitedListModel =
                              //         GetAllNotVisitedListModel(
                              //       orgId: orgId,
                              //       visitedNo: 0,
                              //       visitedDate: currentDate,
                              //       remarks: customerScreenController
                              //           .remarkController.text,
                              //       changedBy: "admin",
                              //       createdOn: currentDate,
                              //       createdBy: "admin",
                              //       changedOn: currentDate,
                              //       tranType: "V",
                              //       customerCode: customerListModel.code ?? "",
                              //       customerName: customerListModel.name ?? "",
                              //       tranNo: customerScreenController
                              //               .getAllNotVisitedListModel
                              //               ?.tranNo ??
                              //           "",
                              //       latitude: _currentPosition?.latitude,
                              //       longitude: _currentPosition?.longitude,
                              //       customerSign: customerSignature,
                              //       userSign: userSignature,
                              //       addressLine1:
                              //           customerListModel.addressLine1 ?? "",
                              //       addressLine2:
                              //           customerListModel.addressLine2 ?? "",
                              //       addressLine3:
                              //           customerListModel.addressLine3 ?? "",
                              //     );
                              //     customerScreenController
                              //         .createCustomerVisitedApi();
                              //
                              //     Get.showSnackbar(
                              //       GetSnackBar(
                              //         margin: const EdgeInsets.all(10),
                              //         borderRadius: 10,
                              //         backgroundColor: Colors.green,
                              //         snackPosition: SnackPosition.TOP,
                              //         message: "${customerListModel.code}"
                              //             "Visited SucessFully",
                              //         icon: const Icon(
                              //           Icons.check,
                              //           color: Colors.white,
                              //         ),
                              //         duration: const Duration(seconds: 2),
                              //       ),
                              //     );
                              //     customerScreenController
                              //         .getAllVisitedNotVisitedCustomersList(
                              //             currentDate);
                              //   }
                              // },
                              onTap: () async {
                                if (customerScreenController
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
                                  customerScreenController
                                          .getAllNotVisitedListModel =
                                      GetAllNotVisitedListModel(
                                    orgId: orgId,
                                    visitedNo: 0,
                                    visitedDate: currentDate,
                                    remarks: customerScreenController
                                        .remarkController.text,
                                    changedBy: "admin",
                                    createdOn: currentDate,
                                    createdBy: "admin",
                                    changedOn: currentDate,
                                    tranType: "V",
                                    customerCode: customerListModel.code ?? "",
                                    customerName: customerListModel.name ?? "",
                                    tranNo: customerScreenController.tranNo,
                                    latitude: _currentPosition?.latitude,
                                    longitude: _currentPosition?.longitude,
                                    customerSign: customerSignature ?? "",
                                    userSign: userSignature ?? "",
                                    addressLine1:
                                        customerListModel.addressLine1 ?? "",
                                    addressLine2:
                                        customerListModel.addressLine2 ?? "",
                                    addressLine3:
                                        customerListModel.addressLine3 ?? "",
                                  );
                                  await customerScreenController
                                      .createCustomerVisitedApi();
                                  customerScreenController
                                      .getAllVisitedNotVisitedCustomersList(
                                          currentDate);
                                  customerScreenController.clear();
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

  //ImagePicker
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

  editPopupMenuButton(context, CustomerListModel customerListModel, index) {
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
          color: MyColors.mainTheme,
        ),
        offset: const Offset(0, 30),
        itemBuilder: (_) => <PopupMenuEntry>[
          PopupMenuItem(
              onTap: () {
                Navigator.pop(context);
                Get.offAndToNamed(AppRoutes.bottomNavBar,
                    arguments: customerListModel.code);
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
                      'Sales Order',
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
              )),
          PopupMenuItem(
              onTap: () {
                // Navigator.pop(context);
                bottomAboutProducts(context, customerListModel);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const Icon(
                      Icons.view_in_ar_sharp,
                      color: MyColors.pink,
                    ),
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
                  ]),
                ],
              )),
          // PopupMenuItem(
          //     child: GestureDetector(
          //   onTap: () {},
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          //         const Icon(
          //           Icons.location_on_outlined,
          //           color: MyColors.pink,
          //         ),
          //         SizedBox(
          //           width: width(context) / 30,
          //         ),
          //         Text(
          //           'Location',
          //           style: TextStyle(
          //               fontFamily: MyFont.myFont2,
          //               fontWeight: FontWeight.w900,
          //               fontSize: 15,
          //               color: MyColors.mainTheme),
          //         ),
          //       ]),
          //       const Divider(
          //         thickness: 1,
          //       ),
          //     ],
          //   ),
          // )),
          // PopupMenuItem(
          //   child: GestureDetector(
          //     onTap: () {
          //       customerScreenController.customerListModel.removeAt(index);
          //     },
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             const Icon(
          //               Icons.delete_outline_rounded,
          //               color: MyColors.pink,
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
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
