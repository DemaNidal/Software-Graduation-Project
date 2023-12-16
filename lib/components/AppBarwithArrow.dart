import 'package:JAFFA/screens/Profile.dart';
import 'package:JAFFA/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBarwithArrow extends StatelessWidget
    implements PreferredSizeWidget {
  final String nav;
  const CustomAppBarwithArrow({super.key, required this.nav});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/icons8-search.svg",
            width: 35,
            height: 35,
            color: Colors.brown,
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
          InkWell(
            onTap: () {
              if (nav == "profile") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()));
              } else if (nav == "cart") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen(
                              cartCount: 0,
                            )));
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
            child: SvgPicture.asset(
              "assets/icons/forward_arrow.svg",
              width: 28,
              height: 30,
              color: Colors.brown,
            ),
          )
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
