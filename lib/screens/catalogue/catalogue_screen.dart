import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Custom_widgets/custom_button.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/screens/cart/cart_screen.dart';
import 'package:JNB/screens/catalogue/catalogue_controller.dart';
import 'package:JNB/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({Key? key}) : super(key: key);

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  List<filterCategory> filterCategoryList = [
    filterCategory(1, "Category"),
    filterCategory(2, "Sub Category"),
    // filterCategory(3, "Brand"),
  ];
  String? category = "";
  String? subCategory;
  String? subCategoryCode = "";
  String? brand = "";
  int? categorySelectedRadio;
  int? subcategorySelectedRadio;
  int? brandSelectedRadio;

  late ProductController productController;
  var code;
  final _scrollThreshold = 200.0;
  final ScrollController _scrollController = ScrollController();
  int selectedId = 1;
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
      if (productController.currentPage <= productController.totalPages &&
          !productController.status.isLoadingMore) {
        print(
            "=========================================start111111111111111111");
        await productController.getProductList("", "", isPagination: true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    productController = Get.put(ProductController());
    int selectedId = 1;
    _scrollController.addListener(_scrollListener);
    productController.currentPage = 1;
    productController.getProductList("", "", isPagination: false).then((value) {
      productController.getCategoryList();
      productController.getBrandList();
    });
    productController.subCategoryListModel.value = [];
    categorySelectedRadio;
    subcategorySelectedRadio;
    brandSelectedRadio;
    selectedId = 0;
    productController.productService.productListChangeStream.listen((_) {
      setState(() {});
    });
  }

  String? name;
  String? branchName;

  getUserData() async {
    await PreferenceHelper.getUserData().then((value) => setState(() {
          name = value?.name;
        }));
    branchName = await PreferenceHelper.getBranchNameString();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: productController,
        builder: (logic) {
          if (productController.status.isLoading) {
            return Container(
              color: MyColors.white,
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
              key: productController.catalogueScaffoldKey,
              drawer: getDrawer(context, name, branchName),
              appBar: AppBar(
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () {
                      bottomFilterSheet();
                    },
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: MyColors.white,
                      size: 25,
                    ),
                  ),
                  buildAppBarCartButton()
                ],
                toolbarHeight: 80,
                elevation: 0,
                backgroundColor: MyColors.mainTheme,
                flexibleSpace: Container(),
                leading: GestureDetector(
                  onTap: () {
                    productController.catalogueScaffoldKey.currentState
                        ?.openDrawer();
                  },
                  child: Image.asset(
                    Assets.icon1,
                    scale: 1,
                  ),
                ),
                title: Text('Catalogue',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: MyFont.myFont2,
                        color: MyColors.white)),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Column(
                      children: [_productListView()],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _productListView() {
    return Obx(() {
      if ((productController.productListModel.isNotEmpty)) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: productController.productListModel.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .7,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: const BoxDecoration(
                          color: MyColors.lightmainTheme2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height(context) / 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                productController.selectedIndex.value = index;
                                bottomAboutProduct(
                                    productController.productListModel[index]);
                              },
                              child: Image.asset(
                                Assets.noimage,
                                scale: 3,
                                height: 80,
                                width: 80,
                              ),
                            ),
                            SizedBox(
                              height: height(context) / 50,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              alignment: Alignment.center,
                              child: Text(
                                productController
                                        .productListModel[index].name ??
                                    "No Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: MyColors.mainTheme,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height(context) / 50,
                            ),
                            CustomButton(
                              color: MyColors.pink,
                              onTap: () {
                                productController.selectedIndex.value = index;
                                Get.toNamed(AppRoutes.addCatalogue,
                                    arguments: productController
                                        .productListModel[index]);
                              },
                              title: 'Add',
                            ),
                            SizedBox(
                              height: height(context) / 50,
                            ),
                          ],
                        ));
                  }),
            ),
            if (productController.status.isLoadingMore)
              Container(
                color: MyColors.white,
                child: Center(child: PreferenceHelper.showLoader()),
              ),
          ],
        );
      } else if (productController.status.isLoadingMore ||
          productController.status.isLoading) {
           return Center(child: CircularProgressIndicator(),);
        if (productController.status.isLoadingMore ||
            productController.status.isLoading) {
          return Container();
        }
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 150),
            child: Text("No product Found"),
          ),
        );
      } else {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 150),
            child: Text("No product Found"),
          ),
        );
      }
    });
  }

  bottomFilterSheet() {
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
            return Container(
              color: MyColors.white,
              height: height(context) / 1.7,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Card(
                              elevation: 0,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: filterCategoryList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedId =
                                              filterCategoryList[index].id;
                                        });
                                      },
                                      child: Container(
                                        color: selectedId ==
                                                filterCategoryList[index].id
                                            ? MyColors.mainTheme
                                            : MyColors.lightmainTheme,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15,
                                              bottom: 15),
                                          child: Text(
                                            filterCategoryList[index].name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 0.5,
                                              color: selectedId ==
                                                      filterCategoryList[index]
                                                          .id
                                                  ? MyColors.white
                                                  : MyColors.mainTheme,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildRightView(selectedId),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: MyColors.white,
                        height: 30,
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              color: MyColors.pink,
                              onTap: () {
                                productController.currentPage =  1;
                                productController.getProductList("", "", isPagination: false);
                                Get.back();
                              },
                              title: 'Clear',
                            ),
                            CustomButton(
                              color: MyColors.pink,
                              onTap: () {
                                productController.currentPage = 1;
                                productController.getProductList(
                                    "$category", "$subCategoryCode",
                                    isPagination: false);
                                Get.back();
                              },
                              title: 'Apply',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Widget _buildRightView(int id) {
    switch (id) {
      case 1:
        return _buildCategoryListWidget();
      case 2:
        return (productController.subCategoryListModel.value!.isEmpty &&
                productController.subCategoryListModel.value == null &&
                productController.subCategoryListModel.value?.first.code ==
                    null &&
                productController
                    .subCategoryListModel.value!.first.code!.isEmpty)
            ? Container(
                color: Colors.white,
                height: 10,
                width: 10,
              )
            : _buildSubCategoryListWidget();
      // case 3:
      //   return _buildBrandListWidget();
      default:
        return _buildCategoryListWidget();
    }
  }

  Widget _buildCategoryListWidget() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    color: Colors.grey,
                  );
                },
                itemCount:
                    productController.categoryListModel.value?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        productController
                                .categoryListModel.value?[index].code ??
                            "",
                        style: TextStyle(
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: MyColors.black,
                        )),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: categorySelectedRadio,
                      activeColor: MyColors
                          .white, // Change the active radio button color here
                      fillColor: MaterialStateProperty.all(MyColors
                          .mainTheme), // Change the fill color when selected
                      splashRadius: 20, // Change the splash radius when clicked
                      onChanged: (value) async {
                        setState(() {
                          categorySelectedRadio = value;
                          category = productController.categoryListModel.value?[index].code ?? "";
                          productController.subCategoryListModel.value = [];
                          subCategoryCode = "";
                          subcategorySelectedRadio=0;
                        });
                        await productController.getSubCategoryCodeList("$category");
                      },
                    ),
                  );
                }),
          ),
        ],
      );
    });
  }

  Widget _buildSubCategoryListWidget() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return (productController.subCategoryListModel.value!.isEmpty &&
              productController.subCategoryListModel.value == null &&
              productController.subCategoryListModel.value?.first.code ==
                  null &&
              productController.subCategoryListModel.value!.first.code!.isEmpty)
          ? Container(
              color: Colors.white,
              height: 10,
              width: 10,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          color: Colors.grey,
                        );
                      },
                      itemCount: productController
                              .subCategoryListModel.value?.length ??
                          0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              productController.subCategoryListModel
                                      .value?[index].name ??
                                  "",
                              style: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: MyColors.black,
                              )),
                          trailing: (productController
                                      .subCategoryListModel.value!.isEmpty &&
                                  productController
                                          .subCategoryListModel.value ==
                                      null &&
                                  productController.subCategoryListModel
                                          .value?[index].code ==
                                      null &&
                                  productController.subCategoryListModel
                                      .value![index].code!.isEmpty)
                              ? Container(
                                  color: Colors.white,
                                  height: 10,
                                  width: 10,
                                )
                              : Radio<int>(
                                  value: index,
                                  groupValue: subcategorySelectedRadio,
                                  activeColor: MyColors
                                      .white, // Change the active radio button color here
                                  fillColor: MaterialStateProperty.all(MyColors
                                      .mainTheme), // Change the fill color when selected
                                  splashRadius:
                                      20, // Change the splash radius when clicked
                                  onChanged: (value) {
                                    setState(() {
                                      subcategorySelectedRadio = value;
                                      subCategory = productController
                                          .subCategoryListModel
                                          .value?[index]
                                          .name!;
                                      subCategoryCode = productController
                                              .subCategoryListModel
                                              .value?[index]
                                              .code ??
                                          "";
                                    });
                                    print("sssssssssssss");
                                    // productController.currentPage = 1;
                                    // productController.getProductList(
                                    //     "$category", "$subCategoryCode", "",
                                    //     isPagination: false);
                                  },
                                ),
                        );
                      }),
                ),
              ],
            );
    });
  }

  Widget _buildBrandListWidget() {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    color: Colors.grey,
                  );
                },
                itemCount: productController.brandListModel.value?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        productController.brandListModel.value?[index].name ??
                            "",
                        style: TextStyle(
                          fontFamily: MyFont.myFont2,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                          color: MyColors.black,
                        )),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: brandSelectedRadio,
                      activeColor: MyColors
                          .white, // Change the active radio button color here
                      fillColor: MaterialStateProperty.all(MyColors
                          .mainTheme), // Change the fill color when selected
                      splashRadius: 20, // Change the splash radius when clicked
                      onChanged: (value) {
                        setState(() {
                          brandSelectedRadio = value;
                          brand = productController
                                  .brandListModel.value?[index].name ??
                              "";
                          print("sssssssssssss");
                          // productController.currentPage = 1;
                          // productController.getProductList("", "", "",
                          //     isPagination: false);
                        });
                      },
                    ),
                  );
                }),
          ),
        ],
      );
    });
  }

  bottomAboutProduct(ProductListModel? productListModel) {
    bool isPasswordVisible = false;
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          // double purchaseUnitTotal =
          //     double.parse(productListModel!.qtyCountController.text) *
          //         productListModel.sellingCost!;
          // double purchaseCartonTotal =
          //     double.parse(productListModel.qtyCountController.text) *
          //         productListModel.sellingBoxCost!;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          color: MyColors.mainTheme,
                        ),
                        height: 50,
                        width: width(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Catalogue Product",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: MyFont.myFont2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: MyColors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
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
                      SizedBox(height: height(context) / 50),
                      Container(
                        decoration: const BoxDecoration(
                          color: MyColors.white,
                        ),
                        height: 40,
                        width: width(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height(context) / 50),
                      Image.asset(
                        Assets.noimage,
                        scale: 4,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(15),
                          width: width(context),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: MyColors.greyText,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Product Code",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
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
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 2,
                                        child: Text(
                                          productListModel?.code ?? "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Product Name",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
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
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 2,
                                        child: Text(
                                          productListModel?.name ?? "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Category",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
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
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 2,
                                        child: Text(
                                          productListModel?.categoryName ?? "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Sub Category",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
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
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 2,
                                        child: Text(
                                          productListModel?.subCategoryName ??
                                              "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width(context) / 3.5,
                                            child: Text(
                                              "Brand",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontFamily: MyFont.myFont2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
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
                                                fontSize: 15,
                                                letterSpacing: 0.5,
                                                color: MyColors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width(context) / 2,
                                        child: Text(
                                          productListModel?.brand ?? "",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              letterSpacing: 0.5,
                                              color: MyColors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Text(
                                "Selling Price",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: MyFont.myFont2,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: MyColors.black),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: MyColors.greyIcon,
                                ),
                                height: 50,
                                width: width(context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Unit Price",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: MyColors.mainTheme),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\$ ${productListModel?.sellingCost ?? ""}",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: MyColors.black),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Carton Price",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: MyColors.mainTheme),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "\$ ${productListModel?.sellingBoxCost ?? ""}",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: MyColors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              isPasswordVisible
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Purchase Price",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: MyFont.myFont2,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: MyColors.black),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: MyColors.greyIcon,
                                          ),
                                          height: 50,
                                          width: width(context),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Unit Price",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontFamily:
                                                            MyFont.myFont2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color:
                                                            MyColors.mainTheme),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "\$ ${productListModel?.unitCost ?? ""}",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontFamily:
                                                            MyFont.myFont2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color: MyColors.black),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Carton Price",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontFamily:
                                                            MyFont.myFont2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color:
                                                            MyColors.mainTheme),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "\$ ${productListModel?.cartonPrice ?? ""}",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontFamily:
                                                            MyFont.myFont2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                        color: MyColors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget buildAppBarCartButton() {
    return GestureDetector(
      onTap: () async {
        if (productController.productService.productListItems.isNotEmpty) {
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
              padding: EdgeInsets.only(right: 11.0, left: 10),
              child: Icon(
                Icons.shopping_cart,
                color: MyColors.white,
                size: 23,
              ),
            ),
            if (productController.productService.productListItems.isNotEmpty)
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
                      productController.productService.productListItems.length
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

class filterCategory {
  String name;
  int id;
  filterCategory(this.id, this.name);
}

class CustomerRating {
  String rate;
  IconData icon;
  String range;
  CustomerRating(this.rate, this.icon, this.range);
}
