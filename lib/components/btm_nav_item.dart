import 'package:JAFFA/screens/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../screens/search.dart';
import '../../../mode/menu.dart';
import 'animated_bar.dart';
import '../screens/onboding/components/sign_in_dialog.dart';

class BtmNavItem extends StatelessWidget {
  const BtmNavItem({
    Key? key,
    required this.navBar,
    required this.press,
    required this.riveOnInit,
    required this.selectedNav,
  }) : super(key: key);

  final Menu navBar;
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;
  final Menu selectedNav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Call the press function if it's not null
        press();
      
        print("Icon name: ${navBar.rive.artboard}");
        if (navBar.rive.artboard == 'USER') {
          showCustomDialog(context, onValue: (value) {
            if (value != null && value) {
              // User confirmed

              print("User confirmed");
            }
          });
        } else if (navBar.rive.artboard == "SEARCH") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductSearchScreen(),
            ),
          );
          print("User cancelled or null value");
        } else if (navBar.rive.artboard == "HOME") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntryPoint(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBar(isActive: selectedNav == navBar),
          SizedBox(
            height: 36,
            width: 36,
            child: Opacity(
              opacity: selectedNav == navBar ? 1 : 0.5,
              child: RiveAnimation.asset(
                navBar.rive.src,
                artboard: navBar.rive.artboard,
                onInit: riveOnInit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
