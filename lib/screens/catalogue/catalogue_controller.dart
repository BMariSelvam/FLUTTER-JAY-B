import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/BrandListModel.dart';
import 'package:JNB/Model/CategoryListModel.dart';
import 'package:JNB/Model/SubCategoryListModel.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/product_model.dart';
import 'package:JNB/screens/locator/cart_service.dart';
import 'package:JNB/screens/locator/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController with StateMixin {
  bool isCheckedByClearFilter = false;

  int sliderValue = 0;
  int? seletedForLocationRadio = 1;
  bool isCurrentposition = false;

  RxInt selectedIndex = 0.obs;

  TextEditingController searchcontroller = TextEditingController();

  GlobalKey<ScaffoldState> catalogueScaffoldKey = GlobalKey<ScaffoldState>();

  Rx<bool> isProductListLoading = false.obs;
  Rx<bool> isCategoryLoading = false.obs;
  Rx<bool> isSubCategoryLoading = false.obs;
  Rx<bool> isBrandLoading = false.obs;

  RxList<ProductListModel> productListModel = <ProductListModel>[].obs;
  // Rx<List<ProductListModel>?> productListModel =
  //     (null as List<ProductListModel>?).obs;
  Rx<List<CategoryListModel>?> categoryListModel =
      (null as List<CategoryListModel>?).obs;
  Rx<List<SubCategoryListModel>?> subCategoryListModel =
      (null as List<SubCategoryListModel>?).obs;
  Rx<List<BrandListModel>?> brandListModel =
      (null as List<BrandListModel>?).obs;

  RxList<ProductListModel> cartAddedProduct = <ProductListModel>[].obs;
  LoginUser? loginUser;

  final ProductListService productService = getIt<ProductListService>();
  int totalPages = 1;
  int currentPage = 1;

  Future<void> getProductList(category, subCategory,
      {required bool isPagination}) async {
    change(null, status: RxStatus.loadingMore());

    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.getAllWithImageProductList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "Category": "$category",
        "SubCategory": "$subCategory",
        "pageNo": "$currentPage",
        "pageSize": "10"
      },
    ).then((apiResponse) {
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.result != null) {
          List? resJson = apiResponse.apiResponseModel!.result!;
          print(apiResponse.apiResponseModel!.result!);
          if (resJson != null) {
            List<ProductListModel> list =
                resJson.map<ProductListModel>((value) {
              return ProductListModel.fromJson(value);
            }).toList();
            if (!isPagination) {
              productListModel.clear();
            }
            productListModel.addAll(list);
            totalPages = apiResponse.apiResponseModel?.totalNumberOfPages ?? 1;
            currentPage++;
            change(productListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          productListModel.value = [];
          currentPage = 1;
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      } else {
        productListModel.value = [];
        currentPage = 1;
        change(null, status: RxStatus.error());
        String? message = apiResponse.apiResponseModel?.message;
        PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "msg",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }

  getCategoryList() async {
    change(null, status: RxStatus.loading());
    isCategoryLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.getAllCategoryList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
      },
    ).then((apiResponse) {
      isCategoryLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            categoryListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => CategoryListModel.fromJson(e))
                    .toList();

            change(categoryListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "msg",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }

  // getSubCategoryList() async {
  //   change(null, status: RxStatus.loading());
  //
  //   isSubCategoryLoading.value = true;
  //   loginUser = await PreferenceHelper.getUserData();
  //   await NetworkManager.get(
  //     url: HttpUrl.getAllSubCategoryList,
  //     parameters: {
  //       "OrganizationId": "${loginUser?.orgId}",
  //     },
  //   ).then((apiResponse) {
  //     isSubCategoryLoading.value = false;
  //     if (apiResponse.apiResponseModel != null &&
  //         apiResponse.apiResponseModel!.status) {
  //       if (apiResponse.apiResponseModel!.data != null) {
  //         List? resJson = apiResponse.apiResponseModel!.data!;
  //         print(apiResponse.apiResponseModel!.data!);
  //         if (resJson != null) {
  //           print(apiResponse.apiResponseModel!.data!);
  //           print("--------------");
  //           subCategoryListModel.value =
  //               (apiResponse.apiResponseModel!.data as List)
  //                   .map((e) => SubCategoryListModel.fromJson(e))
  //                   .toList();
  //           print(subCategoryListModel);
  //           print("subCategoryListModel+++++++++++++++");
  //           change(subCategoryListModel);
  //         }
  //         change(null, status: RxStatus.success());
  //       } else {
  //         change(null, status: RxStatus.error());
  //         String? message = apiResponse.apiResponseModel?.message;
  //         PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
  //       }
  //     }
  //   }).catchError((error) {
  //     change(null, status: RxStatus.error());
  //     Get.snackbar(
  //       "Attention",
  //       "msg",
  //       margin: const EdgeInsets.all(20),
  //       backgroundColor: MyColors.pink,
  //       icon: const Icon(Icons.error),
  //       duration: const Duration(seconds: 2),
  //       snackPosition: SnackPosition.TOP,
  //     );
  //     // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
  //   });
  // }

  getSubCategoryCodeList(String categoryCode) async {
    change(null, status: RxStatus.loading());

    isSubCategoryLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.getAllSubCategoryCodeList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CategoryCode": categoryCode,
      },
    ).then((apiResponse) {
      isSubCategoryLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            subCategoryListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => SubCategoryListModel.fromJson(e))
                    .toList();
            print(subCategoryListModel);
            print("subCategoryListModel+++++++++++++++");
            change(subCategoryListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          subCategoryListModel.value = [];
          change(null, status: RxStatus.success());
          // String? message = apiResponse.apiResponseModel?.message;
          // PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "msg",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }

  getBrandList() async {
    change(null, status: RxStatus.loading());

    isBrandLoading.value = true;
    loginUser = await PreferenceHelper.getUserData();
    await NetworkManager.get(
      url: HttpUrl.getAllBrandList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
      },
    ).then((apiResponse) {
      isBrandLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            brandListModel.value = (apiResponse.apiResponseModel!.data as List)
                .map((e) => BrandListModel.fromJson(e))
                .toList();
            print(brandListModel);
            print("brandListModel+++++++++++++++");
            change(brandListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "msg",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }
}
