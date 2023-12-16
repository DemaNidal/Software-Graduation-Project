import 'package:JAFFA/components/AppBarwithArrow.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:JAFFA/components/user_API.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:JAFFA/constants.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo>
    with SingleTickerProviderStateMixin {
  //String baseUrl = 'http://192.168.1.2:5000';
  String query = "";
  bool isSideBarOpen = false;
  late User _user; // Initialize _user

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String fullName = '';

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  String phoneNumber = '';

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String Pass = '';

  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  String confPas = '';

  late SMIBool isMenuOpenInput;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    // Call getUserData to fetch user data
    userInfo(query);
    super.initState();
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> userInfo(String query) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response = await http.get(Uri.parse('$baseUrl/api/user/$p'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final userData = User.fromJson(jsonResponse['getaUser']);

      setState(() {
        _user =
            userData; // Assuming User.fromJson returns a User object directly

        print(_user.fullName);
      });
        } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> updateInfo(
      String fullName, int phoneNumber, String password) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response = await http.put(Uri.parse(
        '$baseUrl/api/user/edit-user/651bde0dcff2029b0aff7cec/$fullName/$phoneNumber/$password'));

    if (response.statusCode == 200) {
      print('Update Successfully');
    } else {
      print('Failed to Update User. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBarwithArrow(nav: 'profile'),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 10, right: 14),
                    child: Text(
                      "البيانات الشخصية",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Lateef",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 244, 225, 0.612),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          initialValue: _user.fullName,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'الاســم الـكـامـل',
                            hintStyle: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                            ),
                          ),
                          onSaved: (value) {
                            fullName = value ?? '';
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 244, 225, 0.612),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextFormField(
                        initialValue: _user.dateOfBirth,
                        readOnly: true, // Set the controller
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 244, 225, 0.612),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Form(
                        key: _formKey1,
                        child: TextFormField(
                          initialValue: _user.phoneNumber.toString(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'رقـم الهــاتفـــ المـحـمـول ',
                            hintStyle: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                            ),
                          ),
                          onSaved: (value) {
                            phoneNumber = value ?? '';
                          },
                          keyboardType:
                              TextInputType.number, // or TextInputType.phone
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 10, right: 14),
                    child: Text(
                      "كلمة المرور",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Lateef",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 244, 225, 0.612),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Form(
                        key: _formKey2,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: ' كـلمــة الـمـــرور',
                            hintStyle: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            Pass = value ?? '';
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 244, 225, 0.612),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Form(
                        key: _formKey3,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'تـأكـيـد كـلـمـة الـمـرور',
                            hintStyle: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            confPas = value ?? '';
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 12, // Add elevation for the box shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      ' تعـديـل العنــوان',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Lateef",
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        if (fullName.isEmpty) print("full Name is empty");
                        // The rest of your code
                      }
                      if (_formKey1.currentState?.validate() ?? false) {
                        _formKey1.currentState?.save();
                        if (phoneNumber.isEmpty) print("Phone number is empty");
                        // The rest of your code
                      }
                      if (_formKey2.currentState?.validate() ?? false) {
                        _formKey2.currentState?.save();
                        if (_formKey3.currentState?.validate() ?? false) {
                          _formKey3.currentState?.save();
                        }
                        if (Pass != confPas) {
                          print("check pass");
                        }
                      }
                      if (Pass.isEmpty &&
                          fullName.isNotEmpty &&
                          phoneNumber.isNotEmpty) {
                        updateInfo(
                            fullName, int.parse(phoneNumber), _user.password);
                      }
                      if (Pass.isNotEmpty &&
                          fullName.isNotEmpty &&
                          phoneNumber.isNotEmpty) {
                        print(Pass);
                        updateInfo(fullName, int.parse(phoneNumber), Pass);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 12, // Add elevation for the box shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      backgroundColor:
                          const Color.fromRGBO(245, 223, 187, 0.612),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      ' تحـديـث البيـانات',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Lateef",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button action here
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 12, // Add elevation for the box shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      backgroundColor:
                          const Color.fromRGBO(245, 223, 187, 0.612),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      ' تسـجيـل الخـروج',
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
          ],
        ),
        // bottomNavigationBar: Transform.translate(
        //   offset: Offset(0, 500 * animation.value),
        //   child: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        //       child: Container(
        //         margin: const EdgeInsets.only(bottom: 30),
        //         decoration: BoxDecoration(
        //           color: Colors.black,
        //           borderRadius: const BorderRadius.all(Radius.circular(24)),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.5),
        //               offset: const Offset(0, 10),
        //               blurRadius: 10,
        //             ),
        //           ],
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.only(
        //               bottom: 10,
        //               top: 10,
        //               left: 30,
        //               right: 30), // Margin from the screen
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               ...List.generate(
        //                 bottomNavItems.length,
        //                 (index) {
        //                   Menu navBar = bottomNavItems[index];
        //                   return Expanded(
        //                     child: BtmNavItem(
        //                       navBar: navBar,
        //                       press: () {
        //                         updatePage(navBar);
        //                         updateSelectedBtmNav(navBar);
        //                         RiveUtils.chnageSMIBoolState(
        //                             navBar.rive.status!);
        //                         updateSelectedBtmNav(navBar);
        //                       },
        //                       riveOnInit: (artboard) {
        //                         navBar.rive.status = RiveUtils.getRiveInput(
        //                             artboard,
        //                             stateMachineName:
        //                                 navBar.rive.stateMachineName);
        //                       },
        //                       selectedNav: selectedBottonNav,
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
