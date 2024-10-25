import 'dart:convert';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/subscription/my_subscriptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import '../../models/subscription_model.dart';
import '../../services/subscription_service.dart';
import '../general_screens/shimmer_product_list.dart';
final today = DateUtils.dateOnly(DateTime.now());

class PauseSubscription extends StatefulWidget {
  final int id;
  const PauseSubscription({Key? key, required this.id}) : super(key: key);
  @override
  State<PauseSubscription> createState() => _PauseSubscriptionState();
}

class _PauseSubscriptionState extends State<PauseSubscription> {
  List<DateTime?> fromDate = [DateTime(today.year, today.month, today.day + 1)];
  List<DateTime?> toDate = [DateTime(today.year, today.month, today.day + 1)];
  String selectedFromDate = "", selectedToDate = "";
  bool showPauseBtn = true;
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

    selectedFromDate = DateFormat('yyyy-MM-dd').format(fromDate[0]!);
    selectedToDate = DateFormat('yyyy-MM-dd').format(toDate[0]!);
    _subscriptionService = SubscriptionService();
    _fetchSubscription();
    super.initState();
  }
  Future<void> _pauseSubscription() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _subscriptionService.pauseSubscription(widget.id, selectedFromDate, selectedToDate);
      setState(() {
        _isLoading = false;
      });
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Subscription paused successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MySubscription()));
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
      print('Error pausing subscription: $e');
    }
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
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching subscription: $e');
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
              title: Text("Pause Subscription",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: _isLoading ? ShimmerProductList() :
            Stack(children: [
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
                                            fontSize: 16,
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Select Dates",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Material(
                            elevation: 1,
                            color: ColorUtils.white,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListTile(
                                            onTap: (){
                                              showMaterialModalBottomSheet(
                                                  expand: false,
                                                  context: context,
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  builder: (context) =>
                                                      showFromModal(context));
                                            },
                                            leading: Icon(
                                              Icons.calendar_month_outlined,
                                              color: ColorUtils.black,
                                              size: 25,
                                            ),
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "From Date",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  selectedFromDate,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                showMaterialModalBottomSheet(
                                                    expand: false,
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    builder: (context) =>
                                                        showFromModal(context));
                                              },
                                            )),
                                        Divider(
                                          height: 1,
                                        ),
                                        ListTile(
                                          onTap: (){
                                            showMaterialModalBottomSheet(
                                                expand: false,
                                                context: context,
                                                backgroundColor:
                                                Colors.transparent,
                                                builder: (context) =>
                                                    showToModal(context));
                                          },
                                            leading: Icon(
                                              Icons.calendar_month_outlined,
                                              color: ColorUtils.black,
                                              size: 25,
                                            ),
                                            title: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "To Date",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  selectedToDate,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                showMaterialModalBottomSheet(
                                                    expand: false,
                                                    context: context,
                                                    backgroundColor:
                                                    Colors.transparent,
                                                    builder: (context) =>
                                                        showToModal(context));
                                              },
                                            )),
                                      ],
                                    )
                                  ],
                                ))),
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
                            _pauseSubscription();
                          },
                          child: Text(
                            "PAUSE SUBSCRIPTION",
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

  Widget showFromModal(context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Select From Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.close, size: 30),
              onTap: () {
                // setState(() {
                //   selectedFromDate = "";
                //   showPauseBtn=false;
                // });
                Navigator.pop(context);
              },
            ),
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  firstDate: DateTime(today.year, today.month, today.day + 1),
                  selectedDayHighlightColor: Colors.black),
              value: fromDate,
              onValueChanged: (dates) => fromDate = dates,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Container(
                          child: OutlinedButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          // setState(() {
                          //   selectedFromDate = "";
                          //   showPauseBtn=false;
                          // });
                          Navigator.pop(context);
                        },
                      )),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                          child: new OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: new Text("Done",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                                  if (fromDate.first!.isBefore(toDate.first!)) {
                                    String formattedDate =
                                    DateFormat(
                                        'yyyy-MM-dd')
                                        .format(fromDate[0]!);
                                    selectedFromDate = formattedDate;
                                    setState(() {
                                      if(selectedToDate.length>0 && selectedFromDate.length>0){
                                        showPauseBtn = true;
                                      }
                                      else
                                      {
                                        showPauseBtn = false;
                                      }
                                    });
                                  } else if (fromDate.first!.isAfter(toDate.first!)) {
                                    String formattedDate =
                                    DateFormat(
                                        'yyyy-MM-dd')
                                        .format(fromDate[0]!);
                                    setState(() {
                                      selectedFromDate = formattedDate;
                                      selectedToDate=formattedDate;
                                      showPauseBtn=true;
                                    });
                                    // AnimatedSnackBar.material(
                                    //   duration: const Duration(seconds: 4),
                                    //   "From Date can't be greater than Do Date",
                                    //   type: AnimatedSnackBarType.error,
                                    //   mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                                    // ).show(context);
                                  } else {
                                    print("fromDate is equal to toDate");
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(fromDate[0]!);
                                    selectedFromDate = formattedDate;
                                    setState(() {
                                      if(selectedToDate.length>0 && selectedFromDate.length>0){
                                        showPauseBtn = true;
                                      }
                                      else
                                      {
                                        showPauseBtn = false;
                                      }
                                    });
                                  }
                                }
                                Navigator.pop(context);
                              })),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget showToModal(context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Select To Date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.close, size: 30),
              onTap: () {
                setState(() {
                  selectedToDate = "";
                  showPauseBtn=false;
                });
                Navigator.pop(context);
              },
            ),
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  firstDate: DateTime(today.year, today.month, today.day + 1),
                  selectedDayHighlightColor: Colors.black),
              value: toDate,
              onValueChanged: (dates) => toDate = dates,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Container(
                          child: OutlinedButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedToDate = "";
                                showPauseBtn=false;
                              });
                              Navigator.pop(context);
                            },
                          )),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Container(
                          child: new OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: new Text("Done",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                                  if (fromDate.first!.isBefore(toDate.first!)) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(toDate[0]!);
                                    selectedToDate = formattedDate;
                                    setState(() {
                                      if(selectedToDate.length>0 && selectedFromDate.length>0){
                                        showPauseBtn = true;
                                      }
                                      else
                                      {
                                        showPauseBtn = false;
                                      }
                                    });
                                  } else if (fromDate.first!.isAfter(toDate.first!)) {
                                    setState(() {
                                      selectedToDate = "";
                                      showPauseBtn=false;
                                    });
                                    AnimatedSnackBar.material(
                                      duration: const Duration(seconds: 4),
                                      "From Date can't be greater than Do Date",
                                      type: AnimatedSnackBarType.error,
                                      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                                    ).show(context);
                                  } else {
                                    print("fromDate is equal to toDate");
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(toDate[0]!);
                                    selectedToDate = formattedDate;
                                    setState(() {
                                      if(selectedToDate.length>0 && selectedFromDate.length>0){
                                        showPauseBtn = true;
                                      }
                                      else
                                      {
                                        showPauseBtn = false;
                                      }
                                    });
                                  }
                                }
                                Navigator.pop(context);
                              })),
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}