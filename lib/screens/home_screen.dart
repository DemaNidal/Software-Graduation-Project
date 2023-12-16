import 'package:JAFFA/components/userCart.dart';
import 'package:JAFFA/screens/Spice.dart';
import 'package:JAFFA/screens/recipesHome.dart';
import 'package:flutter/material.dart';
import 'package:JAFFA/components/AppBar.dart';
import 'package:JAFFA/components/ImagesBar.dart';

import 'package:JAFFA/components/slider.dart';
import 'package:JAFFA/components/title_with_more_bbtn.dart';
import 'package:JAFFA/components/RecomendBestCard.dart';
import 'package:JAFFA/components/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'coffee.dart';
import 'food.dart';
// import 'package:marquee/marquee.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  List<Product> _products1 = [];
  List<Product> _products2 = [];
  List<Product> _products3 = [];
  List<String> imageUrls = [];
  List<String> imageUrls1 = [];
  List<String> imageUrls2 = [];
  List<String> imageUrls3 = [];

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

  final response = "";

  String query = "";

  @override
  void initState() {
    print("log");
    super.initState();
    BestSeller(query);
    coffee(query);
    spices(query);
    food(query);
    userCartP(query);
  }

  Future<void> BestSeller(String query) async {
    try {
      http.Response? response;
      response = await http.post(Uri.parse('$baseUrl/api/product/best'));

      if (response.statusCode == 200) {
        final List<dynamic> productsData = json.decode(response.body);
        if (productsData.isNotEmpty) {
          setState(() {
            _products =
                productsData.map((json) => Product.fromJson(json)).toList();

            // Extract imageUrl properties and save them in another array
            imageUrls = _products.map((product) => product.imageUrl).toList();
            // Do something with the imageUrls array, such as saving it in a state variable or using it elsewhere in your app.
            print('Image URLs: $imageUrls');
          });
        } else {
          print('Empty list received from API.');
          // Handle empty response gracefully, show a message, or set a default value for _products.
        }
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle API error, show an error message, or set a default value for _products.
      }
    } catch (error) {
      print('Error occurred: $error');
      // Handle other errors, show an error message, or set a default value for _products.
    }
  }

  Future<void> coffee(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/product?type=coffe'));

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);

      setState(() {
        _products1 =
            productsData.map((json) => Product.fromJson(json)).toList();
        imageUrls1 = _products1.map((product) => product.imageUrl).toList();
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> spices(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/product?type=spices'));

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);

      setState(() {
        _products2 =
            productsData.map((json) => Product.fromJson(json)).toList();
        imageUrls2 = _products2.map((product) => product.imageUrl).toList();
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> food(String query) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response =
        await http.get(Uri.parse('$baseUrl/api/product?type=food'));

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);

      setState(() {
        _products3 =
            productsData.map((json) => Product.fromJson(json)).toList();
        imageUrls3 = _products3.map((product) => product.imageUrl).toList();
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Variables

    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(cartCount: _product.length),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CustomImageSlider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 20, right: 16),
                        child: SizedBox(
                          height: 95,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Coffee()),
                                  );
                                },
                                child: SizedBox(
                                  width: 166,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/kahwaa.jpg', // Replace with your image file path
                                            fit: BoxFit
                                                .cover, // Adjust the fit as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 166,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "القهوة",
                                            style: TextStyle(
                                              fontSize:
                                                  25, // Adjust the font size as needed
                                              fontFamily: "Lateef",
                                              // Apply the desired font weight
                                              color: Colors.white,
                                              // Apply the desired text color
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Spice()),
                                  );
                                },
                                child: SizedBox(
                                  width: 166,
                                  height:
                                      160, // Adjusted the height to fit the image and text
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/spice.jpg', // Replace with your image file path
                                            fit: BoxFit
                                                .cover, // Adjust the fit as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 166,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "البهارات",
                                            style: TextStyle(
                                              fontSize:
                                                  25, // Adjust the font size as needed
                                              fontFamily: "Lateef",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                              const SizedBox(
                                width: 20.0,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Food()),
                                  );
                                },
                                child: SizedBox(
                                  width: 166,
                                  height:
                                      160, // Adjusted the height to fit the image and text
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/food.jpg', // Replace with your image file path
                                            fit: BoxFit
                                                .cover, // Adjust the fit as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 166,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                                  0, 54, 68, 34)
                                              .withOpacity(0.6),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "المواد الغذائية",
                                            style: TextStyle(
                                              fontSize:
                                                  25, // Adjust the font size as needed
                                              fontFamily: "Lateef",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeRecipe()),
                                  );
                                },
                                child: SizedBox(
                                  width: 166,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/recipe.jpg', // Replace with your image file path
                                            fit: BoxFit
                                                .cover, // Adjust the fit as needed
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 166,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "الوصفات",
                                            style: TextStyle(
                                              fontSize:
                                                  25, // Adjust the font size as needed
                                              fontFamily: "Lateef",
                                              // Apply the desired font weight
                                              color: Colors.white,

                                              // Apply the desired text color
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              SizedBox(
                                width: 166,
                                height: 60,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/messenger.png', // Replace with your image file path
                                          height: 5, // Adjust the fit as needed
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 166,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                                255, 84, 58, 49)
                                            .withOpacity(0.6),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "التواصل",
                                          style: TextStyle(
                                            fontSize:
                                                25, // Adjust the font size as needed
                                            fontFamily: "Lateef",
                                            // Apply the desired font weight
                                            color: Colors.white,

                                            // Apply the desired text color
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: const Color.fromRGBO(254, 244, 225, 0.612),
                        child: Column(
                          children: [
                            TitleWithMoreBtn(
                              title: "الأكثر مبيعاً",
                              press: () {},
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true, // Set this to true
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[0],
                                            title1: _products[0].name,
                                            title2: "",
                                            price:
                                                _products[0].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[1],
                                            title1: _products[1].name,
                                            title2: "",
                                            price:
                                                _products[1].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[2],
                                            title1: _products[2].name,
                                            title2: "",
                                            price:
                                                _products[2].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[3],
                                            title1: _products[3].name,
                                            title2: "",
                                            price:
                                                _products[3].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[4],
                                            title1: _products[4].name,
                                            title2: "",
                                            price:
                                                _products[4].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[5],
                                            title1: _products[5].name,
                                            title2: "",
                                            price:
                                                _products[5].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[6],
                                            title1: _products[6].name,
                                            title2: "",
                                            price:
                                                _products[6].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products.isNotEmpty &&
                                            imageUrls.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls[7],
                                            title1: _products[7].name,
                                            title2: "",
                                            price:
                                                _products[7].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                ],
                              ),
                            ), /////////////////////////////////////////////////////////
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          color: const Color.fromRGBO(179, 161, 122,
                              0.612), // Set the background color here
                          // child: Padding(
                          //   padding: const EdgeInsets.only(top: 15),
                          //   child: Marquee(
                          //      // Text you want to scroll
                          //     style: const TextStyle(
                          //       fontSize: 20,
                          //       fontFamily: "Lateef",
                          //       color: Colors.brown,
                          //     ),
                          //     scrollAxis:
                          //         Axis.horizontal, // Scroll horizontally
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     blankSpace:
                          //         400.0, // Blank space before repeating the text
                          //     velocity:
                          //         -50.0, // Use a negative value to reverse the scroll
                          //     startPadding: 10.0, // Padding at the start
                          //   ),
                          // ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            TitleWithMoreBtn(
                              title: "قهوة",
                              press: () {},
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true, // Set this to true
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[0],
                                            title1: _products1[0].name,
                                            title2: "",
                                            price:
                                                _products1[0].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[1],
                                            title1: _products1[1].name,
                                            title2: "",
                                            price:
                                                _products1[1].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[2],
                                            title1: _products1[2].name,
                                            title2: "",
                                            price:
                                                _products1[2].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[3],
                                            title1: _products1[3].name,
                                            title2: "",
                                            price:
                                                _products1[3].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[4],
                                            title1: _products1[4].name,
                                            title2: "",
                                            price:
                                                _products1[4].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[5],
                                            title1: _products1[5].name,
                                            title2: "",
                                            price:
                                                _products1[5].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[6],
                                            title1: _products1[6].name,
                                            title2: "",
                                            price:
                                                _products1[6].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products1.isNotEmpty &&
                                            imageUrls1.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls1[7],
                                            title1: _products1[7].name,
                                            title2: "",
                                            price:
                                                _products1[7].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                ],
                              ),
                            ),
                            // Add auto-scrolling text here
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const ImagesSlider(),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: const Color.fromRGBO(254, 244, 225, 0.612),
                        child: Column(
                          children: [
                            TitleWithMoreBtn(
                              title: "بهارات",
                              press: () {},
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true, // Set this to true
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[0],
                                            title1: _products2[0].name,
                                            title2: "",
                                            price:
                                                _products2[0].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[1],
                                            title1: _products2[1].name,
                                            title2: "",
                                            price:
                                                _products2[1].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[2],
                                            title1: _products2[2].name,
                                            title2: "",
                                            price:
                                                _products2[2].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[3],
                                            title1: _products2[3].name,
                                            title2: "",
                                            price:
                                                _products2[3].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[4],
                                            title1: _products2[4].name,
                                            title2: "",
                                            price:
                                                _products2[4].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[5],
                                            title1: _products2[5].name,
                                            title2: "",
                                            price:
                                                _products2[5].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[6],
                                            title1: _products2[6].name,
                                            title2: "",
                                            price:
                                                _products2[6].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products2.isNotEmpty &&
                                            imageUrls2.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls2[7],
                                            title1: _products2[7].name,
                                            title2: "",
                                            price:
                                                _products2[7].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            TitleWithMoreBtn(
                              title: "مواد غذائية",
                              press: () {},
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true, // Set this to true
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[0],
                                            title1: _products3[0].name,
                                            title2: "",
                                            price:
                                                _products3[0].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[1],
                                            title1: _products3[1].name,
                                            title2: "",
                                            price:
                                                _products3[1].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[2],
                                            title1: _products3[2].name,
                                            title2: "",
                                            price:
                                                _products3[2].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[3],
                                            title1: _products3[3].name,
                                            title2: "",
                                            price:
                                                _products3[3].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[4],
                                            title1: _products3[4].name,
                                            title2: "",
                                            price:
                                                _products3[4].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[5],
                                            title1: _products3[5].name,
                                            title2: "",
                                            price:
                                                _products3[5].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[6],
                                            title1: _products3[6].name,
                                            title2: "",
                                            price:
                                                _products3[6].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 20),
                                    child: _products3.isNotEmpty &&
                                            imageUrls3.isNotEmpty
                                        ? RecomendBestCard(
                                            image: imageUrls3[7],
                                            title1: _products3[7].name,
                                            title2: "",
                                            price:
                                                _products3[7].price.toDouble(),
                                            press: () {},
                                            // Wrap the text widgets with Padding and provide the desired padding values
                                          )
                                        : const CircularProgressIndicator(), // Show a loading indicator while data is being fetched
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      //const ShowImg(),
                      const SizedBox(
                        height: 50,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
