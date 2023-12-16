import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 100,
        width: 600,
        child: Stack(
          children: [
            SvgPicture.asset(
              "assets/icons/button.svg", // Replace with the path to your SVG file
              // Set the desired height
            ),
            Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Adjust the bottom padding as needed
                    child: SvgPicture.asset(
                      "assets/icons/Arrow Right.svg", // Replace with the path to your SVG file
                      width: 24, // Set the desired width
                      height: 24, // Set the desired height
                      color: const Color.fromARGB(215, 238, 234,
                          231), // Change the color here to your desired color
                    ),
                  ),
                  // Other widgets in the Row

                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 15), // Adjust the top padding as needed
                    child: Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                        color: Color.fromARGB(215, 238, 234, 231),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
