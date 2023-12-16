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

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String id;
  final String des;
  final int product_id;
  final List<Comment> comments; // List of Comment objects
  // bool isLiked;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.id,
    required this.des,
    required this.product_id,
    required this.comments, // Include comments property in the constructor
    //  this.isLiked = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse comments from JSON and create Comment objects
    List<Comment> comments = [];
    if (json['comments'] != null) {
      comments = List<Comment>.from(json['comments'].map((comment) {
        return Comment(
          userIcon: comment['userIcon'] ?? '',
          userName: comment['userName'] ?? '',
          text: comment['text'] ?? '',
        );
      }));
    }

    return Product(
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      id: json['_id'] ?? '',
      des: json['description'] ?? '',
      product_id: json['product_id'] ?? 0,
      comments: comments
          .map((comment) => comment.userIcon.isNotEmpty
              ? comment
              : Comment.withDefaultIcon(
                  userName: comment.userName, text: comment.text))
          .toList(),
    );
  }
}
