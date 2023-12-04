// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';

class Controllers extends GetxController with StateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController seleteAccountController = TextEditingController();
  TextEditingController branchLocationController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();
  TextEditingController comformPasswordController = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController otpbox1 = TextEditingController();
  TextEditingController otpbox2 = TextEditingController();
  TextEditingController otpbox3 = TextEditingController();
  TextEditingController otpbox4 = TextEditingController();
  TextEditingController otpbox5 = TextEditingController();
  TextEditingController otpbox6 = TextEditingController();


  OtpFieldController otpController = OtpFieldController();
}
