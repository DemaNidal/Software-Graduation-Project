import 'dart:convert';

import 'package:http/http.dart' as http;

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final int id;
  final String des;
  final String PID;
  bool isLiked;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.id,
    required this.des,
    required this.PID,
    this.isLiked = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      id: json['product_id'] ?? 0,
      des: json['description'] ?? '',
      PID: json['_id'] ?? '',
    );
  }
  Future<List<Product>> fetchProducts(http.Response response) async {
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Product.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class Comment {
  final String userIcon;
  final String userName;
  final String text;

  Comment({
    required this.userIcon,
    required this.userName,
    required this.text,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userIcon: json['userIcon'] ?? '',
      userName: json['userName'] ?? '',
      text: json['text'] ?? '',
    );
  }

  // Named constructor with default user icon
  Comment.withDefaultIcon({
    required this.userName,
    required this.text,
  }) : userIcon =
            'assets/icons/user.json'; // Replace 'path_to_default_user_icon' with the actual path to your default user icon asset
}
