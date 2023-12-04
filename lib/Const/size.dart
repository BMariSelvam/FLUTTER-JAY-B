import 'package:flutter/material.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class Grid {
  final String name;
  final String image;
  final Color color;
  final String onTap;

  Grid({
    required this.name,
    required this.image,
    required this.color,
    required this.onTap,
  });
}
