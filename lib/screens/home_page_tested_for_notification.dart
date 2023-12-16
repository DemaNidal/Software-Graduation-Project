import 'package:flutter/material.dart';

class HomePageTestedForNotification extends StatefulWidget {
  const HomePageTestedForNotification({super.key});

  @override
  State<HomePageTestedForNotification> createState() =>
      _HomePageTestedForNotificationState();
}

class _HomePageTestedForNotificationState
    extends State<HomePageTestedForNotification> {
  String message = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments != null) {
      Map? pushArguments = arguments as Map;

      setState(() {
        message = pushArguments["message"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Text("Push Notification : $message"),
          ),
        ),
      ),
    );
  }
}
