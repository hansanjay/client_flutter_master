import 'dart:io';
import 'package:client_flutter_master/utils/color_utils.dart';
import 'package:client_flutter_master/utils/variable_utils.dart';
import 'package:client_flutter_master/view/dashboard/orders_fragment.dart';
import 'package:client_flutter_master/view/dashboard/subscription_fragment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'account_fragment.dart';
import 'home_fragment.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showDialog(

              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  VariableUtils.exitAppTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: Text(VariableUtils.exitAppDesc,
                    style: TextStyle(fontSize: 15)),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      VariableUtils.no,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => exit(0),
                    child: Text(
                      VariableUtils.yes,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        body: const [
          HomeFragment(),
          SubscriptionFragment(),
          OrdersFragment(),
          AccountFragment()
        ][selectedPageIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          // surfaceTintColor: Colors.white,
          indicatorColor: ColorUtils.black,
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home,color: Colors.white),
              icon: Icon(Icons.home_outlined),
              label: VariableUtils.home,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.event_note,color: Colors.white),
              icon: Icon(Icons.event_note_outlined),
              label: VariableUtils.subscription,
            ),
            NavigationDestination(
                selectedIcon: Icon(Icons.assignment,color: Colors.white),
                icon: Icon(Icons.assignment_outlined),
                label: "Orders"),
            NavigationDestination(
                selectedIcon: Icon(Icons.person,color: Colors.white,),
                icon: Icon(Icons.person_outlined),
                label: VariableUtils.account),
          ],
        ),
      ),
    ));
  }
}
