import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../components/AppBar.dart';
import '../components/product.dart';
import '../../components/cardDesign.dart';
import '../screens/fav.dart';

void main() => runApp(const Coffee());

Future<List<Product>> fetchProducts(http.Response response) async {
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    return list.map((model) => Product.fromJson(model)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class Coffee extends StatefulWidget {
  const Coffee({super.key});

  @override
  _CoffeeState createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  late http.Response response;
  late Widget newPage;
  final List<WishlistItem> _products = [];

  @override
  void initState() {
    super.initState();
    response = http.Response('', 200);
    _fetchCoffeeProducts();
  }

  Future<void> _fetchCoffeeProducts() async {
    try {
      var coffeeResponse =
          await http.post(Uri.parse('$baseUrl/api/product/coffee'));
      setState(() {
        response = coffeeResponse;
      });
    } catch (error) {
      print('Error fetching coffee products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صفحة المنتجات',
      home: Scaffold(
        appBar: CustomAppBar(cartCount: 0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      print("object");
                      response =
                          await http.get(Uri.parse('$baseUrl/api/product/'));
                      // Rebuild the widget tree with the updated response
                      // to trigger the FutureBuilder to fetch data again
                      setState(() {});
                    },
                    backgroundColor: Colors.blue,
                    heroTag: null,
                    child: const Icon(Icons.all_inclusive_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      print("object");
                      response = await http
                          .post(Uri.parse('$baseUrl/api/product/coffee'));
                      // Rebuild the widget tree with the updated response
                      // to trigger the FutureBuilder to fetch data again
                      setState(() {});
                    },
                    backgroundColor: Colors.green,
                    heroTag: null,
                    child: const Icon(Icons.coffee_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      print("object");
                      response = await http
                          .post(Uri.parse('$baseUrl/api/product/food'));
                      // Rebuild the widget tree with the updated response
                      // to trigger the FutureBuilder to fetch data again
                      setState(() {});
                    },
                    backgroundColor: Colors.red,
                    heroTag: null,
                    child: const Icon(Icons.food_bank_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      print("object");
                      response = await http
                          .post(Uri.parse('$baseUrl/api/product/spice'));
                      // Rebuild the widget tree with the updated response
                      // to trigger the FutureBuilder to fetch data again
                      setState(() {});
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    heroTag: null,
                    child: Image.asset('assets/Backgrounds/spices.png'),
                  ),
                  /*    FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      ).then((value) {
                        // Code to execute after the Profile page is popped and the user navigates back
                        setState(() {
                          // Update the state if necessary
                        });
                      });
                    },
                    child: Icon(Icons.favorite),
                    backgroundColor: Colors.pink,
                    heroTag: null,
                  )*/
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: fetchProducts(response),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ProductCard(product: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
