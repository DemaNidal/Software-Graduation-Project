import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/product.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = screenWidth * 0.3;

    return Container(
      margin: const EdgeInsets.only(right: 4, top: 3, bottom: 12),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.product.imageUrl,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.product.isLiked = !widget.product.isLiked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 50,
                        color: Colors.black.withOpacity(0.13),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 55),
                        child: Text(
                          '\$${widget.product.price}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              widget.product.name,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () {
                              // Handle detail button tap
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                            ),
                            child: const Text('التفاصيل'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 200,
            left: 8,
            child: IconButton(
              icon: Icon(
                widget.product.isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () async {
                setState(() {
                  widget.product.isLiked = !widget.product.isLiked;
                });

                if (isPressed) {
                  print(p);
                  try {
                    final response = await http.delete(
                      Uri.parse('$baseUrl/api/product/wishlist/$p'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'prodId': widget.product.PID}),
                    );
                    print(p);

                    if (response.statusCode == 200) {
                      // The request was successful, handle the response here
                      print('Product added to wishlist successfully!');
                    } else if (response.statusCode == 400) {
                      // Handle the case where the request is forbidden (HTTP status code 403)
                      print(
                          'Forbidden: You do not have permission to perform this action.');
                      // Handle the error or show a dialog here
                    } else {
                      // Handle other status codes here
                      print('Error: ${response.statusCode}');
                      // Handle the error or show a dialog here
                    }
                  } catch (error) {
                    // Handle API call errors here
                    print('Error making API call: $error');
                    // Handle the error or show a dialog here
                  }
                } else {
                  try {
                    print(widget.product.PID);
                    final response = await http.put(
                      Uri.parse('$baseUrl/api/product/wishlist/$p'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'prodId': widget.product.PID}),
                    );

                    if (response.statusCode == 200) {
                      // The request was successful, handle the response here
                      print('Product removed from wishlist successfully!');
                    } else {
                      // Handle other status codes here
                      print('Error: ${response.statusCode}');
                      // Handle the error or show a dialog here
                    }
                  } catch (error) {
                    // Handle API call errors here
                    print('Error making API call: $error');
                    // Handle the error or show a dialog here
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
