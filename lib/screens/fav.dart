import '../../components/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../screens/entry_point.dart';
import '../../screens/Profile.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../mode/menu.dart';

import '../constants.dart';

class User {
  final String role;
  final String id;
  final String email;
  final String fullName;
  final String password;
  final String livePlace;
  final int phoneNumber;
  final DateTime dateOfBirth;
  final bool isAdmin;
  final int v;
  final DateTime updatedAt;
  final List<WishlistItem> wishlist;

  User({
    required this.role,
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.livePlace,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.isAdmin,
    required this.v,
    required this.updatedAt,
    required this.wishlist,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final List<dynamic> wishlistData = json['wishlist'];
    final List<WishlistItem> wishlistItems = wishlistData.map((item) {
      return WishlistItem.fromJson(item);
    }).toList();

    return User(
      role: json['role'] ?? '',
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      password: json['password'] ?? '',
      livePlace: json['livePlace'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? ''),
      isAdmin: json['isAdmin'] ?? false,
      v: json['__v'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      wishlist: wishlistItems,
    );
  }
}

class WishlistItem {
  final String id;
  final int productId;
  final double price;
  final String name;
  final String image;
  final int numberOfBuy;
  final int numberOfProduct;
  final String type;
  final String description;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.price,
    required this.name,
    required this.image,
    required this.numberOfBuy,
    required this.numberOfProduct,
    required this.type,
    required this.description,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      numberOfBuy: json['numberOfBuy'] ?? 0,
      numberOfProduct: json['numberOfProduct'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> with SingleTickerProviderStateMixin {
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

  List<WishlistItem> _products = [];

  String query = "";

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
    favProducts();
  }

  Future<void> favProducts() async {
    print("setstate0");
    final response = await http.get(Uri.parse('$baseUrl/api/user/wishlist/$p'));
    print("setstate1");
    if (response.statusCode == 200) {
      final Map<String, dynamic> productData = json.decode(response.body);
      final List<dynamic> productsData = productData['wishlist'];

      // Check if the product already exists in the wishlist
      bool productExists =
          productsData.any((json) => json['productId'] == productData);

      if (!productExists) {
        setState(() {
          _products =
              productsData.map((json) => WishlistItem.fromJson(json)).toList();
          print("Product added to wishlist.");
        });
      } else {
        print("Product already exists in the wishlist.");
      }
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updatePage(Menu selectedMenu) {
    String pageTitle = selectedMenu.title;
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
    }

    // Use the Navigator to push the new page
    Navigator.push(context, MaterialPageRoute(builder: (context) => newPage));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(cartCount: 0),
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white, // Change background color to white
        //this back when press side menu
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GridView.builder(
                  itemCount: _products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) =>
                      Cart(product: _products[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Cart extends StatelessWidget {
  final WishlistItem product;

  const Cart({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth * 0.3;
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.4, // Set the width of the container
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.image,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 150,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Implement your add to cart logic here
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 40,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: "Lateef",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(219, 63, 67, 88).withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                          ),
                        ),
                        onPressed: () {
                          // Implement your add to cart logic here
                        },
                        child: const Text(
                          'اضف الى السلة',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Lateef",
                            color: Color.fromARGB(255, 249, 247, 247),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(
      home: Fav(),
    ));
