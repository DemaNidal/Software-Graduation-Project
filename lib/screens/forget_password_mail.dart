import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:JAFFA/components/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:JAFFA/screens/new_password.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
  final String? email;
  final String? otpHash;
  const ForgetPasswordMailScreen({super.key, this.email, this.otpHash});

  @override
  _ForgetPasswordMailScreen createState() => _ForgetPasswordMailScreen();
}

class _ForgetPasswordMailScreen extends State<ForgetPasswordMailScreen> {
  String _otpCode = "";
  bool isAPICallProcess = false;
  late FocusNode myFocusNode;
  bool isAPICallInProgress = false;
  bool notchech = false;
  String text = "";
  String temp = "";
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    //   borderRadius: BorderRadius.circular(8),
    // );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/logo.png'),
                height: 130,
              ),
              const SizedBox(
                height: 0,
              ),
              const Text(
                'أدخــل الـرمـز الـمـرســل إلـى البـريـد الإلــكتـرونــي الـخــاصـ بـــك',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontFamily: "Lateef",
                ),
              ),
              Pinput(
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.green),
                  ),
                ),
                onCompleted: (pin) => debugPrint(_otpCode = pin),
              ),
              Text(
                text,
                style: const TextStyle(fontFamily: "Lateef"),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    // Simulate an API call by delaying the state change
                    setState(() {
                      isAPICallInProgress = true; // Set the loading state
                      notchech = false;
                      isAPICallProcess = true;
                    });

                    // Simulate an API call by delaying the state change for 3 seconds
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        isAPICallInProgress = false; // Reset the loading state
                      });
                    });
                    temp = widget.email.toString();
                    print(temp);
                    Timer(const Duration(seconds: 2), () {
                      //Your function call here

                      check();
                    });
                  },
                  child: Container(
                    width: 150.0,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0.0, 20.0),
                            blurRadius: 30.0,
                            color: Colors.black12,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Stack(
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              width: 110.0,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3.0,
                                horizontal: 28.0,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(95.0),
                                  topLeft: Radius.circular(95.0),
                                  bottomRight: Radius.circular(200.0),
                                ),
                              ),
                              child: const Text(
                                'تــحـقـق',
                                style: TextStyle(
                                    fontFamily: "Lateef",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            if (isAPICallInProgress)
                              LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.black,
                                size: 30,
                              ),
                            if (!isAPICallInProgress && !notchech)
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.ads_click,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void check() {
    print(widget.otpHash);
    APIService.verifyOTP(
      widget.email!,
      widget.otpHash!,
      _otpCode,
    ).then((response) async {
      setState(() {
        isAPICallProcess = false;
      });

      print(response.message);
      print(response.data);
      if (response.data != null) {
        FormHelper.showSimpleAlertDialog(
          context,
          "title",
          response.message,
          "OK",
          () {
            Navigator.pop(context);
          },
        );
        chagetext(response.message);
        if (response.message == 'Error') {
          print('error');
        } else {
          print('true');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SetnewPass(
                email: temp,
              ),
            ),
            (route) => false,
          );
        }
      } else {
        FormHelper.showSimpleAlertDialog(
          context,
          "title",
          response.message,
          "OK",
          () {
            Navigator.pop(context);
          },
        );
        chagetext(response.message);
      }
      if (response.message == 'success') {
        notchech = true;
      }
    });
  }

  void chagetext(t) {
    text = t;
  }
}
