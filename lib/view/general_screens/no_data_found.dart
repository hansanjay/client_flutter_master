import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            SystemNavigator.pop();
          },
          child: SizedBox(
            width: _width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/image/nodata.jpg",
                  scale: 3,
                  height: 200,
                ),
                Text(
                  "No Data Found",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
