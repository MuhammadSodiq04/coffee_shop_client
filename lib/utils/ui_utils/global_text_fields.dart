import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors/app_colors.dart';

class GlobalTextField extends StatefulWidget {
  const GlobalTextField({
    Key? key,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    required this.textAlign,
    this.obscureText = false,
    required this.controller,
    this.icon,
    required this.maxlines,
  }) : super(key: key);

  final String hintText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final bool obscureText;
  final TextEditingController controller;
  final int maxlines;

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  bool isSee = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.c_0C1A30,
          fontFamily: "Montserrat"),
      maxLines: widget.maxlines,
      textAlign: widget.textAlign,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      obscureText: !isSee && widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.obscureText
            ? IconButton(
                splashRadius: 1,
                onPressed: () {
                  setState(() {
                    isSee = !isSee;
                  });
                },
                icon: Icon(isSee
                    ? Icons.remove_red_eye
                    : CupertinoIcons.eye_slash_fill),
                color: AppColors.c_111015,
              )
            : Icon(
                widget.icon,
                color: AppColors.c_111015,
              ),
        filled: true,
        fillColor: AppColors.white,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.c_838589,
            fontFamily: "Montserrat"),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              color: Colors.grey,
            )),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.c_111015,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
