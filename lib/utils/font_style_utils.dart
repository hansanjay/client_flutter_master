import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'color_utils.dart';

/// FONT FAMILY
const String poppins = "Roboto";

/// FONT WEIGHT
class FontWeightClass {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiB = FontWeight.w600;
  static const bold = FontWeight.w700;
}

/// FONT TEXT STYLE
class FontTextStyle {
  static TextStyle proxima14Regular = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 11.sp,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsDoveGrey10Normal = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
    color: ColorUtils.doveGrey,
    fontFamily: poppins,
  );
  static TextStyle poppinsWhite20Bold = TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: poppins,
  );
  static TextStyle fontStyle = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeightClass.bold,
  );
  static TextStyle poppinsBlack2610Regular = TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeightClass.regular,
    color: ColorUtils.black26,
    fontFamily: poppins,
  );
  static TextStyle poppinsBlue14SemiB = poppinsBlack2610Regular.copyWith(
    fontWeight: FontWeightClass.semiB,
    color: ColorUtils.blue14,
  );
  static TextStyle poppinsGrayA1Sp11 = poppinsBlack2610Regular.copyWith(
    fontSize: 11.sp,
    color: ColorUtils.grayA1,
  );
  static TextStyle poppinsBlackLightTextFieldRegular =
      poppinsBlack2610Regular.copyWith(
    fontSize: 10.sp,
    fontWeight: FontWeightClass.regular,
    color: ColorUtils.blackLightTextField,
  );
  static TextStyle poppinsBlack12medium = poppinsBlack2610Regular.copyWith(
    fontWeight: FontWeightClass.medium,
    color: ColorUtils.black12,
  );
  static TextStyle poppinsOrangeF87A10Regular =
      poppinsBlack2610Regular.copyWith(
    color: ColorUtils.orangeF87A,
  );
  static TextStyle poppinsOrangeF87AMedium = poppinsBlack2610Regular.copyWith(
    color: ColorUtils.orangeF87A,
    fontSize: 12.sp,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsOrangeF87ASemiB = poppinsOrangeF87AMedium.copyWith(
    color: ColorUtils.orangeF87A,
    fontSize: 9.sp,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsWhiteSp9AMedium = poppinsOrangeF87ASemiB.copyWith(
    color: ColorUtils.white,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsWhite13semiB = poppinsDoveGrey10Normal.copyWith(
    fontSize: 13.sp,
    color: Colors.white,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsYellow13semiB = poppinsWhite13semiB.copyWith(
    color: Colors.yellow,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsWhite11semiB = poppinsDoveGrey10Normal.copyWith(
    fontSize: 12.sp,
    color: Colors.white,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsGrayA8A89Normal = poppinsDoveGrey10Normal.copyWith(
    fontSize: 9.sp,
    color: ColorUtils.grayA8A8,
  );
  static TextStyle poppinsBlackLightNormal = poppinsDoveGrey10Normal.copyWith(
    fontSize: 11.sp,
    color: ColorUtils.blackLightTextField,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsBlackLightRegular = poppinsBlackLightNormal.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsBlack12bold = poppinsWhite20Bold.copyWith(
    fontSize: 12.sp,
    color: ColorUtils.lightBlack,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsDarkBlack12bold = poppinsWhite20Bold.copyWith(
    fontSize: 13.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsDarkBlue2BMedium = poppinsDarkBlack12bold.copyWith(
    color: ColorUtils.blue2B,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsDarkBlackSemiB = poppinsWhite20Bold.copyWith(
    fontSize: 13.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsDarkBlackSp11SemiB = poppinsDarkBlackSemiB.copyWith(
    fontSize: 11.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsBlue14Medium = poppinsWhite20Bold.copyWith(
    fontSize: 12.sp,
    color: ColorUtils.blue14,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsBlue14Sp9Medium = poppinsBlue14Medium.copyWith(
    fontSize: 9.sp,
  );
  static TextStyle poppinsBlackRegular = poppinsWhite20Bold.copyWith(
    fontSize: 11.sp,
    color: Colors.black,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsBlack12SemiB = poppinsWhite20Bold.copyWith(
    fontSize: 12.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsBlack12Sp9SemiB = poppinsBlack12SemiB.copyWith(
    fontSize: 9.sp,
  );
  static TextStyle poppinsBlack10Regular = poppinsWhite20Bold.copyWith(
    fontSize: 10.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsBlack10Medium = poppinsBlack10Regular.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppins11SemiB = poppinsBlack10Regular.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsBlue14NormalNone = poppinsDoveGrey10Normal.copyWith(
    fontSize: 10.sp,
    color: ColorUtils.blue14,
    decoration: TextDecoration.underline,
  );
  static TextStyle poppinsWhite10bold = poppinsDoveGrey10Normal.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static TextStyle poppinsBlue14bold = poppinsWhite10bold.copyWith(
    color: ColorUtils.blue14,
  );
  static TextStyle poppinsMediumBlue = TextStyle(
    fontFamily: poppins,
    color: ColorUtils.primaryColor,
    fontSize: 10.sp,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppins16semmiB = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightClass.semiB,
    color: Colors.white,
    fontFamily: poppins,
  );
  static TextStyle poppins14Medium = poppins16semmiB.copyWith(
    fontWeight: FontWeightClass.medium,
    fontSize: 14.sp,
  );
  static TextStyle poppins12RegularGray = poppins16semmiB.copyWith(
    fontWeight: FontWeightClass.regular,
    fontSize: 12.sp,
    color: ColorUtils.grayHintColor,
  );
  static TextStyle poppins12DarkBlack = poppins16semmiB.copyWith(
    fontWeight: FontWeightClass.semiB,
    fontSize: 12.sp,
    color: ColorUtils.darkBlack,
  );
  static TextStyle poppins14regular = poppins12RegularGray.copyWith(
    fontSize: 14.sp,
    color: ColorUtils.blue14,
  );
  static TextStyle poppins12mediumDarkBlack = poppins14Medium.copyWith(
    color: ColorUtils.darkBlack,
    fontSize: 12.sp,
  );
  static TextStyle poppins12regular = poppins12RegularGray.copyWith(
    color: ColorUtils.blackLightTextField,
    fontSize: 12,
  );
  static TextStyle poppinsSp8regular = poppins12RegularGray.copyWith(
    color: ColorUtils.blackLightTextField,
    fontSize: 8.sp,
  );
  static TextStyle poppins15darkBluesemiB = poppins16semmiB.copyWith(
    color: ColorUtils.darkBlue,
    fontSize: 15.sp,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsBlack9Regular = poppinsDoveGrey10Normal.copyWith(
    fontSize: 9.sp,
    color: ColorUtils.black,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsDarkBlack9Regular = poppinsBlack9Regular.copyWith(
    fontSize: 9.sp,
    color: ColorUtils.blackLightTextField,
    fontWeight: FontWeightClass.regular,
  );
  static TextStyle poppinsDarkBlack9SemiB = poppinsDarkBlack9Regular.copyWith(
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppins12semiB = poppins16semmiB.copyWith(
    fontSize: 10.sp,
    color: ColorUtils.searchTextGray,
  );
  static TextStyle poppinsBlack21Bold = poppinsWhite11semiB.copyWith(
    fontWeight: FontWeightClass.bold,
    color: ColorUtils.darkBlack,
  );
  static TextStyle poppinsDarkBlackNormal = poppinsDoveGrey10Normal.copyWith(
    fontSize: 11.sp,
    color: ColorUtils.darkBlack,
    fontWeight: FontWeightClass.medium,
  );
  static TextStyle poppinsDarkBlacks12Normal = poppinsDarkBlackNormal.copyWith(
    fontSize: 9.sp,
    color: ColorUtils.darkBlack,
  );
  static TextStyle poppinsGrayB3Normal = poppinsDoveGrey10Normal.copyWith(
    fontSize: 9.sp,
    color: ColorUtils.grayB3,
    fontWeight: FontWeightClass.semiB,
  );
  static TextStyle poppinsWhite11normal = poppinsDoveGrey10Normal.copyWith(
    fontSize: 11.sp,
    color: Colors.white,
    fontWeight: FontWeightClass.semiB,
  );

  ///dashboard
  static TextStyle poppins14semiB = poppins12regular.copyWith(
      fontSize: 14, fontWeight: FontWeightClass.semiB);
  static TextStyle poppins11RegularBlue =
      poppins12regular.copyWith(color: ColorUtils.blue14, fontSize: 11.sp);
  static TextStyle roboto10W5grey = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10.sp,
      fontFamily: 'Roboto',
      color: ColorUtils.lightGrey83);
  static TextStyle roboto10W5Black1E = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10.5.sp,
      fontFamily: 'Roboto',
      color: ColorUtils.black1E);

  static TextStyle poppins14RegularBlackLightColor =
      poppins11RegularBlue.copyWith(
    color: ColorUtils.blackLightTextField,
  );
  static TextStyle poppins14SemiBDarkBlack = poppinsDarkBlacks12Normal.copyWith(
      fontWeight: FontWeightClass.semiB, fontSize: 10.sp);
  static TextStyle poppins10NormalDarkBlack =
      poppinsDarkBlacks12Normal.copyWith(fontSize: 10.5.sp);
  static TextStyle poppins12Orange =
      poppins14semiB.copyWith(color: ColorUtils.orange, fontSize: 12.sp);
}
