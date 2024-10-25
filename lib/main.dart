import 'package:client_flutter_master/services/connectivity_model.dart';
import 'package:client_flutter_master/splash_screen.dart';
import 'package:client_flutter_master/utils/shared_preference_utils.dart';
import 'package:client_flutter_master/utils/themes.dart';
import 'package:client_flutter_master/view/general_screens/no_internet_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefUtils.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestNotificationPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCMToken $fcmToken");

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}
Future<void> requestNotificationPermission()async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MaterialApp(
          color: Colors.white,
          debugShowCheckedModeBanner: false,
          theme: MyTheme().lightTheme,
          title: "Dairy Product Delivery",
          onGenerateRoute: generateRoute,
          initialRoute: '/',
        );
        ;
      },
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => GetBuilder<ConnectivityViewModel>(
              builder: (connectivityViewModel) {
                if (connectivityViewModel.isOnline != null) {
                  if (connectivityViewModel.isOnline!) {
                    return SplashScreen();
                  } else {
                    return const NoInterNetConnected();
                  }
                } else {
                  return const Material();
                }
              },
            ));

      default:
        return MaterialPageRoute(
          builder: (_) => GetBuilder<ConnectivityViewModel>(
            builder: (connectivityController) {
              if (connectivityViewModel.isOnline != null) {
                if (connectivityViewModel.isOnline!) {
                  return SplashScreen();
                } else {
                  return const NoInterNetConnected();
                }
              } else {
                return const Material();
              }
            },
          ),
        );
    }
  }
  /// CONTROLLER INITIALIZE
  ConnectivityViewModel connectivityViewModel =
  Get.put(ConnectivityViewModel());
}