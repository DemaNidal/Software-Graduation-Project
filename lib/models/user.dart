class User {
  final String role;
  final String id;
  final String email;
  final String fullName;
  final String password;
  final String livePlace;
  final int phoneNumber;
  final DateTime dateOfBirth;
  final bool isAdmin;
  final int v;
  final DateTime updatedAt;
  final List<WishlistItem> wishlist;

  User({
    required this.role,
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.livePlace,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.isAdmin,
    required this.v,
    required this.updatedAt,
    required this.wishlist,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final List<dynamic> wishlistData = json['wishlist'];
    final List<WishlistItem> wishlistItems = wishlistData.map((item) {
      return WishlistItem.fromJson(item);
    }).toList();

    return User(
      role: json['role'] ?? '',
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      password: json['password'] ?? '',
      livePlace: json['livePlace'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? ''),
      isAdmin: json['isAdmin'] ?? false,
      v: json['__v'] ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      wishlist: wishlistItems,
    );
  }
}

class WishlistItem {
  final String id;
  final int productId;
  final double price;
  final String name;
  final String image;
  final int numberOfBuy;
  final int numberOfProduct;
  final String type;
  final String description;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.price,
    required this.name,
    required this.image,
    required this.numberOfBuy,
    required this.numberOfProduct,
    required this.type,
    required this.description,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? 0,
      price: json['price']?.toDouble() ?? 0.0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      numberOfBuy: json['numberOfBuy'] ?? 0,
      numberOfProduct: json['numberOfProduct'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
