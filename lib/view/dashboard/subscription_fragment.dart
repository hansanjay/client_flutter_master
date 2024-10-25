import 'dart:convert';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/view/subscription/modify_permanant.dart';
import 'package:client_flutter_master/view/subscription/modify_temporary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import '../../models/subscription_model.dart';
import '../../services/subscription_service.dart';
import '../../utils/variable_utils.dart';
import '../general_screens/no_data_found.dart';
import '../general_screens/shimmer_product_list.dart';
import '../subscription/delete_subscription.dart';
import '../subscription/my_subscriptions.dart';
import '../subscription/pause_subscription.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class SubscriptionFragment extends StatefulWidget {
  const SubscriptionFragment({Key? key}) : super(key: key);
  @override
  State<SubscriptionFragment> createState() => _SubscriptionFragmentState();
}

class _SubscriptionFragmentState extends State<SubscriptionFragment> {
  late SubscriptionService _subscriptionService;
  bool _isLoading = false;
  List<Subscription> _subscriptions = [];
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
    _subscriptionService = SubscriptionService();
    _fetchSubscriptions();
  }

  Future<void> _fetchSubscriptions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Subscription> subscriptions =
          await _subscriptionService.fetchSubscriptions(offset: 0, limit: 10);
      setState(() {
        _subscriptions = subscriptions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching subscriptions: $e');
    }
  }

  Future<void> _resumeSubscription(int id) async {
    try {
      await _subscriptionService.resumeSubscription(id);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Subscription resumed successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MySubscription()));
    } catch (e) {
      print('Error fetching subscriptions: $e');
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
              title: Text(VariableUtils.mySubscrip,
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
                : (_subscriptions.length > 0
                    ? Column(children: [
                        Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1,
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(_subscriptions.length,
                                    (index) {
                                  var subsProduct = _subscriptions[index];
                                  return InkWell(
                                    onTap: () async {},
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Card(
                                        surfaceTintColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    VariableUtils.subscription +
                                                        ":",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    subsProduct.type == 1
                                                        ? " Daily"
                                                        : subsProduct.type == 2
                                                            ? " Weekly"
                                                            : " Monthly",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Divider(
                                                height: 1,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "$baseUrl/" +
                                                                subsProduct
                                                                    .product
                                                                    .imageUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        subsProduct
                                                            .product.brand,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        subsProduct
                                                            .product.title,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        subsProduct.product
                                                            .weightDisplay,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorUtils
                                                                .grey85),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        "Quantity:  " +
                                                            subsProduct.quantity
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: ColorUtils
                                                                .grey85),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "MRP:  ",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            VariableUtils
                                                                    .rupee +
                                                                subsProduct
                                                                    .product.price
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              if(!subsProduct.permanent)
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Your subscription has been modified from "+subsProduct.start.toString().substring(0,10)+" to "+subsProduct.stop.toString().substring(0,10)+". You can resume to continue the services",
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          color: ColorUtils
                                                              .red),maxLines: 2,overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                )
                                              else if(subsProduct.status==2)
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Your subscription has been paused from "+subsProduct.pause.toString().substring(0,10)+" to "+subsProduct.resume.toString().substring(0,10)+". You can resume to continue the services",
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          color: ColorUtils
                                                              .red),maxLines: 2,overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                height: 1,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  if (subsProduct.permanent)
                                                    InkWell(
                                                      onTap: () {
                                                        Dialogs.materialDialog(
                                                            msg: VariableUtils
                                                                .modifyMsg,
                                                            title: VariableUtils
                                                                .modifyTitle,
                                                            color: Colors.white,
                                                            context: context,
                                                            actions: [
                                                              Expanded(
                                                                child: Container(
                                                                    child: OutlinedButton(
                                                                  child: Text(
                                                                    VariableUtils
                                                                        .tmpry,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            9),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(context);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => ModifyTemporary(
                                                                                  id: subsProduct.id,
                                                                                )));
                                                                  },
                                                                )),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                    child: new OutlinedButton(
                                                                        style: OutlinedButton.styleFrom(backgroundColor: Colors.black),
                                                                        child: new Text(VariableUtils.prmtly, style: TextStyle(color: Colors.white, fontSize: 9)),
                                                                        onPressed: () {
                                                                          Navigator.pop(context);
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ModifyPermanant(
                                                                                        id: subsProduct.id,
                                                                                      )));
                                                                        })),
                                                              ),
                                                            ]);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .calendar_month_outlined,
                                                            size: 15,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            VariableUtils
                                                                .modify,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (subsProduct.permanent)
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  if (subsProduct.permanent)
                                                    Container(
                                                      width: 1.0,
                                                      height: 10.0,
                                                      color: Colors.black,
                                                    ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Dialogs.materialDialog(
                                                          msg: VariableUtils
                                                              .dltDlgMsg,
                                                          title: VariableUtils
                                                              .delete,
                                                          color: Colors.white,
                                                          context: context,
                                                          actions: [
                                                            OutlinedButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              label: Text(
                                                                VariableUtils
                                                                    .cancel,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                              ),
                                                            ),
                                                            OutlinedButton.icon(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => DeleteSubscription(
                                                                              id: subsProduct.id,
                                                                            )));
                                                              },
                                                              icon: Icon(
                                                                Icons.delete,
                                                                size: 15,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              label: Text(
                                                                VariableUtils
                                                                    .delete,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .red),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                              ),
                                                            ),
                                                          ]);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.delete_outline,
                                                          size: 13,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          VariableUtils.delete
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 1.0,
                                                    height: 10.0,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  if (subsProduct.permanent)
                                                  InkWell(
                                                    onTap: () {
                                                      Dialogs.materialDialog(
                                                          msg: VariableUtils
                                                              .pusDlgMsg,
                                                          title: VariableUtils
                                                              .pause,
                                                          color: Colors.white,
                                                          context: context,
                                                          actions: [
                                                            OutlinedButton.icon(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              label: Text(
                                                                VariableUtils
                                                                    .cancel,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                              ),
                                                            ),
                                                            OutlinedButton.icon(
                                                              onPressed: () {
                                                                if (subsProduct
                                                                        .status ==
                                                                    1 ) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PauseSubscription(
                                                                                id: subsProduct.id,
                                                                              )));
                                                                  print("Id: "+subsProduct.id.toString());
                                                                }
                                                                else {
                                                                  _resumeSubscription(
                                                                      subsProduct
                                                                          .id);
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .pause_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              label: Text(
                                                                subsProduct.status ==
                                                                        1
                                                                    ? VariableUtils
                                                                        .pause
                                                                    : "RESUME",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .green),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                              ),
                                                            ),
                                                          ]);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .pause_circle_outline,
                                                          size: 15,
                                                          color: Colors.green,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          subsProduct.status ==
                                                                  1
                                                              ? VariableUtils
                                                                  .pause
                                                                  .toUpperCase()
                                                              : "RESUME",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  else
                                                    InkWell(
                                                      onTap: () {
                                                        _resumeSubscription(
                                                            subsProduct
                                                                .parent_id);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .pause_circle_outline,
                                                            size: 15,
                                                            color: Colors.green,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "RESUME",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ],
                          )),
                        )
                      ])
                    : NoDataFound())));
  }
}
