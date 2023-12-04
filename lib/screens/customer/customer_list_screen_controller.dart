import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/customer_list_model.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/visied/not_visied_model.dart';
import 'package:JNB/Model/visied/visied_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerScreenController extends GetxController with StateMixin {
  TextEditingController searchcontroller = TextEditingController();

  GlobalKey<ScaffoldState> customerScaffoldKey = GlobalKey<ScaffoldState>();

  Rx<bool> isLoading = false.obs;

  // Rx<List<CustomerListModel>?> customerListModel =
  //     (null as List<CustomerListModel>?).obs;
  RxList<CustomerListModel> customerListModel = <CustomerListModel>[].obs;
  int totalPages = 1;
  int currentPage = 1;
  LoginUser? loginUser;
  String? tranNo;
  // getAllCustomersList() async {
  //   isLoading.value = true;
  //   loginUser = await PreferenceHelper.getUserData();
  //   await NetworkManager.get(
  //     url: HttpUrl.getAllCustomersList,
  //     parameters: {
  //       "OrganizationId": "${loginUser?.orgId}",
  //     },
  //   ).then((apiResponse) {
  //     isLoading.value = false;
  //     if (apiResponse.apiResponseModel != null &&
  //         apiResponse.apiResponseModel!.status) {
  //       if (apiResponse.apiResponseModel!.data != null) {
  //         List? resJson = apiResponse.apiResponseModel!.data!;
  //         print(apiResponse.apiResponseModel!.data!);
  //         if (resJson != null) {
  //           print(apiResponse.apiResponseModel!.data!);
  //           print("--------------");
  //           customerListModel.value =
  //               (apiResponse.apiResponseModel!.data as List)
  //                   .map((e) => CustomerListModel.fromJson(e))
  //                   .toList();
  //           print(" CustomerListModel+++++++++++++++");
  //           change(customerListModel.value);
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
  //       "Error",
  //       margin: const EdgeInsets.all(20),
  //       backgroundColor: MyColors.pink,
  //       icon: const Icon(Icons.error),
  //       duration: const Duration(seconds: 2),
  //       snackPosition: SnackPosition.TOP,
  //     );
  //     // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
  //   });
  // }

  Future<void> getAllCustomersSearchList(
      {required String code,
      required String name,
      required bool isPagination}) async {
    change(null, status: RxStatus.loadingMore());
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getAllCustomersList,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CustomerCode": code,
        "CustomerName": name,
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
            List<CustomerListModel> list =
                resJson.map<CustomerListModel>((value) {
              return CustomerListModel.fromJson(value);
            }).toList();
            if (!isPagination) {
              customerListModel.clear();
            }
            customerListModel.addAll(list);
            print("CustomerListModel.value.length");
            print("=================================$currentPage");
            print(customerListModel.value.length);
            totalPages = apiResponse.apiResponseModel?.totalNumberOfPages ?? 1;
            currentPage++;
            change(CustomerListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          customerListModel.value = [];
          currentPage = 1;
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
        }
      } else {
        customerListModel.value = [];
        currentPage = 1;
        change(null, status: RxStatus.error());
        String? message = apiResponse.apiResponseModel?.message;
      }
    }).catchError((error) {
      change(null, status: RxStatus.error());
      Get.snackbar(
        "Attention",
        "Error",
        margin: const EdgeInsets.all(20),
        backgroundColor: MyColors.pink,
        icon: const Icon(Icons.error),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      // PreferenceHelper.showSnackBar(context: Get.context!, msg: error);
    });
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  RxBool isVisited = true.obs;

  Rx<bool> createCustomerVisitedIsLoading = false.obs;
  Rx<bool> getAllVisitedCustomersIsLoading = false.obs;
  Rx<bool> getAllVisitedNotVisitedCustomers = false.obs;
  Rx<bool> getAllVisitedCodeCustomers = false.obs;

  Rx<List<GetAllNotVisitedListModel>?> visitedListModelAll =
      (null as List<GetAllNotVisitedListModel>?).obs;
  Rx<List<GetAllVisitedListModel>?> visitedListModel =
      (null as List<GetAllVisitedListModel>?).obs;
  Rx<List<GetAllNotVisitedListModel>?> notVisitedListModel =
      (null as List<GetAllNotVisitedListModel>?).obs;
  List<GetAllNotVisitedListModel> selectedmoledl = [];
  Rx<List<GetAllNotVisitedListModel>?> visitedCodeModel =
      (null as List<GetAllNotVisitedListModel>?).obs;

  DateTime orderDate = DateTime.now();

  late GetAllNotVisitedListModel getAllNotVisitedListModel;
  GetAllNotVisitedListModel? data;

  createCustomerVisitedApi() async {
    createCustomerVisitedIsLoading.value = true;
    NetworkManager.post(
            URl: HttpUrl.createCustomerVisited,
            params: getAllNotVisitedListModel.toJson())
        .then((apiResponse) async {
      createCustomerVisitedIsLoading.value = false;
      if (apiResponse.apiResponseModel != null) {
        if (apiResponse.apiResponseModel!.status) {
          Get.showSnackbar(
            GetSnackBar(
              margin: const EdgeInsets.all(10),
              borderRadius: 10,
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.TOP,
              message: "${getAllNotVisitedListModel.customerCode ?? ""}"
                  "Visited SucessFully",
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          Get.offAndToNamed(AppRoutes.visitedScreen);
        } else {
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      } else {
        PreferenceHelper.showSnackBar(
            context: Get.context!, msg: apiResponse.error);
      }
    });
  }

  getAllVisitedNotVisitedCustomersList(String currentDate) async {
    getAllVisitedNotVisitedCustomers.value = true;
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getAllVisitedNotVisitedCustomers,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "VisitedDate": currentDate
      },
    ).then((apiResponse) {
      getAllVisitedNotVisitedCustomers.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            notVisitedListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => GetAllNotVisitedListModel.fromJson(e))
                    .toList();
            tranNo = notVisitedListModel.value?.first.tranNo ?? "";
            print(" notVisitedListModel+++++++++++++++");

            change(notVisitedListModel.value);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError(
      (error) {
        change(null, status: RxStatus.error());
        Get.snackbar(
          "Attention",
          "Error",
          margin: const EdgeInsets.all(20),
          backgroundColor: MyColors.pink,
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }

  Future<void> getAllVisitedCustomersListCode(code) async {
    getAllVisitedCodeCustomers.value = true;
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getAllVisitedCodeCustomers,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "VisitedNo": "$code"
      },
    ).then((apiResponse) {
      getAllVisitedCodeCustomers.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            visitedCodeModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => GetAllNotVisitedListModel.fromJson(e))
                    .toList();
            data = visitedCodeModel.value?.first;
            print(" visitedCodeModel+++++++++++++++");
            change(visitedCodeModel.value);
          }
          change(null, status: RxStatus.success());
        } else {
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
          PreferenceHelper.showSnackBar(context: Get.context!, msg: message);
        }
      }
    }).catchError(
      (error) {
        change(null, status: RxStatus.error());
        Get.snackbar(
          "Attention",
          "Error",
          margin: const EdgeInsets.all(20),
          backgroundColor: MyColors.pink,
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }

  clear() {
    remarkController.clear();
  }
}
