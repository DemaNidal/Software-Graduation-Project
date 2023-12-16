import 'package:flutter/material.dart';

class EmptyPageForNotifications extends StatelessWidget {
  const EmptyPageForNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: const Text("Push Notification"),
          ),
        ),
      ),
    );
  }
}
