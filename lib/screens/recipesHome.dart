import 'package:JAFFA/components/appbarEdit.dart';
import 'package:JAFFA/components/recipe_Response_API.dart';
import 'package:JAFFA/screens/recipes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JAFFA/constants.dart';

class HomeRecipe extends StatefulWidget {
  const HomeRecipe({super.key});

  @override
  _HomeRecipeState createState() => _HomeRecipeState();
}

class _HomeRecipeState extends State<HomeRecipe> {
  int _current = 0;
  dynamic _selectedIndex = {};
  List<Recipe> recipes = [];
  List<Map<String, dynamic>> _products = [];
  final bool _isInitialLoad = true;
  final CarouselController _carouselController = CarouselController();
  bool _isLoading = true;
  int selectedCategoryIndex = -1;
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/api/recipe/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(data);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> fetchRecipesCategory(String cat) async {
    final response = await http.get(Uri.parse('$baseUrl/api/recipe/$cat'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print(data);
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  void initState() {
    super.initState();
    _products = [];
    _fetchRecipes(-1); // Call the separate method without awaiting it directly
  }

  void _fetchRecipes(int index) async {
    try {
      if (index == -1) {
        recipes = await fetchRecipes();
      } else if (index == 0) {
        recipes = await fetchRecipesCategory('drinks');
      } else if (index == 1) {
        recipes = await fetchRecipesCategory('vegan');
      } else if (index == 2) {
        recipes = await fetchRecipesCategory('breakfast');
      } else if (index == 3) {
        recipes = await fetchRecipesCategory('salads');
      } else if (index == 4) {
        recipes = await fetchRecipesCategory('sweets');
      }

      for (Recipe recipe in recipes) {
        print('Recipe Title: ${recipe.title}');
        print('Calories: ${recipe.calo}');
        print('Rating: ${recipe.totalRating}');
        print('ingredients: ${recipe.ingredients}');
        // Access other fields as needed
      }

      // Update _products here
      _updateProducts();
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateProducts() {
    // Update _products based on the current state of recipes

    setState(() {
      _products = recipes.map((recipe) {
        return {
          'title': recipe.title,
          'time': recipe.time,
          'cal': recipe.calo,
          'prot': recipe.prot,
          'image': recipe.image,
          'product': recipe.product,
          'ingredients': recipe.ingredients,
          'preparation': recipe.preparation,
          'totalRating': recipe.totalRating
        };
      }).toList();
      _isLoading = false;
    });
  }

  bool isLiked = false; // Added variable to track whether the recipe is liked

  List<String> names = [
    'مشروبات',
    'نـبـاتـي',
    'فـطـور',
    'سـلـطـات',
    'حـلـويات'
  ];
  List<String> images = [
    'assets/images/cup.png',
    'assets/images/vegan.png',
    'assets/images/breakfast.png',
    'assets/images/salad.png',
    'assets/images/piece-of-cake.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarEdit(),
      floatingActionButton: _selectedIndex.length > 0
          ? FloatingActionButton(
              onPressed: () {
                print(_selectedIndex['totalRating']);
                print(_selectedIndex['image']);
                print(_selectedIndex['title']);
                print(_selectedIndex['product']);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Recipes(
                      image: _selectedIndex['image'],
                      product: _selectedIndex['product'],
                      time: _selectedIndex['time'],
                      title: _selectedIndex['title'],
                      ingredients: _selectedIndex['ingredients'],
                      preparation: _selectedIndex['preparation'],
                      totalRating: _selectedIndex['totalRating'],
                    ),
                  ),
                  (route) => false,
                );
              },
              backgroundColor: const Color(0xFF5F6F52),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ), // Set the background color to black
            )
          : null,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedCategoryIndex == index) {
                            selectedCategoryIndex = -1; // Unselect the category
                            _fetchRecipes(-1);
                          } else {
                            selectedCategoryIndex = index;
                            if (index == 0) {
                              _fetchRecipes(0);
                            }
                            if (index == 1) {
                              _fetchRecipes(1);
                            }
                            if (index == 2) {
                              _fetchRecipes(2);
                            }
                            if (index == 3) {
                              _fetchRecipes(3);
                            }
                            if (index == 4) {
                              _fetchRecipes(4);
                            }
                          }
                        });
                      },
                      child: Catagories(
                        isSelected: selectedCategoryIndex == index,
                        image: images[index],
                        name: names[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 190),
                  child: Container(
                    height: 50, // Set the desired height
                    // color: Colors.blue, // Set the desired color
                    alignment: Alignment.topRight,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'خـصـيصـاً لــكـ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Lateef",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CarouselSlider(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                              height: 450.0,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.70,
                              enlargeCenterPage: true,
                              pageSnapping: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                          items: _products.map((movie) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_selectedIndex == movie) {
                                        _selectedIndex = {};
                                      } else {
                                        _selectedIndex = movie;
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: _selectedIndex == movie
                                            ? Border.all(
                                                color: const Color(0xFF5F6F52),
                                                width: 3)
                                            : null,
                                        boxShadow: _selectedIndex == movie
                                            ? [
                                                const BoxShadow(
                                                    color: Color(0xFF5F6F52),
                                                    blurRadius: 30,
                                                    offset: Offset(0, 10))
                                              ]
                                            : [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 5))
                                              ]),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 320,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Image.asset(
                                              movie['image'],
                                              fit: BoxFit.cover,
                                              //width: double.,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.elliptical(5, 5),
                                                      ),
                                                      color: const Color(
                                                          0xFFA9B388),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              0, 5),
                                                          blurRadius: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/icons/back-in-time.png',
                                                          height: 17,
                                                          width: 17,
                                                        ),
                                                        Text(
                                                          movie['time'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontFamily:
                                                                "Lateef",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const Text(
                                                          'min',
                                                          style:
                                                              TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                "Lateef",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.elliptical(5, 5),
                                                      ),
                                                      color: const Color(
                                                          0xFFFEFAE0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              0, 5),
                                                          blurRadius: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom: 0.0,
                                                          ),
                                                          child: Text(
                                                            "  Cal ",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Lateef",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: 2.0,
                                                          ),
                                                          child: Text(
                                                            movie['cal'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                              fontFamily:
                                                                  "Lateef",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Container(
                                                    height: 25,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.elliptical(5, 5),
                                                      ),
                                                      color: const Color(
                                                          0xFFB99470),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              0, 5),
                                                          blurRadius: 5,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "  Prot ",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Lateef",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          movie['prot'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                            fontFamily:
                                                                "Lateef",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                movie['title'],
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontFamily: "Lateef",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList()),
                ),
                Container(
                  height: 100,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Catagories extends StatelessWidget {
  final bool isSelected;
  final String name;
  final String image;

  const Catagories({
    super.key,
    required this.isSelected,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        height: 105,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          color: isSelected ? const Color(0xFF5F6F52) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 5),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      image,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontFamily: "Lateef",
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
