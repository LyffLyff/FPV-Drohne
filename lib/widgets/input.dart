import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      onEditingComplete: () => {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
      },
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      
      style: const TextStyle(
        fontSize: 16
      )
    )
  );
}