import 'package:chat_app_flutter/constants/constant_colors.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {

  TextEditingController controller;
  TextInputType keyboardType;
  IconData icon;
  bool obscureText;
  String hintText;
  Widget? suffixIcon;
  String? Function(String?)? validator;

  TextFieldCustom({
    required this.controller,
    required this.keyboardType,
    required this.icon,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: ConstantColors.white,
      style: TextStyle(
        color: ConstantColors.white,
      ),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: ConstantColors.grey,
        ),
        prefixIcon: Icon(icon, color: ConstantColors.white,),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ConstantColors.purple_light_2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ConstantColors.purple_light_2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ConstantColors.red_dark,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ConstantColors.red_dark,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
