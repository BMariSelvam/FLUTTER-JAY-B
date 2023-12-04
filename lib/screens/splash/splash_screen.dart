import 'dart:async';

import 'package:JNB/Const/app_route.dart';
import 'package:JNB/Const/assets.dart';
import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.white,
        body: Stack(
          children: [
            Container(
              height: height(context),
              width: width(context),
              decoration: const BoxDecoration(
                color: MyColors.white,
              ),
            ),
            Center(
                child: AnimatedBuilder(
              animation: _controller,
              child: Container(
                width: 10,
                height: 10,
                color: Colors.transparent,
                child: Center(
                  child: Image.asset(
                    Assets.logo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: child,
                );
              },
            )),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = Tween<double>(
      begin: 0,
      end: 15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 3),
          () => Get.offAllNamed(AppRoutes.loginScreen));
    });
  }
}
