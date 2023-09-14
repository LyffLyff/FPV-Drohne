import 'package:flutter/material.dart';

Widget addVerticalSpace({double height = 20}){
  return SizedBox(
    height: height.toDouble(),
  );
}

Widget addHorizontalSpace({double width = 20}){
  return SizedBox(
    height: width,
  );
}