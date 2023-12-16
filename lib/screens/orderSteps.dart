import 'dart:convert';
import 'package:JAFFA/components/OrderTable.dart';
import 'package:JAFFA/components/selectAddress.dart';
import 'package:http/http.dart' as http;
import 'package:JAFFA/components/appbarEdit.dart';
import 'package:JAFFA/constants.dart';
import 'package:JAFFA/screens/login_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:JAFFA/components/user_API.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int activeIndex;
  bool success = false;
  String userId = p;
  late User _user;
  String query = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String street1 = '';
  String country1 = '';
  String city1 = '';
  String area1 = '';
  String check1 = '';

  Future<void> authenticateUser(String email, String password) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/api/user/login');
      final Map<String, dynamic> requestBody = {
        "identifier": email,
        "password": password,
      };

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        success = data['success'];
        String message = data['message'];
        String token = data['token'];
        userId = data['_id'];

        print('Success: $success');
        print('Message: $message');
        print('Token: $token');
        print('User ID: $userId');

        //return data;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to authenticate user');
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
      throw Exception('Network error occurred');
    }
  }

  Future<void> userInfo(String query) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response = await http.get(Uri.parse('$baseUrl/api/user/$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final userData = User.fromJson(jsonResponse['getaUser']);

      setState(() {
        _user =
            userData; // Assuming User.fromJson returns a User object directly
        _nameController.text = _user.fullName;
        _phoneController.text = _user.phoneNumber.toString();

        print(_user.fullName);
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    print(s);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (p != '') {
      success = true;
    }

    if (p != '') {
      activeIndex = 2;
      userInfo(query);
    } else {
      activeIndex = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = "";
    String pass = "";

    List<StepperData> stepperData = [
      StepperData(
        iconWidget: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: activeIndex == 0
                ? const Color.fromRGBO(245, 223, 187, 0.612)
                : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: activeIndex <= -1
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 3),
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    height: 25,
                    child: const Text(
                      "4",
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),

        // Add your additional items inside this Container
      ),
      StepperData(
        iconWidget: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: activeIndex <= 1
                ? const Color.fromRGBO(245, 223, 187, 0.612)
                : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: activeIndex <= 0
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 3),
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    height: 25,
                    child: const Text(
                      "3",
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ),
      StepperData(
        iconWidget: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: activeIndex <= 2
                ? const Color.fromRGBO(245, 223, 187, 0.612)
                : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: activeIndex <= 1
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 3),
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    height: 25,
                    child: const Text(
                      "2",
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ),
      StepperData(
        iconWidget: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: activeIndex <= 3
                ? const Color.fromRGBO(245, 223, 187, 0.612)
                : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: activeIndex <= 2
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 3, left: 3),
                  child: Container(
                    alignment: Alignment.center,
                    width: 15,
                    height: 25,
                    child: const Text(
                      "1",
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          //  Icon(
          //   activeIndex <= 2 ? Icons.check : Icons.looks_one,
          //   color: Colors.white,
          // ),
        ),
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const AppBarEdit(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: AnotherStepper(
                stepperList: stepperData,
                stepperDirection: Axis.horizontal,
                iconWidth: 30,
                iconHeight: 30,
                activeBarColor: Colors.grey,
                inActiveBarColor: const Color.fromRGBO(245, 223, 187, 0.612),
                inverted: true,
                verticalGap: 30,
                activeIndex: activeIndex,
                barThickness: 5,
              ),
            ),
            if (activeIndex == 0) const OrderTable(),
            if (activeIndex == 1)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    address(
                      onChanged: (area, city, country) {
                        // Do something with the updated values
                        print('Area: $area, City: $city, Country: $country');
                        area1 = area;
                        city1 = city;
                        country1 = country;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(check1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                              'Area: $area1, City: $city1, Country: $country1');
                          if (area1 == '' || country1 == '' || city1 == '') {
                            setState(() {
                              check1 = 'يجب ادخال جميع المعلومات';
                            });
                          } else {
                            if (activeIndex > 0) {
                              setState(() {
                                activeIndex -= 1;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(245, 223, 187, 0.612),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'متابعة ',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Lateef",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (activeIndex == 2)
              nameANDphone(
                  nameController: _nameController,
                  phoneController: _phoneController),
            if (activeIndex == 3)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'انـهـاء الــطـلــب',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Lateef",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Align text to the right
                        children: [
                          Text(
                            'عـمـيل جـديــد  ',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Lateef",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'خــيـارات انهــاء الــطـلــب',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Lateef",
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                        alignment: Alignment.topRight,
                        child: const Text(
                          ' لكي تقوم بانهاء الطلب قم بانشاء حساب جديد معنا،   يمكنك من\nالشراء بصورة اسرع ومتابعة طلبيات الشراء التي تقدمت بها ',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Lateef",
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            const Color.fromRGBO(245, 223, 187, 0.612),
                        minimumSize: const Size(160, 50),
                      ),
                      child: const Text(
                        'انشاء حساب ',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end, // Align text to the right
                        children: [
                          Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Lateef",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '   انا عميل مسجل بالموقع',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Lateef",
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: Container(
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            cursorHeight: 25,
                            decoration: const InputDecoration(
                              hintText: 'البـريـد الالكـترونـي',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Lateef",
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              alignLabelWithHint: true,
                            ),
                            textAlign: TextAlign
                                .right, // Set the text alignment to right
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (save) {
                              email = save.toString();
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: Container(
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            cursorHeight: 25,
                            decoration: const InputDecoration(
                              hintText: 'كـلـمـة الـمرور',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: "Lateef",
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              alignLabelWithHint: true,
                            ),
                            textAlign: TextAlign
                                .right, // Set the text alignment to right
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onChanged: (save) {
                              pass = save.toString();
                              // Your onChanged logic here
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          // Add your onPressed logic here
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtpVerifyPage(),
                            ),
                            (route) => false,
                          );
                          print('Forgot Password pressed');
                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          child: const Text("نـســيت كلمة الـمرور"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // fetchRecipes();
                        authenticateUser(email, pass);
                        Future.delayed(const Duration(seconds: 4), () {
                          print(success);
                          userInfo(query);
                          if (success) {
                            setState(() {
                              print("INNNNN");
                              activeIndex = 2;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            const Color.fromRGBO(245, 223, 187, 0.612),
                        minimumSize: const Size(160, 50),
                      ),
                      child: const Text(
                        'تـسجيل الدخول',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (activeIndex == 2)
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (activeIndex > 0) {
                          setState(() {
                            activeIndex -= 1;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            const Color.fromRGBO(245, 223, 187, 0.612),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'متابعة ',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (activeIndex < stepperData.length - 1) {
                  //       setState(() {
                  //         activeIndex += 1;
                  //       });
                  //     }
                  //   },
                  //   child: Text(activeIndex == stepperData.length - 1
                  //       ? 'Finish'
                  //       : 'Next'),
                  // ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class nameANDphone extends StatelessWidget {
  const nameANDphone({
    super.key,
    required TextEditingController nameController,
    required TextEditingController phoneController,
  })  : _nameController = nameController,
        _phoneController = phoneController;

  final TextEditingController _nameController;
  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: const Text(
              'البيانات الشخصية',
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Lateef",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              alignment: Alignment.topRight,
              child: const Text(
                'البيانات الشخصية',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Lateef",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.black,
                  cursorHeight: 25,
                  enabled:
                      false, // Set enabled to false to make it not editable
                  decoration: const InputDecoration(
                    hintText: 'الاســم',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Lateef",
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    alignLabelWithHint: true,
                  ),
                  textAlign: TextAlign.right, // Set the text alignment to right
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (save) {
                    // Your onChanged logic here
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Container(
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextFormField(
                  controller: _phoneController,
                  cursorColor: Colors.black,
                  cursorHeight: 25,
                  enabled:
                      false, // Set enabled to false to make it not editable
                  decoration: const InputDecoration(
                    hintText: 'رقــم الهــاتــف',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Lateef",
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    alignLabelWithHint: true,
                  ),
                  textAlign: TextAlign.right, // Set the text alignment to right
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  onChanged: (save) {
                    // Your onChanged logic here
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
