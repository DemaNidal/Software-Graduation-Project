import 'package:flutter/material.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(5.0),
                  ),
                  onPressed: press,
                  child: const Row(
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back_ios, // Replace with the icon you want
                        color: Colors.black, // Customize icon color as needed
                      ),
                      Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          BestSeller(text: title),
        ],
      ),
    );
  }
}

class BestSeller extends StatelessWidget {
  const BestSeller({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24, // Adjust the font size as needed
                  fontFamily: "Lateef",
                  fontWeight: FontWeight.bold, // Apply the desired font weight
                  color: Colors.black,
                  // Apply the desired text color
                ),
                // Align the text to the right
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: Container(
          //     height: 7,
          //     width: 80,
          //     color: Colors.green.withOpacity(0.2),
          //   ),
          // ),
        ],
      ),
    );
  }
}
