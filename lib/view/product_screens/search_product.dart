import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';
import '../../utils/color_utils.dart';
import '../../utils/variable_utils.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);
  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  bool showCounter = false;
  int _counter = 1;
  String _selectedOption = 'Relevance';
  final TextEditingController searchController = TextEditingController();
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
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text("Search",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Color(0xffE8E6EA),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                  elevation: 1,
                  color: ColorUtils.white,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              margin: EdgeInsets.only(left: 15,right: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                        hintText: 'Search...',
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  if (searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                                leading: Text("61 Products found",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                trailing: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Sort By',
                                            style: TextStyle(color: Colors.black,fontSize: 14),
                                          ),
                                        ),
                                        PopupMenuButton(
                                          surfaceTintColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.arrow_drop_down),
                                          itemBuilder: (BuildContext context) => [
                                            PopupMenuItem(

                                              child: RadioListTile(
                                                title: Text('Relevance'),
                                                value: 'Relevance',
                                                groupValue: _selectedOption,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedOption = value.toString();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: RadioListTile(
                                                title: Text('Price - Low to High'),
                                                value: 'Price - Low to High',
                                                groupValue: _selectedOption,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedOption = value.toString();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: RadioListTile(
                                                title: Text('Price - High to Low'),
                                                value: 'Price - High to Low',
                                                groupValue: _selectedOption,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedOption = value.toString();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            )
                          ]))),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: List.generate(10, (index) {
                    return InkWell(
                      onTap: () async {},
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Card(
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                7),
                          ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrugS4d8Jm_zoJKdgjo9vuNLIe_CBAdbnmjaXRLfAkOA&s"),
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
                                          "Amul",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "Amul Gold",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "1L",
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
                                              VariableUtils.rupee + "66",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 10.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      showCounter
                                          ? CartStepperInt(
                                        value: _counter,
                                        size: 25,
                                        style: CartStepperStyle(
                                          foregroundColor: Colors.black,
                                          activeForegroundColor:
                                          Colors.black,
                                          activeBackgroundColor:
                                          Colors.white,
                                          border: Border.all(
                                              color: Colors.black),
                                          radius:
                                          const Radius.circular(20),
                                          elevation: 0,
                                          buttonAspectRatio: 2,
                                        ),
                                        didChangeCount: (count) {
                                          if (count < 1) {
                                            setState(() {
                                              _counter = count;
                                              showCounter = false;
                                            });
                                          } else {
                                            setState(() {
                                              _counter = count;
                                              showCounter = true;
                                            });
                                          }
                                        },
                                      )
                                          : Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10.0),
                                          child: Container(
                                              height: 30,
                                              child: OutlinedButton(
                                                child: Text(
                                                  "Buy Once",
                                                  style: TextStyle(
                                                      color:
                                                      Colors.black,fontSize: 12),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _counter = 1;
                                                    showCounter = true;
                                                  });
                                                },
                                              )),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Container(
                                              height: 30,
                                              child: new OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Colors
                                                        .black),
                                                  ),
                                                  child: new Text(
                                                      "Subscribe @ " +
                                                          VariableUtils.rupee +
                                                          "66",
                                                      style: TextStyle(
                                                          color: Colors.white,fontSize: 12)),
                                                  onPressed: () {})),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ));
  }
}
