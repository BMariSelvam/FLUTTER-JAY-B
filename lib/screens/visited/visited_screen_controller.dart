import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/login_model.dart';
import 'package:JNB/Model/visied/not_visied_model.dart';
import 'package:JNB/Model/visied/visied_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitedScreenController extends GetxController with StateMixin {
  TextEditingController searchController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  GlobalKey<ScaffoldState> visitedScaffoldKey = GlobalKey<ScaffoldState>();

  Rx<bool> isLoading = false.obs;
  RxBool isVisited = true.obs;

  Rx<bool> createCustomerVisitedIsLoading = false.obs;
  Rx<bool> getAllVisitedCustomersIsLoading = false.obs;
  Rx<bool> getAllVisitedNotVisitedCustomers = false.obs;
  Rx<bool> getAllVisitedCodeCustomers = false.obs;

  LoginUser? loginUser;

  Rx<List<GetAllNotVisitedListModel>?> visitedListModelAll =
      (null as List<GetAllNotVisitedListModel>?).obs;
  Rx<List<GetAllVisitedListModel>?> visitedListModel =
      (null as List<GetAllVisitedListModel>?).obs;
  RxList<GetAllNotVisitedListModel> notVisitedListModel =
      <GetAllNotVisitedListModel>[].obs;
  List<GetAllNotVisitedListModel> selectedmoledl = [];
  Rx<List<GetAllNotVisitedListModel>?> visitedCodeModel =
      (null as List<GetAllNotVisitedListModel>?).obs;

  DateTime orderDate = DateTime.now();

  late GetAllNotVisitedListModel getAllNotVisitedListModel;
  GetAllNotVisitedListModel? data;
  int totalPages = 1;
  int currentPage = 1;

  createCustomerVisitedApi() async {
    change(null, status: RxStatus.loading());
    createCustomerVisitedIsLoading.value = true;
    print(getAllNotVisitedListModel.toJson());
    print("""""" """" getAllNotVisitedListModel.toJson()""" """""");
    NetworkManager.post(
            URl: HttpUrl.createCustomerVisited,
            params: getAllNotVisitedListModel.toJson())
        .then((apiResponse) async {
      createCustomerVisitedIsLoading.value = false;
      if (apiResponse.apiResponseModel != null) {
        if (apiResponse.apiResponseModel!.status) {
          // Get.offAndToNamed(AppRoutes.visitedScreen);
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

  Future<void> getAllVisitedNotVisitedCustomersList(
      {required String currentDate, required bool isPagination,required String code,
        required String name,}) async {
    change(null, status: RxStatus.loadingMore());
    loginUser = await PreferenceHelper.getUserData();
    NetworkManager.get(
      url: HttpUrl.getAllVisitedNotVisitedCustomers,
      parameters: {
        "OrganizationId": "${loginUser?.orgId}",
        "CustomerCode" : code,
        "CustomerName" : name,
        "VisitedDate": currentDate,
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
            List<GetAllNotVisitedListModel> list =
                resJson.map<GetAllNotVisitedListModel>((value) {
              return GetAllNotVisitedListModel.fromJson(value);
            }).toList();
            if (!isPagination) {
              notVisitedListModel.clear();
            }
            notVisitedListModel.addAll(list);
            print("CustomerListModel.value.length");
            print("=================================$currentPage");
            print(notVisitedListModel.value.length);
            totalPages = apiResponse.apiResponseModel?.totalNumberOfPages ?? 1;
            currentPage++;

            change(notVisitedListModel);
          }
          change(null, status: RxStatus.success());
        } else {
          notVisitedListModel.value = [];
          currentPage = 1;
          change(null, status: RxStatus.error());
          String? message = apiResponse.apiResponseModel?.message;
        }
      } else {
        notVisitedListModel.value = [];
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

  Future<void> getAllVisitedCustomersListCode(code) async {
    change(null, status: RxStatus.loading());

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
