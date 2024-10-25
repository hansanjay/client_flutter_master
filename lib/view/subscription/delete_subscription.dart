import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/view/subscription/my_subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import '../../models/subscription_model.dart';
import '../../services/subscription_service.dart';

class DeleteSubscription extends StatefulWidget {
  final int id;
  const DeleteSubscription({Key? key, required this.id}) : super(key: key);
  @override
  State<DeleteSubscription> createState() => _DeleteSubscriptionState();
}

class _DeleteSubscriptionState extends State<DeleteSubscription> {
  String? selectedReason;
  List<String> reasons = [
    'Changing the product or subscription - frequency',
    'Placing orders from a different account',
    'Delivery charges are high',
    'Coupon validity is over',
    "Delivery issues - delayed/missed/damaged",
    "Quality is not good",
    "Prices are high",
    "Customer support is not helpful",
    "Coupon did not work as expected",
    "Out of town temporarily",
    "Moving out of society permantely",
    "Prefer local vendor or local shop",
    "Don't need this product anymore",
    "My reason is not listed"
  ];
  bool isSelected = false;
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
    super.initState();
  }

  Future<void> _deleteSubscription() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _subscriptionService.deleteSubscription(widget.id);
      setState(() {
        _isLoading = false;
      });
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Subscription deleted successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MySubscription()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error deleting subscription: $e');
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
              title: Text("Delete Subscription",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Container(
                margin: EdgeInsets.all(6),
                width: _width,
                child: Card(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 20, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/image/remove-from-cart.png",
                                height: 100,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                "Delete Subscription",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 7),
                              child: Center(
                                child: Text(
                                  "Please select accurate reasons for subscription deletion so that we can improve our service",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reasons.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RadioListTile<String>(
                                  title: Text(
                                    reasons[index],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  value: reasons[index],
                                  groupValue: selectedReason,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedReason = value;
                                      isSelected = true;
                                    });
                                  },
                                );
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Note: ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            " Please select accurate reason for quicker refund process in case of payment",
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Container(
                                width: _width,
                                height: 80,
                                padding: const EdgeInsets.all(16),
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
                                    _deleteSubscription();
                                  },
                                  child: Text(
                                    "DELETE SUBSCRIPTION",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ))),
              )))
            ])));
  }
}
