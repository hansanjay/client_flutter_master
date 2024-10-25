import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color_utils.dart';
Future showSnackBar(
    {String? message,
      Color? snackColor,
      SnackPosition? snackPosition,
      Duration? showDuration}) async {
  return Get.showSnackbar(
    GetSnackBar(
      message: message,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: snackColor ?? ColorUtils.primaryColor,
      duration: showDuration ?? const Duration(seconds: 2),
    ),
  );
}

BoxDecoration inputFieldGradiantBoxDecoration() {
  return BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(30)),
    gradient: const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [ColorUtils.toryBlue, ColorUtils.picTonBlue]),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: const Color(0xff2965FF).withOpacity(0.3),
          blurRadius: 15.0,
          offset: const Offset(0.0, 0.75))
    ],
  );
}
