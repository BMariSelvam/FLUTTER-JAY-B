import 'dart:async';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesOrderSuccessfullyScreen extends StatefulWidget {
  const SalesOrderSuccessfullyScreen({Key? key}) : super(key: key);

  @override
  State<SalesOrderSuccessfullyScreen> createState() =>
      _SalesOrderSuccessfullyScreenState();
}

class _SalesOrderSuccessfullyScreenState
    extends State<SalesOrderSuccessfullyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
        const Duration(seconds: 2),
        () => Get.offAndToNamed(AppRoutes.salesOrderScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height(context) / 50,
                ),
                Image.asset(
                  Assets.successGif,
                  scale: 2,
                ),
                Text(
                  "Ordered Successfully..! 😊 ",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: MyFont.myFont2,
                      fontSize: 25,
                      color: MyColors.mainTheme),
                ),
                SizedBox(
                  height: height(context) / 50,
                ),
                // Image.asset(
                //   Assets.tickGif,
                //   scale: 3,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
