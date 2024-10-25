import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/const_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/general_screens/shimmer_product_list.dart';
import 'package:client_flutter_master/view/subscription/my_subscriptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../models/product_model.dart';
import '../../services/product_catalog_service.dart';
import '../../services/subscription_service.dart';
import '../modals/cart_modal.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

final today = DateUtils.dateOnly(DateTime.now());

class SubscribeCart extends StatefulWidget {
  final int id;
  const SubscribeCart({Key? key, required this.id}) : super(key: key);
  @override
  State<SubscribeCart> createState() => _SubscribeCartState();
}

class _SubscribeCartState extends State<SubscribeCart> {
  int _quantity = 1;
  int type = 0;
  bool _showStartDate = false;
  bool openWeek = false, openMonth = false;
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime(today.year, today.month, today.day + 1)
  ];
  String selectedDate = "";
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final SubscriptionService subscriptionService = SubscriptionService();
  late List<bool> checkedDays;
  var weekly = null;
  var monthly = null;
  List<int> selectedDates = [];
  Product? _product;
  bool _isLoading = true;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    checkedDays = List.filled(7, false);
    _fetchProduct();
    super.initState();
  }

  // String convertToWeekly(List<bool> checkedDays) {
  //   List<int> selectedDays = [];
  //   for (int i = 0; i < checkedDays.length; i++) {
  //     if (checkedDays[i]) {
  //       selectedDays.add(i + 1);
  //     }
  //   }
  //   return selectedDays.join(',');
  // }

  String convertToWeekly(List<bool> checkedDays) {
    List<int> selectedDays = [];
    for (int i = 0; i < checkedDays.length; i++) {
      if (checkedDays[i] == true) {
        selectedDays.add(i + 1);
      }
    }
    return selectedDays.isEmpty ? '' : selectedDays.join(',');
  }

  void selectDate(int date) {
    setState(() {
      if (selectedDates.contains(date)) {
        selectedDates.remove(date);
      } else {
        selectedDates.add(date);
      }
      monthly = selectedDates.join(',');
    });
  }

  Future<void> _fetchProduct() async {
    _product = await ProductService.getProductById(widget.id);
    setState(() {
      _product;
      _isLoading = false;
    });
  }

  Future<void> _createSubscription() async {
    try {
      await subscriptionService.createSubscription(
        distributorId: _product!.distributorId,
        productId: _product!.id,
        quantity: _quantity,
        type: type,
        status: 1,
        start: selectedDate,
        weekly: weekly,
        monthly: monthly,
      );
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Subscription created successfully",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => MySubscription()));
    } catch (e) {
      print('Error creating subscription: $e');
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
    }
    // print("Data: "+_product!.distributorId.toString()+"\nProduct Id :"+_product!.id.toString()+"\nQuantity: "+_quantity.toString()+"\nType: "+type.toString()+"\nDate: "+selectedDate+"\nWeekly: "+weekly.toString()+"\nMonthly: "+monthly.toString());
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
              title: Text("Subscribe",
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "$baseUrl/" +
                                                      _product!.imageUrl),
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
                                              _product!.brand,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              _product!.title,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              _product!.weightDisplay,
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
                                                      _product!.mrp.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CartStepperInt(
                                              value: _quantity,
                                              size: 30,
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
                                                buttonAspectRatio: 1.5,
                                              ),
                                              didChangeCount: (count) {
                                                _quantity = count;
                                                setState(() {
                                                  if (count < 1) {
                                                    _showStartDate = false;
                                                    type = 0;
                                                    selectedDate = "";
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
                              height: 10,
                            ),
                            Material(
                                elevation: 1,
                                color: ColorUtils.white,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.calendar_month_outlined,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                          title: Text(
                                            "Pick Schedule",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (!openWeek && !openMonth)
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showMaterialModalBottomSheet(
                                                      expand: false,
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) =>
                                                          showModal(context));
                                                  setState(() {
                                                    type = 1;
                                                    _showStartDate = false;
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: type == 1
                                                        ? Colors.black
                                                        : Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    "Daily",
                                                    style: TextStyle(
                                                      color: type == 1
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    type = 2;
                                                    _showStartDate = false;
                                                    openWeek = true;
                                                    openMonth = false;
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: type == 2
                                                        ? Colors.black
                                                        : Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    "Weekly",
                                                    style: TextStyle(
                                                        color: type == 2
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    type = 3;
                                                    _showStartDate = false;
                                                    openWeek = false;
                                                    openMonth = true;
                                                  });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: type == 3
                                                        ? Colors.black
                                                        : Colors.grey[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    "Monthly",
                                                    style: TextStyle(
                                                        color: type == 3
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        else if (openWeek)
                                          Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, bottom: 5),
                                                  child: Text(
                                                    "Select Week Days",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1,
                                                ),
                                                // Row(
                                                //   children: [
                                                //     for (int i = 0; i < 3; i++)
                                                //       Expanded(
                                                //         child: Row(
                                                //           mainAxisAlignment:
                                                //               MainAxisAlignment
                                                //                   .start,
                                                //           children: [
                                                //             Checkbox(
                                                //               visualDensity:
                                                //                   VisualDensity
                                                //                       .compact,
                                                //               value:
                                                //                   checkedDays[
                                                //                       i],
                                                //               onChanged: (bool?
                                                //                   value) {
                                                //                 setState(() {
                                                //                   checkedDays[
                                                //                           i] =
                                                //                       value!;
                                                //                   weekly =
                                                //                       convertToWeekly(
                                                //                           checkedDays);
                                                //                 });
                                                //               },
                                                //             ),
                                                //             Text(
                                                //               daysOfWeek[i],
                                                //               style: TextStyle(
                                                //                   fontSize: 12),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //   ],
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     for (int i = 3; i < 6; i++)
                                                //       Expanded(
                                                //         child: Row(
                                                //           children: [
                                                //             Checkbox(
                                                //               visualDensity:
                                                //                   VisualDensity
                                                //                       .compact,
                                                //               value:
                                                //                   checkedDays[
                                                //                       i],
                                                //               onChanged: (bool?
                                                //                   value) {
                                                //                 setState(() {
                                                //                   checkedDays[
                                                //                           i] =
                                                //                       value!;
                                                //                   weekly =
                                                //                       convertToWeekly(
                                                //                           checkedDays);
                                                //                 });
                                                //               },
                                                //             ),
                                                //             Text(
                                                //               daysOfWeek[i],
                                                //               style: TextStyle(
                                                //                   fontSize: 12),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //   ],
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     for (int i = 6; i < 7; i++)
                                                //       Expanded(
                                                //         child: Row(
                                                //           children: [
                                                //             Checkbox(
                                                //               visualDensity:
                                                //                   VisualDensity
                                                //                       .compact,
                                                //               value:
                                                //                   checkedDays[
                                                //                       i],
                                                //               onChanged: (bool?
                                                //                   value) {
                                                //                 setState(() {
                                                //                   checkedDays[
                                                //                           i] =
                                                //                       value!;
                                                //                 });
                                                //               },
                                                //             ),
                                                //             Text(
                                                //               daysOfWeek[i],
                                                //               style: TextStyle(
                                                //                   fontSize: 12),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //   ],
                                                // ),

                                                Row(
                                                  children: [
                                                    for (int i = 0; i < 3; i++)
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Checkbox(
                                                              visualDensity: VisualDensity.compact,
                                                              value: checkedDays[i],
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  checkedDays[i] = value!;
                                                                  weekly = convertToWeekly(checkedDays);
                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                              daysOfWeek[i],
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    for (int i = 3; i < 6; i++)
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Checkbox(
                                                              visualDensity: VisualDensity.compact,
                                                              value: checkedDays[i],
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  checkedDays[i] = value!;
                                                                  weekly = convertToWeekly(checkedDays);
                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                              daysOfWeek[i],
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    for (int i = 6; i < 7; i++)
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Checkbox(
                                                              visualDensity: VisualDensity.compact,
                                                              value: checkedDays[i],
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  checkedDays[i] = value!;
                                                                  weekly = convertToWeekly(checkedDays);
                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                              daysOfWeek[i],
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      bottom: 5,
                                                      top: 15),
                                                  child: Text(
                                                    "Select subscription start date",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 1,
                                                ),
                                                CalendarDatePicker2(
                                                  config: CalendarDatePicker2Config(
                                                      firstDate: DateTime(
                                                          today.year,
                                                          today.month,
                                                          today.day + 1),
                                                      selectedDayHighlightColor:
                                                          Colors.black),
                                                  value:
                                                      _singleDatePickerValueWithDefaultValue,
                                                  onValueChanged: (dates) =>
                                                      _singleDatePickerValueWithDefaultValue =
                                                          dates,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0, right: 25.0),
                                                  child: new Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10.0),
                                                          child: Container(
                                                              child:
                                                                  OutlinedButton(
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _showStartDate =
                                                                    false;
                                                                type = 0;
                                                                selectedDate =
                                                                    "";
                                                                openWeek =
                                                                    false;
                                                                openMonth =
                                                                    false;
                                                                checkedDays =
                                                                    List.filled(
                                                                        7,
                                                                        false);
                                                              });
                                                            },
                                                          )),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: Container(
                                                              child:
                                                                  new OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                          backgroundColor: Colors
                                                                              .black),
                                                                      child: new Text(
                                                                          "Done",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white)),
                                                                      onPressed:
                                                                          () {
                                                                        String
                                                                            formattedDate =
                                                                            DateFormat('yyyy-MM-dd').format(_singleDatePickerValueWithDefaultValue[0]!);
                                                                        selectedDate =
                                                                            formattedDate;
                                                                        setState(
                                                                            () {
                                                                          _showStartDate =
                                                                              true;
                                                                          openWeek =
                                                                              false;
                                                                        });
                                                                      })),
                                                        ),
                                                        flex: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ])
                                        else if (openMonth)
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, bottom: 5),
                                                child: Text(
                                                  "Select Dates",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: GridView.builder(
                                                  itemCount: 31,
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 10,
                                                    mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 5.0,
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final date = index + 1;
                                                    final isSelected =
                                                        selectedDates
                                                            .contains(date);
                                                    return DateItem(
                                                      date: date,
                                                      isSelected: isSelected,
                                                      onTap: () {
                                                        selectDate(date);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    bottom: 5,
                                                    top: 15),
                                                child: Text(
                                                  "Select subscription start date",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                              ),
                                              CalendarDatePicker2(
                                                config: CalendarDatePicker2Config(
                                                    firstDate: DateTime(
                                                        today.year,
                                                        today.month,
                                                        today.day + 1),
                                                    selectedDayHighlightColor:
                                                        Colors.black),
                                                value:
                                                    _singleDatePickerValueWithDefaultValue,
                                                onValueChanged: (dates) =>
                                                    _singleDatePickerValueWithDefaultValue =
                                                        dates,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0),
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10.0),
                                                        child: Container(
                                                            child:
                                                                OutlinedButton(
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _showStartDate =
                                                                  false;
                                                              type = 0;
                                                              selectedDate = "";
                                                              openWeek = false;
                                                              openMonth = false;
                                                              checkedDays =
                                                                  List.filled(
                                                                      7, false);
                                                            });
                                                          },
                                                        )),
                                                      ),
                                                      flex: 2,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Container(
                                                            child:
                                                                new OutlinedButton(
                                                                    style: OutlinedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .black),
                                                                    child: new Text(
                                                                        "Done",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white)),
                                                                    onPressed:
                                                                        () {
                                                                      String
                                                                          formattedDate =
                                                                          DateFormat('yyyy-MM-dd')
                                                                              .format(_singleDatePickerValueWithDefaultValue[0]!);
                                                                      selectedDate =
                                                                          formattedDate;
                                                                      setState(
                                                                          () {
                                                                        _showStartDate =
                                                                            true;
                                                                        openWeek =
                                                                            false;
                                                                        openMonth =
                                                                            false;
                                                                      });
                                                                    })),
                                                      ),
                                                      flex: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                            visible: _showStartDate,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Divider(
                                                  height: 1,
                                                ),
                                                ListTile(
                                                    leading: Icon(
                                                      Icons
                                                          .calendar_month_outlined,
                                                      color: ColorUtils.black,
                                                      size: 25,
                                                    ),
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Subscription Start Date",
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          selectedDate,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                                Colors
                                                                    .transparent,
                                                            builder: (context) =>
                                                                showModal(
                                                                    context));
                                                      },
                                                    )),
                                              ],
                                            ))
                                      ],
                                    ))),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                                elevation: 1,
                                color: ColorUtils.white,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.sticky_note_2_outlined,
                                            color: ColorUtils.black,
                                            size: 20,
                                          ),
                                          title: Text(
                                            "Terms and Conditions",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 30,
                                                bottom: 10),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon/subscription.png",
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Subscription charges may change per market changes.",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            )),
                                        Divider(
                                          height: 1,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 30,
                                                top: 10,
                                                bottom: 15),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icon/charge.png",
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "Delivery charge will be applicable on the subscription orders. If all your items are delivered together, we only charge you once.",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ))),
                            SizedBox(
                              height: 100,
                            ),
                          ])))
                    ]),
                    Visibility(
                      visible: _showStartDate,
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
                                    if (type == 2) {
                                      if (weekly!=null) {
                                        _createSubscription();
                                      } else {
                                        AnimatedSnackBar.material(
                                          duration: const Duration(seconds: 5),
                                          "Select week days to continue",
                                          type: AnimatedSnackBarType.error,
                                          mobileSnackBarPosition:
                                              MobileSnackBarPosition.bottom,
                                        ).show(context);
                                      }
                                    } else if (type == 3) {
                                      if (monthly!=null) {
                                        _createSubscription();
                                      } else {
                                        AnimatedSnackBar.material(
                                          duration: const Duration(seconds: 5),
                                          "Select month days to continue",
                                          type: AnimatedSnackBarType.error,
                                          mobileSnackBarPosition:
                                              MobileSnackBarPosition.bottom,
                                        ).show(context);
                                      }
                                    } else {
                                      _createSubscription();
                                    }
                                  },
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "START SUBSCRIPTION\n",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        TextSpan(
                                          text: selectedDate,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])));
  }

  Widget showModal(context) {
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
                'Select subscription start date',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.close, size: 30),
              onTap: () {
                setState(() {
                  _showStartDate = false;
                  type = 0;
                  selectedDate = "";
                });
                Navigator.pop(context);
              },
            ),
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  firstDate: DateTime(today.year, today.month, today.day + 1),
                  selectedDayHighlightColor: Colors.black),
              value: _singleDatePickerValueWithDefaultValue,
              onValueChanged: (dates) =>
                  _singleDatePickerValueWithDefaultValue = dates,
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
                            _showStartDate = false;
                            type = 0;
                            selectedDate = "";
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
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(
                                        _singleDatePickerValueWithDefaultValue[
                                            0]!);
                                selectedDate = formattedDate;
                                setState(() {
                                  _showStartDate = true;
                                });
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

class DateItem extends StatefulWidget {
  final int date;
  final bool isSelected;
  final Function onTap;

  DateItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _DateItemState createState() => _DateItemState();
}

class _DateItemState extends State<DateItem> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onTap();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _isSelected ? Colors.black : Colors.blue[100],
        ),
        child: Center(
          child: Text(
            '${widget.date}',
            style: TextStyle(
              fontSize: 16.0,
              color: _isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
