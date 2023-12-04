import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardInput;
  final AutovalidateMode autoValidateMode;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final bool filled;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final Color? fillColor;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.hintText,
    this.hintTextStyle,
    this.labelText,
    this.labelTextStyle,
    required this.readOnly,
    this.inputFormatters,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.suffixIcon,
    this.onSuffixIconPressed,
    required this.obscureText,
    required this.filled,
    this.keyboardInput,
    this.onTap,
    this.onChanged,
    this.fillColor,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          fontFamily: MyFont.myFont2,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      controller: widget.controller,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardInput,
      autovalidateMode: widget.autoValidateMode,
      obscureText: widget.obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: MyColors.greyText),
        labelText: widget.labelText,
        filled: widget.filled,
        fillColor: widget.fillColor,
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
      ),
    );
  }
}
