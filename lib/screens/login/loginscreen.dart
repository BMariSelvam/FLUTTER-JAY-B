import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:JNB/Custom_widgets/custom_button.dart';
import 'package:JNB/Custom_widgets/custom_textField_1.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:JNB/Model/branches_list_model.dart';
import 'package:JNB/Model/company_name_list_model.dart';
import 'package:JNB/widgets/search_dropdown_textfield2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logincontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController loginController;
  int? orgid;

  @override
  void initState() {
    super.initState();
    loginController = Get.put(LoginController());
    loginController.getAllCompanyNameList();
    loadUserEmailPassword();
    // loginController.emailController.text = "sales01";
    // loginController.passwordController.text = "admin";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginController.loginKey,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: MyColors.mainTheme,
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: MyColors.white,
                      ))
                ],
              ),
              Column(
                children: [
                  textFormField(),
                  loginController.isLoading.value == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: MyColors.tpt,
                              child:
                                  Center(child: PreferenceHelper.showLoader()),
                            ),
                          ],
                        )
                      : Container(
                          width: width(context),
                          color: MyColors.white,
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 18),
                          child: CustomButton(
                            color: MyColors.pink,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (loginController.loginKey.currentState!
                                  .validate()) {
                                loginController.loginKey.currentState?.save();
                                loginController.onLoginTapped(
                                  loginController.companyName,
                                  loginController.companyBranchName,
                                  orgid,
                                );
                              } else {
                                print("Fields are Empty");
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const DashBoardScreen(),
                              //     ));
                            },
                            title: 'Sign In',
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  textFormField() {
    return Expanded(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: MyColors.white,
              alignment: Alignment.center,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(18.0),
                    alignment: Alignment.center,
                    color: MyColors.mainTheme,
                    child: Image.asset(
                      Assets.logo,
                      scale: 2,
                    )),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                    color: MyColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: MyColors.black),
                          ),
                        ),
                        SizedBox(height: height(context) / 60),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: MyColors.pink,
                          ),
                          height: 3,
                          width: width(context) / 5,
                        ),
                        SizedBox(height: height(context) / 40),
                        Text(
                          'User Name',
                          style: TextStyle(
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: MyColors.black),
                        ),
                        SizedBox(height: height(context) / 80),
                        CustomTextFormField(
                          controller: loginController.emailController,
                          readOnly: false,
                          obscureText: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          filled: true,
                          hintText: "User Name",
                          keyboardInput: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter User name";
                            } else {}
                          },
                          suffixIcon:
                              const Icon(Icons.person, color: MyColors.pink),
                        ),
                        SizedBox(height: height(context) / 80),
                        Text(
                          'Password',
                          style: TextStyle(
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: MyColors.black),
                        ),
                        SizedBox(height: height(context) / 80),
                        CustomTextFormField(
                          controller: loginController.passwordController,
                          readOnly: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: loginController.isPasswordVisible.value
                              ? false
                              : true,
                          filled: true,
                          hintText: "Password",
                          hintTextStyle: TextStyle(
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: MyColors.greyText),
                          keyboardInput: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Password";
                            } else {}
                          },
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  loginController.isPasswordVisible.value =
                                      !loginController.isPasswordVisible.value;
                                });
                              },
                              icon: Icon(
                                  loginController.isPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: MyColors.pink)),
                        ),
                        SizedBox(height: height(context) / 80),
                        Text(
                          'Company Name',
                          style: TextStyle(
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: MyColors.black),
                        ),
                        SizedBox(height: height(context) / 80),
                        Obx(() {
                          return SearchDropdownTextField2<OrgNameListModel>(
                              controller: loginController.companyName,
                              hintText: 'Company Name',
                              hintTextStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                fontSize: 13,
                                color: MyColors.greyText,
                              ),
                              textStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                color: MyColors.black,
                                fontSize: 13,
                              ),
                              suffixIcon: const Icon(
                                Icons.expand_circle_down_outlined,
                                color: MyColors.pink,
                              ),
                              inputBorder: BorderSide.none,
                              filled: true,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              items: loginController.companyNameListModel.value,
                              color: Colors.black54,
                              selectedItem: loginController.companyNameList,
                              isValidator: true,
                              errorMessage: 'Please enter Company Name',
                              onAddPressed: () {
                                setState(() {
                                  loginController.companyName = "";
                                  loginController.companyNameList = null;
                                });
                              },
                              onChanged: (value) async {
                                FocusScope.of(context).unfocus();
                                loginController.companyNameList = value;
                                loginController.companyName = value.name;
                                setState(() {
                                  loginController.companyName = value.name;
                                  orgid = value.orgId;
                                });
                                await PreferenceHelper.saveOrgString(
                                    "${orgid}");
                                await loginController.getAllBranchesList(orgid);
                              });
                        }),
                        SizedBox(height: height(context) / 80),
                        Text(
                          'Company Branch',
                          style: TextStyle(
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: MyColors.black),
                        ),
                        SizedBox(height: height(context) / 80),
                        Obx(() {
                          return SearchDropdownTextField2<BranchesListModel>(
                              controller: loginController.companyBranchName,
                              hintText: 'Company Branch',
                              hintTextStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                color: MyColors.greyText,
                                fontSize: 13,
                              ),
                              textStyle: TextStyle(
                                fontFamily: MyFont.myFont2,
                                color: MyColors.black,
                                fontSize: 13,
                              ),
                              suffixIcon: const Icon(
                                Icons.expand_circle_down_outlined,
                                color: MyColors.pink,
                              ),
                              inputBorder: BorderSide.none,
                              filled: true,
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              items: loginController.branchesListModel.value,
                              color: Colors.black54,
                              selectedItem: loginController.branchesList,
                              isValidator: true,
                              errorMessage: 'Please enter Company Branch',
                              onAddPressed: () {
                                setState(() {
                                  loginController.companyBranchName = "";
                                  loginController.branchesList = null;
                                });
                              },
                              onChanged: (value) async {
                                FocusScope.of(context).unfocus();
                                loginController.branchesList = value;
                                loginController.companyBranchName = value.name;
                                setState(() {
                                  loginController.companyBranchCode =
                                      value.code;
                                  loginController.companyBranchName =
                                      value.name!;
                                });
                                await PreferenceHelper.saveBanchCodeString(
                                    "${loginController.companyBranchCode}");
                                await PreferenceHelper.saveBranchNameString(
                                    "${loginController.companyBranchName}");
                                print("${loginController.companyBranchCode}");
                                var code = await PreferenceHelper
                                    .getBranchCodeString();
                                print("_____________________code");
                                print(code);
                              });
                        }),
                        SizedBox(height: height(context) / 40),
                        rememberCheckBox(),
                        SizedBox(height: height(context) / 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  rememberCheckBox() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: Theme(
          data: ThemeData(
            unselectedWidgetColor: MyColors.mainTheme,
          ),
          child: Checkbox(
            activeColor: MyColors.mainTheme,
            value: loginController.isChecked,
            onChanged: (value) {
              setState(
                () {
                  handleRemeberme(value!);
                },
              );
            },
          ),
        ),
      ),
      const SizedBox(width: 10.0),
      Text("Remember Me",
          style: TextStyle(
            fontFamily: MyFont.myFont2,
            fontWeight: FontWeight.bold,
            color: MyColors.black,
          ))
    ]);
  }

  //handle remember me function
  handleRemeberme(bool value) {
    loginController.isChecked = value;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('User Name', loginController.emailController.text);
        prefs.setString('password', loginController.passwordController.text);
        prefs.setString('companyName', loginController.companyName ?? "");
        prefs.setString(
            'companyBranchName', loginController.companyBranchName ?? "");
        prefs.setString('OrgNo', "${orgid}" ?? "");
      },
    );
    setState(() {
      loginController.isChecked = value;
    });
  }

  //load email and password
  loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("User Name") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _companyName = _prefs.getString("companyName") ?? "";
      var _companyBranchName = _prefs.getString("companyBranchName") ?? "";
      var _orgid = _prefs.getString("OrgNo") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      print(_remeberMe);
      print(_email);
      print("::::::::::::::::::;;");
      print(_password);
      print(_companyName);
      print(_companyBranchName);
      if (_remeberMe) {
        setState(() {
          loginController.isChecked = true;
        });
        loginController.emailController.text = _email ?? "";
        loginController.passwordController.text = _password ?? "";
        loginController.companyName = _companyName ?? "";
        loginController.companyBranchName = _companyBranchName ?? "";
        orgid = int.parse(_orgid ?? "");
      }
    } catch (e) {
      print(e);
    }
  }
}
