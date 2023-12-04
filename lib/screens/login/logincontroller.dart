import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Helper/api.dart';
import 'package:JNB/Helper/network_manger.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/branches_list_model.dart';
import 'package:JNB/Model/company_name_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with StateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  String? messages;
  bool isChecked = false;
  final loginKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  String dropDownValue = 'index 0';

  String? companyName = '';
  OrgNameListModel? companyNameList;

  String? companyBranchCode;
  String? companyBranchName = '';
  BranchesListModel? branchesList;

  onLoginTapped(String? companyName, String? companyBranch, int? orgId) async {
    isLoading.value = true;
    change(null, status: RxStatus.loading());
    await NetworkManager.post(URl: HttpUrl.login, params: {
      "OrgId": "$orgId",
      "Username": emailController.text.trim(),
      "Password": passwordController.text.trim(),
      "BranchCode": "$companyName",
      "BranchName": "$companyBranch",
    }).then((apiResponse) async {
      isLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null &&
            (apiResponse.apiResponseModel!.data as List).isNotEmpty) {
          change(null, status: RxStatus.success());
          Map<String, dynamic>? customerJson =
              (apiResponse.apiResponseModel!.data! as List).first;
          if (customerJson != null) {
            print(customerJson);
            print("customerJson");
            print("=====================");
            await PreferenceHelper.saveUserData(customerJson)
                .then((value) async {
              Get.offAllNamed(AppRoutes.dashBoardScreen);
            });
          } else {
            change(null, status: RxStatus.error());
            Get.snackbar(
              "Error",
              "Customer data is empty!",
              margin: const EdgeInsets.all(20),
              backgroundColor: MyColors.red,
              icon: const Icon(Icons.error),
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.TOP,
            );
          }
        }
      } else {
        change(null, status: RxStatus.error());
        String? message = apiResponse.apiResponseModel?.message.toString();
        message = messages;
        print("API Response Message (Error): $message");

        Get.snackbar(
          margin: const EdgeInsets.all(20),
          backgroundColor: MyColors.red,
          "Attention",
          message ?? "Your Username or Password are Incorrect",
          icon: const Icon(Icons.emergency),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  Rx<bool> isCompanyNameLoading = false.obs;

  Rx<List<OrgNameListModel>?> companyNameListModel =
      (null as List<OrgNameListModel>?).obs;

  getAllCompanyNameList() async {
    isCompanyNameLoading.value = true;
    NetworkManager.get(
      url: HttpUrl.getAllOrganization,
      parameters: {},
    ).then((apiResponse) {
      isCompanyNameLoading.value = false;
      print(apiResponse);
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        print(apiResponse.apiResponseModel);
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            companyNameListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => OrgNameListModel.fromJson(e))
                    .toList();
            print(" CustomerListModel+++++++++++++++");
            change(companyNameListModel.value);
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
          "Company Name Error",
          margin: const EdgeInsets.all(20),
          backgroundColor: MyColors.pink,
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }

  Rx<bool> isBranchNameLoading = false.obs;

  Rx<List<BranchesListModel>?> branchesListModel =
      (null as List<BranchesListModel>?).obs;

  getAllBranchesList(int? orgId) async {
    print(companyNameListModel.value?.first.orgId);
    print(" companyNameListModel.value?.first.orgId");
    isBranchNameLoading.value = true;
    NetworkManager.get(
      url: HttpUrl.getAllBranches,
      parameters: {
        "OrganizationId": "$orgId",
      },
    ).then((apiResponse) async {
      print(apiResponse.apiResponseModel?.data);
      isBranchNameLoading.value = false;
      if (apiResponse.apiResponseModel != null &&
          apiResponse.apiResponseModel!.status) {
        if (apiResponse.apiResponseModel!.data != null) {
          List? resJson = apiResponse.apiResponseModel!.data!;
          print(apiResponse.apiResponseModel!.data!);
          if (resJson != null) {
            print(apiResponse.apiResponseModel!.data!);
            print("--------------");
            branchesListModel.value =
                (apiResponse.apiResponseModel!.data as List)
                    .map((e) => BranchesListModel.fromJson(e))
                    .toList();
            print(" branchesListModel+++++++++++++++");
            if (branchesListModel.value?.length == 1) {
              print("||||||||||||||||");
              branchesList = branchesListModel.value?.first;
              companyBranchName = branchesListModel.value?.first.name;
              companyBranchCode = branchesListModel.value?.first.code;
              print("||||||||||||||||");
              await PreferenceHelper.saveBanchCodeString("$companyBranchCode");
              await PreferenceHelper.saveBranchNameString("$companyBranchName");
              print("$companyBranchCode");
              var code = await PreferenceHelper.getBranchCodeString();
              print("_____________________codmmmmmmmmmmmmme");
              print(code);
            }
            change(branchesListModel.value);
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
          "Branches List Error",
          margin: const EdgeInsets.all(20),
          backgroundColor: MyColors.pink,
          icon: const Icon(Icons.error),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      },
    );
  }
}
