import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageSlider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomImageSlider extends StatefulWidget {
  static const List<String> imageUrls = [
    'assets/images/coff.jpg',
    'assets/images/spic.jpg',
    'assets/images/shop.jpg',
  ];
  static const List<String> imageTexts = [
    'استمتع بتنوع النكهات، اشرب قهوتنا الرائعة اليوم!',
    'مجموعتناالمتنوعة من البهارات الفاخرة!',
    'تشكيلة متنوعة من المواد الغذائية الطازجة',
  ];

  const CustomImageSlider({Key? key}) : super(key: key);

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  String _currentText = "";

  @override
  void initState() {
    super.initState();
    startImageSlider();
  }

  void startImageSlider() {
    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_currentIndex < CustomImageSlider.imageUrls.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
      // Reset the text animation
      _currentText = "";
      animateText();
    });
  }

  void animateText() {
    String targetText = CustomImageSlider.imageTexts[_currentIndex];
    int delay = 100; // Milliseconds between character animations

    for (int i = 0; i < targetText.length; i++) {
      Timer(Duration(milliseconds: i * delay), () {
        setState(() {
          _currentText = targetText.substring(0, i + 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.30,
          alignment: Alignment.bottomRight,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Container(
                  height: size.height * 0.39,
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: CustomImageSlider.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Image.asset(
                            CustomImageSlider.imageUrls[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              _currentText, // Show the animated text
                              style: const TextStyle(
                                fontSize: 18, // Adjust the font size as needed
                                fontFamily: "Lateef",
                                fontWeight: FontWeight
                                    .bold, // Apply the desired font weight
                                color: Colors.white,

                                // Apply the desired text color
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    // onPageChanged: (index) {
                    //   setState(() {
                    //     _currentIndex = index;
                    //     // Reset the text when changing images
                    //     _currentText = "";
                    //   });
                    //   animateText();
                    // },
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 10,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 0.0,
                        sigmaY: 0.0,
                      ),
                      child: Container(
                        height: double.infinity, // Cover the entire height
                        width: double.infinity, // Cover the entire width
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
