class CartResponse {
  final String id;
  final List<CartItem> products;
  final double cartTotal;
  final String orderby;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CartResponse({
    required this.id,
    required this.products,
    required this.cartTotal,
    required this.orderby,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productsData = json['products'];
    final List<CartItem> cartItems = productsData.map((item) {
      return CartItem.fromJson(item);
    }).toList();

    return CartResponse(
      id: json['_id'] ?? '',
      products: cartItems,
      cartTotal: json['cartTotal'] ?? 0.0,
      orderby: json['orderby'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> productsJson =
        products.map((item) => item.toJson()).toList();

    return {
      '_id': id,
      'products': productsJson,
      'cartTotal': cartTotal,
      'orderby': orderby,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class CartItem {
  //final cartProduct product;
  final int count;
  final num price;
  final String id;

  CartItem({
    // required this.product,
    required this.count,
    required this.price,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> productData = json['product'];
    final cartProduct product = cartProduct.fromJson(productData);

    return CartItem(
      //   product: product,
      count: json['count'] ?? 0,
      price: json['price'] ?? 0.0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'product': product.toJson(),
      'count': count,
      'price': price,
      '_id': id,
    };
  }
}

class cartProduct {
  final String id;
  final num price;
  final String name;
  final int numberOfBuy;
  final int numberOfProduct;
  final String image;
  final String description;
  final String type;
  final int productId;

  cartProduct({
    required this.id,
    required this.price,
    required this.name,
    required this.numberOfBuy,
    required this.numberOfProduct,
    required this.image,
    required this.description,
    required this.type,
    required this.productId,
  });
  factory cartProduct.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> productData = json['product'];

    return cartProduct(
      id: productData['_id'] ?? '',
      price: productData['price'] ?? 0.0,
      name: productData['name'] ?? '',
      numberOfBuy: productData['numberOfBuy'] ?? 0,
      numberOfProduct: productData['numberOfProduct'] ?? 0,
      image: productData['image'] ?? '',
      description: productData['description'] ?? '',
      type: productData['type'] ?? '',
      productId: productData['product_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'product_id': id,
      'description': description,
      '_id': id,
    };
  }
}
