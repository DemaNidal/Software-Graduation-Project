import 'dart:convert';

import 'package:JAFFA/components/userCart.dart';
import 'package:JAFFA/constants.dart';
import 'package:JAFFA/screens/ordersHistory.dart';
import 'package:JAFFA/screens/profileInfo.dart';
import 'package:http/http.dart' as http;

import '../../components/AppBar.dart';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../screens/entry_point.dart';
import '../../screens/fav.dart';

import '../../mode/menu.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;
  String query = "";
  late SMIBool isMenuOpenInput;

  List<cartProduct> _product = [];

  Future<void> userCartP(String query) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response = await http.get(Uri.parse('$baseUrl/api/user/cart/$p'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> cartData = json.decode(response.body);
      final List<dynamic> productsData = cartData['products'];

      setState(() {
        _product =
            productsData.map((json) => cartProduct.fromJson(json)).toList();
        print(_product[0].image);

        // Read count for each product and store it in counts list
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

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
    userCartP(query);
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

  void updatePage(String selectedMenu) {
    String pageTitle = selectedMenu;
    Widget newPage = const Profile();

    // You can use a switch statement or if-else statements to map the menu items to pages.
    // For example:
    switch (pageTitle) {
      case "Profile":
        newPage = const Profile();
        break;
      case "Chat":
        newPage = const EntryPoint();
        break;
      case "Search":
        newPage = const Profile();
        break;
      case "Home":
        newPage = const EntryPoint();
        break;
      case "الـمفضلـة":
        newPage = const Fav();
        break;
      case "حـسـابي":
        newPage = const ProfileInfo();
        break;
      case "طـلبـاتـي":
        newPage = const orderHistory();
        break;
    }
    void changePage(String title) {
      newPage = const Fav();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Fav()));
      print("object");
    }

    // Use the Navigator to push the new page
    Navigator.push(context, MaterialPageRoute(builder: (context) => newPage));
  }

  List<String> title = [
    'حـسـابي',
    'طـلبـاتـي',
    'الـمفضلـة',
    'الإشعارات',
    'معلومات الشحن',
    'اتصل بنا'
  ];
  List<String> image = [
    'assets/icons/user.png',
    'assets/icons/checklist.png',
    'assets/icons/heart.png',
    'assets/icons/bell.png',
    'assets/icons/parcel.png',
    'assets/icons/smartphone.png'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //void changePage(String title) {}
    return Scaffold(
      appBar: CustomAppBar(
        cartCount: _product.length,
      ),
      // Change background color to white
      //this back when press side menu
      body: Column(
        children: [
          Container(
            height: size.height * 0.32,
            alignment: Alignment.bottomRight,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  child: SizedBox(
                    height: size.height * 0.32,
                    child: Image.asset(
                      'assets/images/OIGG.jpg', // Replace with your image path
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: title.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  updatePage(title[index]);
                },
                child: Column(
                  children: [
                    buildContainer(title[index], image[index]),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

Widget buildContainer(String title, String iconPath) {
  return Container(
    width: 350,
    height: 60,
    decoration: const BoxDecoration(
      color: Color.fromRGBO(254, 244, 225, 0.612),
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    child: Stack(
      children: [
        const Positioned.fill(
          child: ClipRRect(),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 200.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "Lateef",
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                iconPath,
                width: 30,
                height: 30,
              ),
            ],
          ),
        )
      ],
    ),
  );
}
