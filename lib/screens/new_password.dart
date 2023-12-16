import 'package:flutter/material.dart';
import 'package:JAFFA/components/api_service.dart';

class SetnewPass extends StatefulWidget {
  final String? email;

  const SetnewPass({super.key, this.email});
  @override
  _SetnewPassState createState() => _SetnewPassState();
}

class _SetnewPassState extends State<SetnewPass> {
  bool isAPICallProcess = false;
  String pass = "";
  String copypass = "";
  String check = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 130,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 200.0),
              child: Text(
                "إنـشــاء كــلـمـة مرور ",
                style: TextStyle(
                  fontFamily: "Lateef",
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 340,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'كــلمة الـمرور',
                  labelStyle: TextStyle(
                    fontFamily: "Lateef",
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Green outline when focused
                  ),
                ),
                obscureText: true,
                cursorColor: Colors.black,
                onChanged: (save) => {pass = save},
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 340,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: ' كوبي بيــســت',
                  labelStyle: TextStyle(
                      fontFamily: "Lateef", fontSize: 25, color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Green outline when focused
                  ),
                ),
                obscureText: true,
                cursorColor: Colors.black,
                onChanged: (save) => {
                  copypass = save,
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              check,
              style: const TextStyle(color: Colors.red, fontFamily: "Lateef"),
            ),
            Center(
              // Centering the button within the Column
              child: InkWell(
                onTap: () {
                  print(pass);

                  if (pass == copypass) {
                    print("copypass");

                    setState(() {
                      isAPICallProcess = true;
                    });
                    print(widget.email);
                    print(pass);
                    APIService.newPass(widget.email.toString(), pass).then(
                      (response) async {
                        setState(() {
                          isAPICallProcess = false;
                        });
                        print(response.message);

                        if (response.message == "Success" &&
                            response.data != null) {
                          setState(() {
                            check = "welcome back";
                          });

                          if (response.data is String) {
                            // Handle the case where 'data' is a String
                            print("Data: ${response.data}");
                          } else if (response.data is Map<String, dynamic>) {
                            // Handle the case where 'data' is a Map
                            // Example: print("UserId: ${response.data['userId']}");
                          }
                        } else {
                          // Handle the case where 'data' is null or 'message' is not "Success"
                        }
                      },
                    );

                    //                  APIService.verifyOTP(
                    //   widget.email!,
                    //   widget.otpHash!,
                    //   _otpCode,
                    // ).then((response) async {
                    //   setState(() {
                    //     isAPICallProcess = false;
                    //   });

                    //   print(response.message);
                    //   print(response.data);
                    //   if (response.data != null) {
                    //     FormHelper.showSimpleAlertDialog(
                    //       context,
                    //       "title",
                    //       response.message,
                    //       "OK",
                    //       () {
                    //         Navigator.pop(context);
                    //       },
                    //     );
                    //     chagetext(response.message);
                    //     if (response.message == 'Error') {
                    //       print('error');
                    //     } else {
                    //       print('true');
                    //       Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => SetnewPass(
                    //             email: temp,
                    //           ),
                    //         ),
                    //         (route) => false,
                    //       );
                    //     }
                    //   } else {
                    //     FormHelper.showSimpleAlertDialog(
                    //       context,
                    //       "title",
                    //       response.message,
                    //       "OK",
                    //       () {
                    //         Navigator.pop(context);
                    //       },
                    //     );
                    //     chagetext(response.message);
                    //   }
                    //   if (response.message == 'success') {
                    //     notchech = true;
                    //   }
                    // });
                  } else {
                    setState(() {
                      check = "غــيـر متطابقتـان";
                    });
                  }
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
                    borderRadius: BorderRadius.circular(22.0),
                  ),
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
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(95.0),
                            topLeft: Radius.circular(95.0),
                            bottomRight: Radius.circular(200.0),
                          ),
                        ),
                        child: const Text(
                          'انـشــاء',
                          style: TextStyle(
                            fontFamily: "Lateef",
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
