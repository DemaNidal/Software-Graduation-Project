import 'package:JAFFA/components/AppBar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'dart:math';

import 'package:rive/rive.dart';

import '../../utils/rive_utils.dart';

import '../../mode/menu.dart';
import '../../components/btm_nav_item.dart';

import '../../components/side_bar.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isPasswordVisible = false;
  final bool _acceptedTerms = false;
  String? _selectedPlace;
  DateTime? _dob; // Store selected date of birth

  final List<String> _livingPlaces = ['Nablus', 'Tulkarm', 'Hebron', 'Jenin'];

  void handleResponse(String responseBody, BuildContext context) {
    Map<String, dynamic> responseJson = json.decode(responseBody);
    String message = responseJson['msg'];
    print('Server response: $message');

    if (message == 'User with the same email already exists') {
      Navigator.of(context).pop(); // This will pop the current screen
    }
  }

  Future<void> signUp() async {
    String? formattedDateOfBirth;
    if (_dob != null) {
      formattedDateOfBirth = DateFormat('yyyy-MM-dd').format(_dob!);
    }
    print(formattedDateOfBirth);
    final url = Uri.parse('$baseUrl/api/user/signup');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      /*  'fullName': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'livePlace': _livePlaceController.text,
      'phoneNumber': int.parse(_phoneNumberController.text),
      'dateOfBirth': DateTime.parse(_dobController.text),*/

      "fullName": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "livePlace": _selectedPlace,
      "phoneNumber": _phoneNumberController.text,
      "dateOfBirth": formattedDateOfBirth,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // تم التسجيل بنجاح
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(''),
            content: const Text('🥳 تم تسجيلك  بنجاح'),
            contentTextStyle: const TextStyle(
              fontFamily: 'DroidArabicNaskh',
              fontSize: 24,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Close the AlertDialog
                  Navigator.of(context).pop();

                  // Close the parent page
                  Navigator.of(context).pop();

                  // If you want to execute a callback after closing, you can do it here
                  // showCustomDialog(context, onValue: (value) {
                  //   if (value) {
                  //     // User confirmed
                  //     print("User confirmed");
                  //   } else {
                  //     // User cancelled
                  //     print("User cancelled");
                  //   }
                  // });
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print(response.statusCode);
        final data = jsonDecode(response.body);
        final errorMessage = data['error'] ?? 'Registration failed!';
        Map<String, dynamic> responseJson = json.decode(response.body);
        String message = responseJson['msg'];
        print('Server response: $message');

        if (message == 'User with the same email already exists') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('FAILED'),
              content: const Text('هذا الايميل قام بالتسجيل بالفعل'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (message == 'User with the same name already exists') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('FAILED'),
              content: const Text('قم بتغير الاسم  '),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('هناك مشكله في التسجيل حاول لاحقا 😢.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(cartCount: 0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _nameController,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(219, 63, 67, 88),
                              width: 2.0),
                        ),
                        labelText: 'الاسم',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(219, 63, 67, 88)),
                        fillColor: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'قم بتعبئة الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(219, 63, 67, 88),
                              width: 2.0),
                        ),
                        labelText: 'الايميل',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(219, 63, 67, 88))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' قم بتعبئة الايميل';
                      } else if (!value.contains('@')) {
                        return 'قم بتعبئه ايميل بشكل صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(219, 63, 67, 88), width: 2.0),
                      ),
                      labelText: 'كلمة المرور',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(219, 63, 67, 88)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          color: const Color.fromARGB(219, 63, 67, 88),
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'قم بتعبئة كلمة المرور';
                      } else if (value.length < 6) {
                        return 'كلمة السر يجب ان تتكون من 6 خانات على الاقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(219, 63, 67, 88), width: 2.0),
                      ),
                      labelText: 'اعادة كلمة المرور',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(219, 63, 67, 88)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          color: const Color.fromARGB(219, 63, 67, 88),
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'الكلمات غير متشابهة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(219, 63, 67, 88),
                              width: 2.0),
                        ),
                        labelText: 'رقم الهاتف',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(219, 63, 67, 88))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'قم بتعبئة الرقمr';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(219, 63, 67, 88), width: 2.0),
                      ),
                      labelText: 'تاريخ الميلاد',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(219, 63, 67, 88)),
                      hintText: 'Select Date',
                      errorText:
                          _dob == null ? 'قم باختيار تاريخ ميلادك' : null,
                    ),
                    readOnly: true, // Make the text field read-only
                    onTap: () {
                      _selectDate(context);
                    },
                    controller: TextEditingController(
                      text: _dob != null
                          ? DateFormat('yyyy-MM-dd').format(_dob!)
                          : '',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _selectedPlace,
                    items: _livingPlaces.map((place) {
                      return DropdownMenuItem<String>(
                        value: place,
                        child: Text(place),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(219, 63, 67, 88),
                              width: 2.0),
                        ),
                        labelText: 'مكان السكن',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(219, 63, 67, 88))),
                    onChanged: (value) {
                      setState(() {
                        _selectedPlace = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'قم باختيار مكان سكنك';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(219, 63, 67, 88).withOpacity(0.7),
                      minimumSize: const Size(double.infinity, 56),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                    ),
                    child: const Text(
                      "انشاء حساب",
                      style: TextStyle(
                        fontFamily: 'DroidArabicNaskh',
                        fontSize: 24,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class entryPoint extends StatefulWidget {
  const entryPoint({super.key});

  @override
  State<entryPoint> createState() => _entryPointState();
}

class _entryPointState extends State<entryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

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
    super.initState();
  } //important to initialize animation

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
      //this back when press side menu

      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ), //side par icons

          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  child: RegistrationForm(),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 500 * animation.value),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 10,
                    top: 10,
                    left: 30,
                    right: 30), // Margin from the screen
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      bottomNavItems.length,
                      (index) {
                        Menu navBar = bottomNavItems[index];
                        return Expanded(
                          child: BtmNavItem(
                            navBar: navBar,
                            press: () {
                              RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                              updateSelectedBtmNav(navBar);
                            },
                            riveOnInit: (artboard) {
                              navBar.rive.status = RiveUtils.getRiveInput(
                                  artboard,
                                  stateMachineName:
                                      navBar.rive.stateMachineName);
                            },
                            selectedNav: selectedBottonNav,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 0), // Margin between icons
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
