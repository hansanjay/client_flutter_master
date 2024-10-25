import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/support/raise_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/color_utils.dart';

class Support extends StatefulWidget {
  const Support({super.key});
  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text("24x7 Customer Support",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: const Color(0xffE8E6EA),
          body: Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Material(
                      elevation: 1,
                      color: ColorUtils.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        child: ListTile(
                          title: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Icon(
                                        Icons.support_agent,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "Get quick support by selecting your item",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Material(
                      elevation: 1,
                      color: ColorUtils.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5),
                        child: ListTile(
                            leading: Image.asset("assets/icon/tracking.png",height: 20,),
                            title: Text(
                              "Previous tickets/issues",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            )),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Material(
                      elevation: 1,
                      color: ColorUtils.white,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  "Select order to raise issue",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(2, (index) {
                                  return InkWell(
                                    onTap: () async {},
                                    child: Card(
                                        elevation: 3,
                                        surfaceTintColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 10,
                                                bottom: 3),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "May 7 2024, 12:38 PM",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[700],
                                                            )),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.black,
                                                            size: 15,
                                                          ),
                                                          onPressed: () {},
                                                        ),
                                                      ]),
                                                  Divider(
                                                    height: 1,
                                                  ),
                                                  ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Items:",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                "Amul Gold x 1, Amul Toned Milk x 5, Amul Paneer x 2",
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        900],
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Paid:",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Text(
                                                              VariableUtils
                                                                      .rupee +
                                                                  "28",
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .lightBlue,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]))),
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 0.5,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.menu,
                                  size: 15,
                                ),
                                  title: Text(
                                    "View more",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                            ],
                          ))),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                      elevation: 1,
                      color: ColorUtils.white,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  "What issue are you facing?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaiseTicket(
                                                  issueType: 'Order',
                                                )));
                                  },
                                  leading: Image.asset("assets/icon/order.png",height: 20,),
                                  title: Text(
                                    "Order",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                              Divider(
                                height: 0.5,
                              ),
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaiseTicket(
                                                  issueType: 'Payment',
                                                )));
                                  },
                                  leading: Image.asset("assets/icon/payment.png",height: 20,),
                                  title: Text(
                                    "Payment",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                              Divider(
                                height: 0.5,
                              ),
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaiseTicket(
                                                  issueType: 'Subscription',
                                                )));
                                  },
                                  leading: Image.asset("assets/icon/subscription-model.png",height: 20,),
                                  title: Text(
                                    "Subscription",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                              Divider(
                                height: 0.5,
                              ),
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaiseTicket(
                                                  issueType: 'Wallet',
                                                )));
                                  },
                                  leading: Image.asset("assets/icon/wallet.png",height: 20,),
                                  title: Text(
                                    "Wallet",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                              Divider(
                                height: 0.5,
                              ),
                              ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RaiseTicket(
                                                  issueType: 'Others',
                                                )));
                                  },
                                  leading: Image.asset("assets/icon/file.png",height: 20,),
                                  title: Text(
                                    "Others",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  )),
                            ],
                          ))),
                  SizedBox(
                    height: 100,
                  ),
                ])))
          ]),
        ));
  }
}
