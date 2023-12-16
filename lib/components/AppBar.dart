import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import 'package:JAFFA/screens/Profile.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  int cartCount = 0; // Placeholder for cart count
  CustomAppBar({super.key, required this.cartCount});
  //   void updateCartCount(int newCount) {
  //   cartCount = newCount;
  // }

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
            child: Image.asset(
              "assets/icons/profile.png",
              width: 35,
              height: 35,
              color: Colors.brown,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 70,
                  height: 110,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen(
                              cartCount: 0,
                            )),
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      "assets/icons/parcel.png",
                      width: 32,
                      height: 32,
                      color: Colors.brown,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                      child: Text(
                        widget.cartCount.toString(), // Display the cart count
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
