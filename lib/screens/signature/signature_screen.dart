import 'package:JNB/Const/colors.dart';
import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Const/size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _userSignatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController _customerSignatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Uint8List? customerSignatureExportedImage;
  Uint8List? userSignatureExportedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_userSignatureController.isNotEmpty &&
                  _customerSignatureController.isNotEmpty) {
                userSignatureExportedImage =
                    await _userSignatureController.toPngBytes();
                customerSignatureExportedImage =
                    await _customerSignatureController.toPngBytes();
              }

              setState(() {
                Navigator.pop(
                    context,
                    SignatureCImage(
                        userSignatureExportedImage: userSignatureExportedImage,
                        customerSignatureExportedImage:
                            customerSignatureExportedImage));
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.check,
                color: MyColors.white,
                size: 25,
              ),
            ),
          ),
          // buildAppBarCartButton()
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: MyColors.mainTheme,
        leading: GestureDetector(
          onTap: () {
            setState(() {
              _customerSignatureController.clear();
              _userSignatureController.clear();
            });

            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.clear,
              color: MyColors.white,
              size: 25,
            ),
          ),
        ),
        title: Text('Signature',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: MyFont.myFont2,
                color: MyColors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                    width: width(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Customer Signature",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: MyColors.mainTheme),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              _customerSignatureController.clear();
                            },
                            child: const Icon(
                              Icons.cleaning_services_rounded,
                              color: MyColors.pink,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: MyColors.white,
                    ),
                    width: width(context),
                    child: Signature(
                      height: height(context) / 2.8,
                      controller: _customerSignatureController,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                    width: width(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User Signature",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontFamily: MyFont.myFont2,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: MyColors.mainTheme),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              _userSignatureController.clear();
                            },
                            child: const Icon(
                              Icons.cleaning_services_rounded,
                              color: MyColors.pink,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: MyColors.white,
                    ),
                    width: width(context),
                    child: Signature(
                      height: height(context) / 2.8,
                      controller: _userSignatureController,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignatureCImage {
  final Uint8List? customerSignatureExportedImage;
  final Uint8List? userSignatureExportedImage;

  SignatureCImage({
    required this.customerSignatureExportedImage,
    required this.userSignatureExportedImage,
  });
}
