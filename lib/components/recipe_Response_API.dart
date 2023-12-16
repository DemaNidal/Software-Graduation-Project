class Recipe {
  final String id;
  final String title;
  final String time;
  final String calo;
  final String prot;
  final double totalRating;
  final List<String> categories;
  final String image;
  final List<String> product;
  final List<String> ingredients;
  final List<String> preparation;

  Recipe({
    required this.id,
    required this.title,
    required this.time,
    required this.calo,
    required this.prot,
    required this.totalRating,
    required this.categories,
    required this.image,
    required this.product,
    required this.ingredients,
    required this.preparation,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'],
      title: json['title'],
      time: json['time'],
      calo: json['calo'],
      prot: json['prot'],
      totalRating:
          json['totalRating'] != null ? json['totalRating'].toDouble() : 0.0,
      categories: List<String>.from(json['categories']),
      image: json['image'],
      product: List<String>.from(json['product']),
      ingredients: List<String>.from(json['ingredients']),
      preparation: List<String>.from(json['preparation']),
    );
  }
}
