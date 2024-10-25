import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dashboard/dashboard.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController amount = TextEditingController(text: '1000');
  final TextEditingController balance = TextEditingController(text: '500');
  bool isLoading = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    super.initState();
  }

  void onChangeFunc(String query) {
    setState(() {});
  }

  void addFunc(String amountM) {
    if (amount.text.isEmpty) {
      amount.text = amountM;
    } else {
      amount.text = (int.parse(amountM) + int.parse(amount.text)).toString();
    }

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: PopScope(
                canPop: false,
                onPopInvoked: (didPop) async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Scaffold(
                    appBar: AppBar(
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: Colors.black,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(VariableUtils.myWallet,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w500)),
                      centerTitle: true,
                    ),

                    body: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(
                            children: <Widget>[
                              Column(
                                children: [
                                  Container(
                                    height: _height * 0.15,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(
                                          child: Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                          width: _width,
                                          child: Card(
                                              color: Colors.white,
                                              surfaceTintColor: Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              VariableUtils
                                                                  .walletBalance,
                                                              style: TextStyle(
                                                                fontSize: 17.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              VariableUtils
                                                                      .rupee +
                                                                  " " +
                                                                  balance.text,
                                                              style: TextStyle(
                                                                fontSize: 23.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ]))),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: _width,
                                          child: Card(
                                              surfaceTintColor: Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          VariableUtils
                                                              .addMoney,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        TextField(
                                                          onChanged:
                                                              onChangeFunc,
                                                          controller: amount,
                                                          textAlign:
                                                              TextAlign.start,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              new InputDecoration(
                                                            prefixIcon:
                                                                TextButton(
                                                              onPressed: () {},
                                                              child: Text(
                                                                VariableUtils
                                                                    .rupee,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                            ),
                                                            border:
                                                                new OutlineInputBorder(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                const Radius
                                                                    .circular(
                                                                    5),
                                                              ),
                                                              borderSide:
                                                                  new BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  addFunc(
                                                                      "100");
                                                                },
                                                                child: Chip(
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2.0),
                                                                  label: Text(
                                                                    "+ ₹100",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  addFunc(
                                                                      "200");
                                                                },
                                                                child: Chip(
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2.0),
                                                                  label: Text(
                                                                    "+ ₹200",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  addFunc(
                                                                      "500");
                                                                },
                                                                child: Chip(
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2.0),
                                                                  label: Text(
                                                                    "+ ₹500",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  addFunc(
                                                                      "1000");
                                                                },
                                                                child: Chip(
                                                                  labelPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              2.0),
                                                                  label: Text(
                                                                    "+ ₹1000",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                              )
                                                            ]),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          width: _width,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF000000),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  side: BorderSide(
                                                                      color: Color(
                                                                          0xFF000000)),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                              },
                                                              child: Text(
                                                                amount.text.length >
                                                                        0
                                                                    ? VariableUtils
                                                                            .proAddRupee +
                                                                        amount
                                                                            .text
                                                                    : VariableUtils
                                                                        .proceed,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        ),
                                                      ]))),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: _width,
                                          child: Card(
                                              surfaceTintColor: Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.network(
                                                          analytic,
                                                          height: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Text(
                                                          VariableUtils
                                                              .vwSpndAnalytic,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ]))),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: _width,
                                          child: Card(
                                              surfaceTintColor: Colors.white,
                                              child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.menu_book,
                                                              color: Colors
                                                                  .indigoAccent,
                                                              size: 30,
                                                            ),
                                                            SizedBox(
                                                              width: 18,
                                                            ),
                                                            Text(
                                                              VariableUtils
                                                                  .passbook,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .notifications_active,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 30,
                                                            ),
                                                            SizedBox(
                                                              width: 18,
                                                            ),
                                                            Text(
                                                              VariableUtils
                                                                  .setPmntReminder,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .article_outlined,
                                                              color: Colors
                                                                  .deepPurpleAccent,
                                                              size: 30,
                                                            ),
                                                            SizedBox(
                                                              width: 18,
                                                            ),
                                                            Text(
                                                              VariableUtils
                                                                  .rqtWalletStmt,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black87),
                                                            ),
                                                          ],
                                                        ),
                                                      ]))),
                                        ),
                                      ],
                                    ),
                                  )))
                                ],
                              )
                            ],
                          )))));
  }
}
