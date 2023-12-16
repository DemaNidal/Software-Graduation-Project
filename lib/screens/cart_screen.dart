import 'package:JAFFA/screens/orderSteps.dart';
import 'package:flutter/material.dart';
import 'package:JAFFA/components/AppBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JAFFA/components/userCart.dart';
import '../constants.dart';

class CartScreen extends StatefulWidget {
  final int cartCount; // Add the cartCount parameter
  const CartScreen({super.key, required this.cartCount});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String query = "";
  late List<int> counts;

  @override
  void initState() {
    super.initState();
    userCartP(query);
  }

  List<CartItem> cartItems = [];
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
        counts = productsData.map<int>((json) => json['count']).toList();
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> removeItemFromCart(String userId, String itemID) async {
    final url = Uri.parse('$baseUrl/api/user/cart/remove/$p/$itemID');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        // Successfully removed item from the cart, you can handle the response here
        print('Item removed from cart');
      } else if (response.statusCode == 404) {
        // Handle the case where the user or item was not found
        print('User or item not found');
      } else {
        // Handle other error cases
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
    }
  }

  Future<void> updateUserCart(String productId, int count) async {
    final apiUrl = '$baseUrl/api/user/cart/651bf3ae54c72c4af30c10b5/$productId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'count': count}),
      );

      if (response.statusCode == 200) {
        // Cart updated successfully
        print('Cart updated successfully');
      } else {
        // Failed to update cart
        print('Failed to update cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle the error appropriately based on your requirements
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
      // Rethrow the error to indicate failure
      rethrow;
    }
  }

  List<CartResponse> cartresponse = [];
  void removeItem(int index) {
    setState(() {
      counts = List<int>.from(counts)..removeAt(index);
      removeItemFromCart(p, _product[index].id);
      _product.removeAt(index);
      CustomAppBar(cartCount: _product.length);
    });
  }

  void decrement(int index) {
    setState(() {
      if (counts[index] > 1) {
        counts[index]--;
      }
      CartItem updatedCartItem = CartItem(
        count: counts[index],
        price: _product[index].price,
        id: _product[index].id,
      );
      updateUserCart(_product[index].id, counts[index]);
    });
  }

  void increment(int index) {
    setState(() {
      counts[index]++;
      CartItem updatedCartItem = CartItem(
        count: counts[index],
        price: _product[index].price,
        id: _product[index].id,
      );
      updateUserCart(_product[index].id, counts[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(cartCount: _product.length),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                if (_product.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyApp()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            const Color.fromRGBO(245, 223, 187, 0.612),
                        minimumSize: const Size(360, 50),
                      ),
                      child: const Text(
                        'متابعة الشراء',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: "Lateef",
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _product.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              width: 400,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: const Color.fromRGBO(
                                      245, 223, 187, 0.612),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SizedBox(
                                          width:
                                              110, // Change the width to your desired size
                                          child: AspectRatio(
                                            aspectRatio:
                                                1.0, // Maintain the aspect ratio (1.0 means a square aspect ratio)
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(0, 2),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    15), // Apply the same border radius as the container
                                                child: Image.asset(
                                                  _product[index].image,
                                                  fit: BoxFit
                                                      .fill, // You can use different BoxFit options (e.g., BoxFit.contain, BoxFit.fill) to control how the image fits within the container.
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 120, bottom: 0.0),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      removeItem(
                                                          index); // Implement your remove item logic here
                                                    },
                                                    icon:
                                                        const Icon(Icons.close),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _product[index].name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _product[index]
                                                              .price
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    121,
                                                                    121,
                                                                    121),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 100,
                                                        ),
                                                        const Text(
                                                          "السعر",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    121,
                                                                    121,
                                                                    121),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 34,
                                                          height: 32,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              width: 2.0,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  245,
                                                                  223,
                                                                  187,
                                                                  0.612),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: InkWell(
                                                            // Wrap the container with an InkWell to make it clickable
                                                            onTap: () {
                                                              decrement(
                                                                  index); // Add your onPressed logic here
                                                            },
                                                            child: const Center(
                                                              child: Text(
                                                                "-",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 22,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          121,
                                                                          121,
                                                                          121),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Container(
                                                          width: 38,
                                                          height: 38,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              width: 2.0,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  245,
                                                                  223,
                                                                  187,
                                                                  0.612),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              counts[index]
                                                                  .toString(), // Display product count dynamically
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Lateef",
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        8,
                                                                        7,
                                                                        7),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Container(
                                                          width: 34,
                                                          height: 32,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              width: 2.0,
                                                              color: const Color
                                                                  .fromRGBO(
                                                                  245,
                                                                  223,
                                                                  187,
                                                                  0.612),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              increment(index);
                                                            },
                                                            child: const Center(
                                                              child: Text(
                                                                "+",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          121,
                                                                          121,
                                                                          121),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        const Text(
                                                          "الكمية",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    121,
                                                                    121,
                                                                    121),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (counts[index] *
                                                                  _product[
                                                                          index]
                                                                      .price)
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    121,
                                                                    121,
                                                                    121),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 100,
                                                        ),
                                                        const Text(
                                                          "الإجمالي",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "Lateef",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    121,
                                                                    121,
                                                                    121),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
