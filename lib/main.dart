// import 'package:flutter/material.dart';

// import 'package:JAFFA/screens/onboding/onboding_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Directionality(
//         textDirection: TextDirection.rtl, // Set text direction here
//         child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'JAFFA',
//           theme: ThemeData(
//             primarySwatch: Colors.grey,
//             fontFamily: "Lateef",
//             inputDecorationTheme: InputDecorationTheme(
//               filled: true,
//               fillColor: const Color.fromARGB(255, 12, 12, 12).withOpacity(0.3),
//               errorStyle: const TextStyle(height: 0),
//               border: defaultInputBorder,
//               enabledBorder: defaultInputBorder,
//               focusedBorder: customUnderlineInputBorder,
//               errorBorder: defaultInputBorder,
//               focusedErrorBorder: customUnderlineInputBorder,
//             ),
//           ),
//           home: Scaffold(
//             body: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/Backgrounds/DEMA.jpg', // Replace with your image asset path
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Container(
//                     color: const Color.fromARGB(
//                         219, 63, 67, 88), // Semi-transparent black color
//                   ),
//                 ),
//                 const OnboardingScreen(), // Assuming you want to display OnbodingScreen on top of the background
//               ],
//             ),
//           ),
//         ),
//       );
// }

// const defaultInputBorder = OutlineInputBorder(
//   borderSide: BorderSide(
//     color: Color.fromARGB(219, 63, 67, 88),
//     width: 1,
//   ),
// );

// const customUnderlineInputBorder = UnderlineInputBorder(
//   borderSide: BorderSide(color: Color.fromARGB(219, 63, 67, 88), width: 2.0),
// );

import 'dart:isolate';

import 'dart:convert';

import 'package:JAFFA/components/recipe_Response_API.dart';
import 'package:JAFFA/map-delivary.dart';
import 'package:JAFFA/screens/cart_screen.dart';
import 'package:JAFFA/screens/empty_for_test_notification.dart';
import 'package:JAFFA/screens/home_page_tested_for_notification.dart';
import 'package:JAFFA/screens/cart_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //   options: FirebaseOptions(
      //       apiKey: "AIzaSyCKZNIGl5aadxxQ90bAL2Y15SDi0xEbiJQ",
      //       authDomain: "push-notification-28640.firebaseapp.com",
      //       projectId: "push-notification-28640",
      //       storageBucket: "push-notification-28640.appspot.com",
      //       messagingSenderId: "635865919482",
      //       appId: "1:635865919482:web:ce2d9e6b69617c1fb5be43",
      //       measurementId: "G-LRDL2HJX9M"),
      // );
      );
  FirebaseMessaging.instance.getToken().then((value) {
    print("getToken: $value");
  });

  // If Application is in Background, then it will work.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        '/push-page',
        arguments: {"message": json.encode(message.data)},
      );
    },
  );

  // If App is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      '/push-page',
      arguments: {"message": json.encode(message?.data)},
    );
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("_firebaseMessagingBackgroundHandler: $message");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/': ((context) => CartScreen(
              cartCount: 0,
            )),
        '/push-page': ((context) => const HomePageTestedForNotification()),
      },
    );
  }
}
