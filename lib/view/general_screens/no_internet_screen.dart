import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NoInterNetConnected extends StatelessWidget {
  const NoInterNetConnected({Key? key}) : super(key: key);
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
                  noInternet,
                  scale: 3,
                ),
                Text(
                  VariableUtils.noInternetText,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp),
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
