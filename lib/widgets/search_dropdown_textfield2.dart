import 'package:JNB/Const/fonts.dart';
import 'package:JNB/Helper/preference_helper.dart';
import 'package:flutter/material.dart';

import '../Const/colors.dart';
import '../Const/size.dart';

class SearchDropdownTextField2<T> extends StatefulWidget {
  final initialValue;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelTextStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final bool enabled;
  final List<T>? items;
  final T? selectedItem;
  final bool isValidator;
  final bool? filled;
  final BorderSide? inputBorder;
  final String? errorMessage;
  final Function(T value) onChanged;
  final Function? onAddPressed;
  final Color? color;
  final Color? filledColor;
  final InputBorder? border;
  final Icon? suffixIcon;
  final String? controller;

  const SearchDropdownTextField2({
    Key? key,
    this.labelText,
    this.enabled = true,
    this.items,
    required this.selectedItem,
    required this.isValidator,
    this.errorMessage,
    this.color,
    required this.onChanged,
    this.onAddPressed,
    this.border,
    this.filled = false,
    this.filledColor,
    this.inputBorder,
    this.labelTextStyle,
    this.suffixIcon,
    this.textStyle,
    this.initialValue,
    this.hintText,
    this.hintTextStyle,
    this.controller,
  }) : super(key: key);

  @override
  State<SearchDropdownTextField2<T>> createState() =>
      _SearchDropdownTextField2State<T>();
}

class _SearchDropdownTextField2State<T>
    extends State<SearchDropdownTextField2<T>> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController(
        text: widget.selectedItem?.toString() ?? widget.controller.toString());

    return Container(
      width: width(context),
      decoration: BoxDecoration(
        color: MyColors.tpt,
        borderRadius: const BorderRadius.all(
            Radius.circular(12) //                 <--- border radius here
            ),
        border: Border.all(
          color: MyColors.greyText,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: textEditingController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.initialValue,
        style: widget.textStyle,
        enabled: widget.enabled,
        showCursor: false,
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            filled: widget.filled,
            fillColor: widget.filledColor,
            border: OutlineInputBorder(
              borderSide: widget.inputBorder ?? const BorderSide(),
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: widget.labelText,
            labelStyle: widget.labelTextStyle,
            hintText: widget.hintText,
            hintStyle: widget.hintTextStyle,
            suffixIcon: widget.suffixIcon),
        onTap: () {
          // if (widget.items?.length == 1) {
          //   textEditingController.text = widget.items![0].toString();
          // } else {
          _showMaterialDialog(context, textEditingController);
          // }
        },
        validator: (value) {
          if (widget.isValidator && (value == null || value.isEmpty)) {
            return widget.errorMessage ?? '';
          }
          return null;
        },
      ),
    );
  }

  void _showMaterialDialog(
      BuildContext context, TextEditingController textEditingController) {
    // var firstValue = widget.items!.first;
    // var newList = [firstValue];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              width: double.maxFinite,
              height: height(context) / 1.9,
              child: SearchDialog<T>(
                  items: widget.items,
                  onAddPressed: (widget.onAddPressed != null
                      ? () {
                          if (widget.onAddPressed != null) {
                            widget.onAddPressed!();
                          }
                        }
                      : null),
                  onChanged: (value) {
                    if (widget.items?.length == 1) {
                      textEditingController.text = widget.items![0].toString();
                    } else {
                      textEditingController.text = value.toString();
                    }
                    widget.onChanged(value);
                  }),
            ),
          );
        });
  }
}

class SearchDialog<T> extends StatefulWidget {
  final List<T>? items;
  final Function(T value) onChanged;
  final Function? onAddPressed;

  const SearchDialog(
      {Key? key,
      required this.items,
      required this.onChanged,
      this.onAddPressed})
      : super(key: key);

  @override
  createState() => _SearchDialogState<T>();
}

class _SearchDialogState<T> extends State<SearchDialog<T>> {
  final TextEditingController _filter = TextEditingController();
  List<T>? _filterTaskList;
  String _searchText = "";

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _filterTaskList = widget.items;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addFilterListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _filter,
                cursorColor: MyColors.black,
                style: TextStyle(
                    fontFamily: MyFont.myFont2, color: MyColors.mainTheme),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.lightmainTheme2,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontFamily: MyFont.myFont2, color: MyColors.mainTheme),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: MyColors.mainTheme),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: MyColors.mainTheme),
                  ),
                ),
              ),
            ),
            //if (widget.onAddPressed != null)
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     widget.onAddPressed!();
            //   },
            //   icon: const Icon(Icons.add_circle),
            //   iconSize: 30,
            // )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _filterTaskList?.length ?? 0,
            itemBuilder: (context, index) {
// ReasonListModel reasonListModel =
// _rejectReasonList![index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onChanged(_filterTaskList![index]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _filterTaskList![index].toString(),
                    style: TextStyle(
                        fontFamily: MyFont.myFont2,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
          ),
        )
      ],
    );
  }

  _addFilterListener() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filterTaskList = widget.items;
        });
      } else {
        setState(() {
          PreferenceHelper.print(_filter.text);
          _searchText = _filter.text;
          _filterTaskList = widget.items
              ?.where((element) => (element
                  .toString()
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())))
              .toList();
        });
      }
    });
  }
}
