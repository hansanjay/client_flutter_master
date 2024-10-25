import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/size_config_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController pin = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool _showPinView = false,validateMobNo=false;
  int countdown = 0;
  String? lastVerificationId;
  bool _loading = false;
  String deviceId = '',gid='';
  @override
  void initState() {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ));
    super.initState();
  }
  @override
  void dispose() {
    mobileNumber.dispose();
    pin.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }
  Future<String> generateGUID() async {
    final String gid = '${await s4()}${await s4()}-${await s4()}-${await s4()}-${await s4()}-${await s4()}${await s4()}${await s4()}';
    return gid;
  }

  Future<String> s4() async {
    final Random random = Random();
    return (1 + random.nextInt(0x10000)).toRadixString(16).substring(1);
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return '';
  }

  Future<void> _sendOTP() async {
    try {
      String? uniqueid = await getDeviceId();
      gid=await generateGUID();
      String url = '$baseUrl/otp?rid=$gid';

      Map<String, dynamic> requestBody = {
        "deviceId": uniqueid,
        "principal": mobileNumber.text.toString()
      };

      String requestBodyJson = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 204) {
        AnimatedSnackBar.material(
          duration: const Duration(seconds: 5),
          VariableUtils.otpSent,
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        setState(() {
          _showPinView = true;
          validateMobNo = false;
        });
        print('Request Body: ${requestBodyJson.toString()}');
      } else {
        AnimatedSnackBar.material(
          duration: const Duration(seconds: 5),
          response.body.toString(),
          type: AnimatedSnackBarType.error,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        print('Failed with status code: ${response.statusCode}');
        setState(() {
          _showPinView = false;
          validateMobNo = false;
        });
        print('Request Body: ${requestBodyJson.toString()}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> _verifyOTP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? uniqueid = await getDeviceId();

      String url = '$baseUrl/auth?rid=$gid';

      Map<String, dynamic> requestBody = {
        "deviceId": uniqueid,
        "principal": mobileNumber.text.toString(),
        "otp": pin.text.toString()
      };

      String requestBodyJson = json.encode(requestBody);

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        prefs.setString("Token", data['Token']);
        prefs.setString("Expiry", data['Expiry']);
        prefs.setBool("Login", true);
        prefs.setString("DeviceId", uniqueid!);
        prefs.setString("Mobile", mobileNumber.text.toString());
        AnimatedSnackBar.material(
          duration: const Duration(seconds: 5),
          VariableUtils.loginSuccess,
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Dashboard()));
        print('Response Body: ${response.body.toString()}');
        print('Request Body: ${requestBodyJson.toString()}');
      } else {
        var data = jsonDecode(response.body);
        print('Failed with status code: ${response.body.toString()}');
        print('Request Body: ${requestBodyJson.toString()}');
        AnimatedSnackBar.material(
          duration: const Duration(seconds: 5),
          data['message'].toString(),
          type: AnimatedSnackBarType.error,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          SystemNavigator.pop();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: _height,
              width: _width,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizeConfig.sH2,
                    Center(
                      child: Text(
                        VariableUtils.login,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        VariableUtils.loginAccount,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 12,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: _height * .01,
                    ),
                    SizedBox(
                      height: _height * .35,
                      width: _width * .75,
                      child: Image.asset(loginImage),
                    ),
                    SizedBox(
                      height: _height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15),
                      child: IntlPhoneField(
                        focusNode: focusNode,
                        controller: mobileNumber,
                        style: TextStyle(fontSize: 17),
                        decoration:  InputDecoration(
                          hintText: VariableUtils.mobileHint,
                          counterText: '',
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.black,
                              width: 10,
                            ),
                          ),
                          errorText: validateMobNo ? VariableUtils.validMobNo : null,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.black,
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.black,
                              width: 0.5,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.black,
                              width: 0.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: ColorUtils.black,
                              width: 0.5,
                            ),
                          ),
                        ),
                        flagsButtonPadding: const EdgeInsets.only(left: 5),
                        showDropdownIcon: false,
                        disableLengthCheck: false,
                        initialCountryCode: "IN",
                        onChanged: (phone) {},
                        onCountryChanged: (country) async {},
                      ),
                    ),
                    Visibility(
                      visible: _showPinView,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 80, right: 80),
                            child: PinCodeTextField(
                              textInputAction: TextInputAction.done,
                              controller: pin,
                              showCursor: false,
                              pinTheme: PinTheme(
                                borderRadius: BorderRadius.circular(5),
                                shape: PinCodeFieldShape.box,
                                fieldHeight: 45,
                                fieldWidth: 45,
                                activeColor: ColorUtils.black,
                                borderWidth: 1,
                                inactiveColor: ColorUtils.black,
                              ),
                              keyboardType: TextInputType.number,
                              appContext: context,
                              length: 4,
                              enablePinAutofill: true,
                              dialogConfig: DialogConfig(
                                dialogContent: VariableUtils.pasteOTPMessage,
                              ),
                              onChanged: (String value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    if (countdown == 0) {
                                      setState(() {
                                        countdown = 15;
                                      });
                                      _sendOTP();
                                      startTimer();
                                    }
                                  },
                                  child: Text(
                                    countdown <= 0
                                        ? VariableUtils.resendOTP
                                        : "Resend OTP in $countdown seconds",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _height * .01,
                    ),
                    Container(
                      width: _width,
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUtils.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: ColorUtils.black),
                          ),
                        ),
                        onPressed: () {
                          if (!_showPinView) {
                            if(mobileNumber.text.isEmpty || mobileNumber.text.length<10){
                              setState(() {
                                validateMobNo = true;
                              });
                              focusNode.requestFocus();
                            }
                            else
                              {
                                _sendOTP();
                              }
                          } else {
                            if(pin.text.isEmpty || pin.text.length<4){
                            AnimatedSnackBar.material(
                              duration: const Duration(seconds: 5),
                              VariableUtils.validOTP,
                              type: AnimatedSnackBarType.error,
                              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                            ).show(context);
                            }
                            else
                              {
                                _verifyOTP();
                              }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              _showPinView
                                  ? VariableUtils.proceedSecurely
                                  : VariableUtils.getOTP,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
