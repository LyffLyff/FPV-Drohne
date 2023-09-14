import 'package:flutter/material.dart';

Widget stdInputField({required  width, required TextEditingController controller, required String hintText, required bool hideText, IconData? icon}){
  return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        ),
      obscureText: hideText,
    )
  );
}