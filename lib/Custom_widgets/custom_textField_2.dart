import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:flutter/material.dart';

class CustomTextField2 extends StatefulWidget {
  final String? initialValue;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final int? hight;
  final int? maxLength;
  final int? maxLines;

  final TextInputType? keyboardType;
  final bool obscureText = false;
  final InputBorder inputBorder;
  final bool readOnly;
  final bool filled;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  const CustomTextField2({
    super.key,
    this.validator,
    this.suffixIcon,
    this.labelText,
    this.keyboardType,
    required this.controller,
    obscureText = false,
    required this.inputBorder,
    this.hintText,
    this.hight,
    this.maxLength,
    this.maxLines,
    required this.filled,
    this.onTap,
    this.onChanged,
    required this.readOnly,
    this.initialValue,
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: TextFormField(
        initialValue: widget.initialValue,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        controller: widget.controller,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        validator: widget.validator,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        style: TextStyle(
          fontSize: 13,
          color: MyColors.black,
          fontFamily: MyFont.myFont2,
          fontWeight: FontWeight.w900,
        ),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: MyFont.myFont2,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: MyColors.greyText),
          hintText: widget.hintText,
          border: widget.inputBorder,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: MyColors.greyText,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 232, 12, 12),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: MyColors.mainTheme,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
          suffixIcon: widget.suffixIcon,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: MyColors.black,
            fontSize: 13,
            fontFamily: MyFont.myFont2,
            fontWeight: FontWeight.w900,
          ),
        ),
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
