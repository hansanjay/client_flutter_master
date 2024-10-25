import 'dart:convert';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/dashboard/dashboard.dart';
import 'package:client_flutter_master/view/order/my_orders.dart';
import 'package:client_flutter_master/view/order/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../services/order_service.dart';
import '../general_screens/shimmer_product_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
class ModifyOrder extends StatefulWidget {
  final int orderId;
  final int lineId;
  final DateTime dateTime;
  const ModifyOrder({Key? key, required this.orderId, required this.lineId, required this.dateTime})
      : super(key: key);
  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  bool showPauseBtn = true;
  int _counter = 1;
  bool _isLoading = false;
  Map<String, dynamic>? _orderDetail;
  late DateTime selectedDate;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _fetchOrderDetail();
    super.initState();
  }

  Future<void> _fetchOrderDetail() async {
    _isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("Token");
    String appId =
        '${prefs.getString("DeviceId")}_${prefs.getString("Mobile")}';

    final response = await http.get(
      Uri.parse(
          '$baseUrl/order/${widget.orderId}/line/${widget.lineId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-app-id-token': appId,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _orderDetail = data;
        _isLoading = false;
        _counter=_orderDetail!['quantity'];
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load order details');
    }
  }
  Future<void> _updateOrder(int orderId, int productId, int quantity) async {
    Map<String, dynamic> orderPayload = {
      'lines': [
        {'product_id': productId, 'quantity': quantity},
      ],
    };

    try {
      await OrderService().updateOrder(orderPayload, orderId);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Order modified successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.push(context,  MaterialPageRoute(builder: (context) => Orders(date: widget.dateTime)));
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error updating order: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Dashboard()),
                  // );
                  Navigator.pop(context);
                  // Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Orders(date: widget.dateTime)));
                },
              ),
              title: Text("Modify Order",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: _isLoading
                ? ShimmerProductList()
                : Stack(children: [
                    Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "$baseUrl/" +
                                                      _orderDetail!['product']['image_url']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _orderDetail!['product']['brand'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              _orderDetail!['product']['title'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _orderDetail!['product']['weightDisplay'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorUtils.grey85),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "MRP:  ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  VariableUtils.rupee +
                                                      _orderDetail!['product']['price'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            CartStepperInt(
                                              value: _counter,
                                              size: 30,
                                              style: CartStepperStyle(
                                                foregroundColor: Colors.black,
                                                activeForegroundColor: Colors.black,
                                                activeBackgroundColor: Colors.white,
                                                border:
                                                Border.all(color: Colors.black),
                                                radius: const Radius.circular(20),
                                                elevation: 0,
                                                buttonAspectRatio: 1.5,
                                              ),
                                              didChangeCount: (count) {
                                                _counter = count;
                                                setState(() {
                                                  if (count < 1) {
                                                    showPauseBtn = false;
                                                  } else {
                                                    showPauseBtn = true;
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ])))
                    ]),
                    Visibility(
                      visible: showPauseBtn,
                      child: Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              width: _width,
                              padding: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorUtils.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        color: ColorUtils.black),
                                  ),
                                ),
                                onPressed: () {
                                  _updateOrder(widget.orderId,_orderDetail!['product_id'],_counter);
                                },
                                child: Text(
                                  "UPDATE ORDER",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])));
  }
}
