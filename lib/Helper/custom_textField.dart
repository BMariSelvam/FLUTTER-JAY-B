import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool obscureText = false;
  final InputBorder inputBorder;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField(
      {super.key,
      this.validator,
      this.prefixIcon,
      this.suffixIcon,
      this.labelText,
      this.keyboardType,
      required this.controller,
      obscureText = false,
      required this.inputBorder,
      this.hintText,
      this.contentPadding});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 25,
        right: 25,
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        style: TextStyle(
            fontSize: 20, color: MyColors.black, fontFamily: MyFont.myFont2),
        decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            prefixIcon: widget.prefixIcon,
            contentPadding: widget.contentPadding,
            suffixIcon: widget.suffixIcon,
            suffixIconColor: MyColors.black.withOpacity(0.8),
            hintText: widget.hintText,
            hintStyle:
                TextStyle(color: MyColors.black.withOpacity(0.5), fontSize: 16),
            labelText: widget.labelText,
            labelStyle:
                TextStyle(color: MyColors.black.withOpacity(0.5), fontSize: 16),
            filled: true,
            fillColor: MyColors.greyIcon.withOpacity(0.3),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: MyColors.greyIcon.withOpacity(0.6), width: 1.8))),
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
      ),
    );
  }
}
