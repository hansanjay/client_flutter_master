import 'package:flutter/material.dart';
import 'package:client_flutter_master/utils/images_utils.dart';
import 'color_utils.dart';

class DecorationUtils {
  static BoxDecoration borderDecorationBoxBlueColor({double? radius}) {
    return BoxDecoration(
      border: Border.all(color: ColorUtils.blue14, width: 1.5),
      borderRadius: BorderRadius.circular(radius ?? 8),
    );
  }

  static BoxDecoration verticalBorderAndColorDecorationBox(
      {double? radius, Color? colors}) {
    return BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius!)),
    );
  }

  static BoxDecoration allBorderAndColorDecorationBox(
      {double? radius, Color? colors}) {
    return BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.circular(radius ?? 8),
    );
  }

  static BoxDecoration shadowAndColorDecorationBox() {
    return BoxDecoration(
      color: Color(0xFF8F43EE),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: ColorUtils.gray,
          blurRadius: 10,
          offset: Offset(0, 1),
        )
      ],
    );
  }
  /// ------------------------------------------------------------------- ///
  /// TEXT FIELD OUTLINE DECORATION

  static OutlineInputBorder outLineSonicBlue14R20 = const OutlineInputBorder(
    borderRadius: BorderRadius.all( Radius.circular(5)),
    borderSide: BorderSide(
      color: ColorUtils.blue14,
      width: 0.5,
    ),
  );

  static const myProfileDecoration = BoxDecoration(
    color: ColorUtils.lightSkyDB,
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  static BoxDecoration borderAndColorDecorationBox() {
    return BoxDecoration(
      color: ColorUtils.grayE8,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: ColorUtils.grayC7,
      ),
    );
  }

  static BoxDecoration borderAndCircleDecorationBox(
      {BoxBorder? border, List<BoxShadow>? boxShadow}) {
    return BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow);
  }

  static OutlineInputBorder outLineR20 = outLineSonicBlue14R20.copyWith(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide.none,
  );
  static OutlineInputBorder outLineBorderR20 = outLineSonicBlue14R20.copyWith(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Colors.grey, width: 1),
  );

  static BoxDecoration borderAndRadius() {
    return BoxDecoration(
        border: Border.all(color: ColorUtils.grayBorder),
        color: ColorUtils.whiteF7,
        borderRadius: BorderRadius.circular(20.5));
  }

  /// TEXT FIELD OUTLINE DECORATION

  static final textFieldDecoration = outLineSonicBlue14R20.copyWith(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
}
