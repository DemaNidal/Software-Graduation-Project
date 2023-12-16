import 'dart:convert';

import 'package:custom_rating_bar/custom_rating_bar.dart';

import '../components/userCart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/AppBar.dart';
// Import your Product and Comment models
import 'package:JAFFA/constants.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<Comment> _comments = [];
  List<CartItem> cartItems = [];
  final List<cartProduct> _product = [];
  List<CartResponse> cartresponse = [];
  List<cartProduct> _productd = [];
  String query = '';

  Future<void> userCartP(String query) async {
    String reversedQuery = String.fromCharCodes(query.runes.toList().reversed);

    final response = await http.get(Uri.parse('$baseUrl/api/user/cart/$p'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> cartData = json.decode(response.body);
      final List<dynamic> productsData = cartData['products'];

      setState(() {
        _productd =
            productsData.map((json) => cartProduct.fromJson(json)).toList();
        // Read count for each product and store it in counts list
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  double rating = 0.0;
  @override
  void initState() {
    userCartP(query);
    super.initState();
    _refreshComments();
  }

  final int _quantity = 1;
  final TextEditingController _commentController = TextEditingController();
  Future<void> _addComment(
      String productId, String userName, String userEmail, String text,
      {String? parentCommentId}) async {
    print(productId);
    print(userName);
    print(userEmail);
    print(text);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/comment/$productId/comments'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userName': userName,
          'userEmail': userEmail,
          'text': text,
          'parentCommentId': parentCommentId,
        }),
      );

      if (response.statusCode == 201) {
        // Comment added successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Comment added successfully!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Refresh comments after showing the dialog
                    print('Product ID: $productId');
                    _refreshComments(); // Call _refreshComments here
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to add comment. Status code: ${response.statusCode}');
        // Handle error: Show an error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(
                  'Failed to add comment. Status code: ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error adding comment: $error');
      // Handle error: Show an error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error adding comment: $error'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> ratting(String prodId) async {
    final String url = '$baseUrl/api/product/rating/$p/';

    Map<String, dynamic> requestBody = {
      "star": rating,
      "prodId": prodId,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero, // Remove default padding
            content: Container(
              padding: const EdgeInsets.all(16), // Adjust the padding as needed
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/rating.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const Text(
                      'شكراً لك للمشاركة',
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'تقييمك يساهم من تحسين المنتجات\n ومساعدة غيرك في اتخاذ القرار',
                      style: TextStyle(
                        fontFamily: 'Lateef',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> updateUserCart(
      String userId, List<CartItem> cartItems, int index) async {
    final apiUrl = '$baseUrl/api/user/cart/$userId';

    try {
      List<Map<String, dynamic>> cartItemsJsonList =
          cartItems.map((item) => item.toJson()).toList();

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'cart': cartItemsJsonList}), // Convert List<CartItem> to JSON
      );

      if (response.statusCode == 200) {
        // Cart updated successfully
        print('Cart updated successfully');
        // final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // final cartApiResponse = CartResponse.fromJson(jsonResponse);

        // Update the specific item in the list
      } else {
        // Failed to update cart
        print('Failed to update cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to update cart'); // Throw an exception to indicate failure
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
      rethrow; // Rethrow the error to indicate failure
    }
  }

  Future<void> _refreshComments() async {
    print('Refreshing comments...');
    print('Product ID: ${widget.product.id}');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/comment/${widget.product.id}/comments'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('comments')) {
          final List<Comment> comments = (responseData['comments'] as List)
              .map((data) => Comment.fromJson(data))
              .toList();

          setState(() {
            _comments = comments; // Update the comments list in the state
          });
        } else {
          print('Invalid JSON response: Missing "comments" key');
          // Handle error: Show an error message to the user
        }
      } else {
        print('Failed to fetch comments. Status code: ${response.statusCode}');
        // Handle error: Show an error message to the user
      }
    } catch (error) {
      print('Error fetching comments: $error');
      // Handle error: Show an error message to the user
    }
  }

  void _showCommentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'اضافه تعليق',
              style: TextStyle(
                fontFamily: 'Lateef',
                fontSize: 26,
              ),
            ),
          ),
          content: TextField(
            controller: _commentController,
            textAlign: TextAlign.right, // Align text to the right
            textDirection:
                TextDirection.rtl, // Set text direction to right-to-left
            cursorColor:
                const Color.fromARGB(255, 19, 19, 19), // Set cursor color
            focusNode: FocusNode(), // Prevent keyboard from opening on tap
            decoration: InputDecoration(
              hintText: 'اكتب تعليقك',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Lateef',
                fontSize: 22,
              ), // Set hint text color
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 16, 16, 16)), // Set focus border color
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 8, 8, 8)
                        .withOpacity(0.5)), // Set border color
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(
                    255, 9, 9, 9), // Set the text color of the button
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'الغاء',
                style: TextStyle(
                  fontFamily: 'Lateef',
                  fontSize: 17,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 18, 18, 18), // Set the background color of the button
              ),
              child: const Text(
                'اضافة',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lateef',
                  fontSize: 17,
                ), // Set the text color of the button
              ),
              onPressed: () {
                String comment = _commentController.text;
                if (comment.isNotEmpty) {
                  print(widget.product.id);
                  _addComment(widget.product.id, username, useremail, comment);
                } else {
                  print('لا يمكن اضافة تعليق فارغ');
                }

                _commentController.clear();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildComments() {
    List<Widget> commentWidgets = [];

    for (var comment in _comments) {
      // Use _comments list from the widget's state
      var userIcon = comment.userIcon != null
          ? const CircleAvatar(
              backgroundImage: AssetImage('assets/icons/user.gif'),
              backgroundColor: Color(0x0000ffff),
            )
          : const Icon(Icons.account_circle);
      print(comment.userName);
      commentWidgets.add(
        ListTile(
          leading: userIcon,
          title: Text(
            comment.userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Lateef',
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            comment.text,
            style: const TextStyle(
              fontFamily: 'Lateef',
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return commentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(cartCount: _productd.length),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    widget.product.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'وصف المنتج  :',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lateef',
                        ),
                      ),
                      Text(
                        widget.product.des,
                        style: const TextStyle(
                          fontFamily: 'Lateef',
                          fontSize: 17,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 120,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Save the rating value to your storage or perform any other actions.
                              ratting(widget.product.id);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.grey, // Text color
                              elevation: 4, // Elevation (shadow)
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Button border radius
                              ),
                            ),
                            child: const Text(
                              "تــقـييــم",
                              style: TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: RatingBar(
                              initialRating: 0.0,
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              onRatingChanged: (double newRating) {
                                setState(() {
                                  rating = newRating;
                                });
                                // Save the rating value to your storage or perform any other actions.
                                print("New Rating: $newRating");
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            ' الثمن : ${widget.product.price}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lateef',
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              // Remove the IconButton widgets for quantity
                              // ...
                              FloatingActionButton(
                                onPressed: () {
                                  print("object0");
                                  _showCommentDialog();
                                  // Implement your action for the floating action button
                                }, // Set the icon color here
                                backgroundColor:
                                    const Color.fromARGB(255, 250, 253, 255),
                                child:
                                    const Icon(Icons.add, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          CartItem updatedCartItem = CartItem(
                            /* product: cartProduct(
                                id: widget.product.id,
                                price: widget.product.price,
                                name: widget.product.name,
                                numberOfBuy: 6,
                                numberOfProduct: 10,
                                image: widget.product.imageUrl,
                                description: widget.product.des,
                                type: "",
                                productId: widget.product.product_id),*/
                            count: 1,
                            price: widget.product.price,
                            id: widget.product.id,
                          );
                          updateUserCart(p, [updatedCartItem], 0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(219, 63, 67, 88)
                              .withOpacity(0.7),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: Center(
                              child: Text(
                                'اضف الى السلة',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Lateef',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '  التعليقات: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(children: _buildComments()),
                    ],
                  ),
                ),
                const SizedBox(
                    height:
                        13), // Add an empty space with a height of 13 pixels

                const Column(
                  children: <Widget>[
                    SizedBox(
                        height:
                            70), // Add an empty space with a height of 13 pixels
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
