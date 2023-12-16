import 'dart:async';
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
        body: Container(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagesSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagesSlider extends StatefulWidget {
  static const List<String> imageUrls = [
    'assets/images/cinnamon.jpg',
    'assets/images/OIG (3).jpg',
    'assets/images/spi.jpg',
  ];

  const ImagesSlider({Key? key}) : super(key: key);

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<ImagesSlider> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Create a timer to advance the image every 0.5 seconds
    Timer.periodic(const Duration(milliseconds: 10000), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % ImagesSlider.imageUrls.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.39,
          alignment: Alignment.bottomRight,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                child: Container(
                  height: size.height * 0.39,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: ImagesSlider.imageUrls.map((imageUrl) {
                      final index = ImagesSlider.imageUrls.indexOf(imageUrl);
                      return AnimatedOpacity(
                        opacity: index == _currentIndex ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 5000),
                        child: Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    }).toList(),
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
