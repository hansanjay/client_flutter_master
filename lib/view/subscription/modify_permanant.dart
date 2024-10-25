import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import '../../models/subscription_model.dart';
import '../../services/subscription_service.dart';
import '../general_screens/shimmer_product_list.dart';
import 'my_subscriptions.dart';

class ModifyPermanant extends StatefulWidget {
  final int id;
  const ModifyPermanant({Key? key, required this.id}) : super(key: key);
  @override
  State<ModifyPermanant> createState() => _ModifyPermanantState();
}

class _ModifyPermanantState extends State<ModifyPermanant> {
  bool showPauseBtn = true;
  int _counter = 1;
  late SubscriptionService _subscriptionService;
  bool _isLoading = false;
  Subscription? _subscription;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _subscriptionService = SubscriptionService();
    _fetchSubscription();
    super.initState();
  }
  Future<void> _fetchSubscription() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Subscription subscription = await _subscriptionService.getSubscriptionById(widget.id);
      setState(() {
        _subscription = subscription;
        _isLoading = false;
        _counter=_subscription!.quantity;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching subscription: $e');
    }
  }
  void _updateSubscription(int id) async {
    try {
      Map<String, dynamic> updates = {
        "changeType": 1,
        "quantity": _counter,
      };
      await _subscriptionService.updateSubscription(id, updates);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Subscription modified successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MySubscription()));
    } catch (e) {
      print("Error: "+e.toString());
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
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
                  Navigator.pop(context);
                },
              ),
              title: Text("Update Permanently",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: _isLoading ? ShimmerProductList() : Stack(children: [
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
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  5.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "$baseUrl/" +_subscription!.product.imageUrl),
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
                                                _subscription!.product.brand,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                _subscription!.product.title,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                _subscription!.product.weightDisplay,
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
                                                    VariableUtils.rupee + _subscription!.product.mrp.toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
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
                                                  border: Border.all(color: Colors.black),
                                                  radius: const Radius.circular(20),
                                                  elevation: 0,
                                                  buttonAspectRatio: 1.5,
                                                ),
                                                didChangeCount: (count) {
                                                  _counter = count;
                                                  setState(() {
                                                    if (count < 1) {
                                                      showPauseBtn = false;
                                                    }
                                                    else
                                                    {
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
                              side: const BorderSide(color: ColorUtils.black),
                            ),
                          ),
                          onPressed: () {
                            _updateSubscription(_subscription!.id);
                          },
                          child: Text(
                            "UPDATE SUBSCRIPTION",
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
