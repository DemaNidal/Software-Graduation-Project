import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../components/AppBar.dart';
import '../../models/product.dart';
import '../../screens/details.dart';

void main() {
  runApp(const MyApp());
}

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];

  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        _products.clear();
      });
      return;
    }

    final response =
        await http.post(Uri.parse('$baseUrl/api/product/search?query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> productsData = json.decode(response.body);
      setState(() {
        _products = productsData.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(cartCount: 0),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Colors.black,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'البحث عن المنتج',
                        hintText: 'ادخل اسم المنتج....',
                        hintStyle: const TextStyle(),
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      onChanged: (query) {
                        _searchProducts(query);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductTile(_products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        title: Text(product.name),
        subtitle: Text('الثمن: ${product.price}'),
        leading: CircleAvatar(
          backgroundImage: AssetImage(product.imageUrl),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => entryPoint(product: product),
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'البحث عن المنتج',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ProductSearchScreen(),
      ),
    );
  }
}

// Define your CustomAppBar and ProductDetailScreen classes if they are not provided in this code snippet.

// Define your CustomAppBar and ProductDetailScreen classes if they are not provided in this code snippet.
