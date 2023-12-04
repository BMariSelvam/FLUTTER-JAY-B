import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;

  final TextInputType? keyboardType;
  final bool obscureText = false;
  final InputBorder inputBorder;
  final Function(String)? onChanged;
  final Function()? onTap;

  const SearchTextField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.labelText,
    this.keyboardType,
    required this.controller,
    obscureText = false,
    required this.inputBorder,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: MyColors.greyIcon,
          )
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
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
          contentPadding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 15),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: MyColors.mainTheme,
            fontSize: 13,
            fontFamily: MyFont.myFont2,
            fontWeight: FontWeight.w900,
          ),
        ),
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
      ),
    );
  }
}
