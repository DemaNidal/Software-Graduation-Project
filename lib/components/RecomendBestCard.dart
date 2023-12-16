import 'dart:convert';

import 'package:JAFFA/screens/detailshome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/product.dart';
// Make sure to import ProductDetailScreen if it's defined in a separate file.

class RecomendBestCard extends StatefulWidget {
  const RecomendBestCard({
    Key? key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title1, title2;
  final double price;
  final void Function() press;

  @override
  _RecomendBestCardState createState() => _RecomendBestCardState();
}

class _RecomendBestCardState extends State<RecomendBestCard> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    // _loadProductData();
  }

  // Declare isPressed variable here
  List<Product> _products = [];
  Future<void> _loadProductData() async {
    List<dynamic> products = await Product_searchProducts(widget.title1);
    setState(() {
      _products = products.map((json) => Product.fromJson(json)).toList();
      print(products[0]);
      _onCard();
    });
  }

  Future<void> _onCardTap() async {
    List<dynamic> products = await Product_searchProducts(widget.title1);
    if (_products.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: products[0]),
        ),
      );
    } else {
      // Handle case when no products are found
    }
  }

  Future<void> _onCard() async {
    List wishlistProductIds = await favProducts();
    setState(() {
      isPressed = wishlistProductIds.contains(_products[0].id);
    });
  }

  Future<List<dynamic>> Product_searchProducts(String query) async {
    final response =
        await http.post(Uri.parse('$baseUrl/api/product/search?query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);
      _products = productsData.map((json) => Product.fromJson(json)).toList();
      return _products;
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth * 0.5;
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap:
                _onCardTap, // Call the provided function when the image is tapped
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.image,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isPressed ? Colors.red : Colors.white,
                          ),
                          onPressed: () async {
                            setState(() {
                              isPressed = !isPressed;
                            });

                            if (isPressed) {
                              List<dynamic> products =
                                  await Product_searchProducts(widget.title1);
                              try {
                                final response = await http.put(
                                  Uri.parse('$baseUrl/api/product/wishlist/$p'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({'prodId': products[0].id}),
                                );

                                if (response.statusCode == 200) {
                                  // The request was successful, handle the response here
                                  print(
                                      'Product added to wishlist successfully!');
                                } else if (response.statusCode == 400) {
                                  // Handle the case where the request is forbidden (HTTP status code 403)
                                  print(
                                      'Forbidden: You do not have permission to perform this action.');
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Directionality(
                                        textDirection: TextDirection
                                            .rtl, // Set text direction from right to left
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          title: const Text('تنبيه'),
                                          content: const Text(
                                              'المنتج مضاف بالفعل الى قائمة الاعجاب'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[200],
                                              ),
                                              child: const Text(
                                                'حسنًا',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // Handle other status codes here
                                  print('Error: ${response.statusCode}');
                                }

                                print('API Response: ${products[0].id}');
                              } catch (error) {
                                // Handle API call errors here
                                print('Error making API call: $error');
                              }
                            }
                            if (!isPressed) {
                              List<dynamic> products =
                                  await Product_searchProducts(widget.title1);
                              try {
                                final response = await http.delete(
                                  Uri.parse('$baseUrl/api/product/wishlist/$p'),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({'prodId': products[0].id}),
                                );
                                print('API Response: ${products[0].id}');
                              } catch (error) {
                                // Handle API call errors here
                                print('Error making API call: $error');
                              }
                            }
                          },
                        ),
                        Text(
                          widget.title1,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'Lateef'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<List> favProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/api/user/wishlist/$p'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> productData = json.decode(response.body);
    final List<dynamic> wishlistData = productData['wishlist'];
    List wishlistProductIds = wishlistData.map((json) => json['_id']).toList();
    return wishlistProductIds;
  } else {
    print('Failed to load products. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load products');
  }
}
