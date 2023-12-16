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
              ShowImg(),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowImg extends StatefulWidget {
  static const List<String> imageUrls = [
    'assets/images/cinnamon.jpg',
    'assets/images/OIG (3).jpg',
    'assets/images/zaater.jpg',
  ];

  const ShowImg({Key? key}) : super(key: key);

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<ShowImg> {
  final int _currentIndex = 0;

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
                    children: ShowImg.imageUrls.map((imageUrl) {
                      final index = ShowImg.imageUrls.indexOf(imageUrl);
                      return AnimatedOpacity(
                        opacity: index == _currentIndex ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 5000),
                        child: Image.asset(
                          'assets/images/OIG (4).jpg',
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
