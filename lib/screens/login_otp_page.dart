import 'package:flutter/material.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:JAFFA/components/api_service.dart';
import 'package:JAFFA/screens/forget_password_mail.dart';

class OtpVerifyPage extends StatefulWidget {
  final String? email;
  final String? otpHash;

  const OtpVerifyPage({super.key, this.email, this.otpHash});
  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage>
    with SingleTickerProviderStateMixin {
  bool isAPICallProcess = false;
  late FocusNode myFocusNode;
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  late AnimationController _controller;

  late AnimationController controller;
  late Animation<double> animation;
  String ch = "";
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    // Repeat the animation indefinitely
    //controller.repeat(reverse: true);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 200), // You can adjust the duration as needed
    );
    _emailFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_emailFocus.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    String e = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 50,
            ),
            child: Image.asset(
              "assets/images/logo.png",
              height: 130,
            ),
          ),
          const Text(
            "إعــادة ضـبطـ كلمــة الـســر",
            style: TextStyle(
                fontFamily: "Lateef",
                fontWeight: FontWeight.bold,
                fontSize: 30,
                wordSpacing: 7),
          ),
          // Ima
          const Text(
            " ادخـل البـريد الإلـكتـرونــي الخــاص بحســابـكـ",
            style: TextStyle(
              fontFamily: "Lateef",
              inherit: true,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Container(
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextFormField(
                  // initialValue: _user.dateOfBirth,
                  controller: _emailController,
                  focusNode: _emailFocus,

                  decoration: InputDecoration(
                    // labelText: 'Email',
                    icon: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _controller.value *
                              2, // Adjust the angle as needed
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.email,
                              color: Colors.black, // Customize the icon color
                            ),
                          ),
                        );
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                  ),

                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (save) => {
                    e = save.toString(),
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 90.0,
            ),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  ch,
                  style:
                      const TextStyle(fontFamily: "lateef", color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  isAPICallProcess = true;
                });

                APIService.otpLogin(e).then(
                  (response) async {
                    setState(() {
                      isAPICallProcess = false;
                    });
                    if (response.data != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordMailScreen(
                            otpHash: response.data,
                            email: e,
                          ),
                        ),
                        (route) => false,
                      );
                    } else {
                      ch = "لا يوجد حساب مرتبط بهذا البريد الإلكترونــي";
                    }
                  },
                );
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
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      width: 110.0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 28.0,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(245, 223, 187, 0.612),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(95.0),
                          topLeft: Radius.circular(95.0),
                          bottomRight: Radius.circular(200.0),
                        ),
                      ),
                      child: const Text(
                        'الـتــالــي',
                        style: TextStyle(
                            fontFamily: "Lateef",
                            fontSize: 22,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const Icon(
                      Icons.navigate_next,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }
}
