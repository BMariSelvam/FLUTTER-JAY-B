import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Function()? onTap;
  final String title;
  final Color color;
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.title,
      required this.color});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(50), // Button border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: MyFont.myFont2,
                  fontWeight: FontWeight.bold,
                  color: MyColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
