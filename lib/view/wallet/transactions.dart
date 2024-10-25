import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/variable_utils.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});
  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String balance2 = "";
  var amount = [];
  var recipient = [];
  var id = [];
  var date = [];
  var senderName = [];
  @override
  void initState() {
    getSP();
    super.initState();
  }

  void getSP() async {
    balance2 = "500";
    setState(() {});
  }

  String formatDate(DateTime dateTime) {
    String formattedDate =
        "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}";
    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
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
              title: Text("All Transactions",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      if (1 > 0)
                        Column(
                          children: [
                           Align(alignment: Alignment.centerLeft,child:  Padding(
                             padding: EdgeInsets.all(17),
                             child:Text("April 2024"),

                           ),),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Wallet Balance Deposit",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "13 April 2024",
                                              style: TextStyle(fontSize: 10,color: ColorUtils.black2D),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: Icon(Icons.south_east,color: Colors.green,size: 20,),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("+ ₹" + "500",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Text(
                                          "Bal: ₹500",
                                          style: TextStyle(color: ColorUtils.black2D,fontSize: 10,fontWeight:FontWeight.normal),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                      thickness: 1,
                                      color: Colors.black12,
                                    ),
                                itemCount: 5)
                          ],
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              height: 170,
                            ),
                            Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )
                          ],
                        )
                    ]),
                  ),
                )
              ],
            )));
  }

  void onPressed() {}
}
