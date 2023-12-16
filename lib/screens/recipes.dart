import 'package:JAFFA/screens/recipesHome.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JAFFA/constants.dart';

class Recipes extends StatefulWidget {
  final String image;
  final String time;
  final String title;
  final double totalRating;
  final List<String> product;
  final List<String> ingredients;
  final List<String> preparation;

  const Recipes(
      {super.key,
      required this.image,
      required this.product,
      required this.time,
      required this.title,
      required this.ingredients,
      required this.preparation,
      required this.totalRating});

  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetOpen = false;
  int ch = 0;
  List<String> tabs = [
    "الـمـكـونـات",
    'طــريـقـة الـتــحــضــير',
  ];
  bool isSelected = false;
  List<String> images = [];
  List<String> names = [];
  int current = 0;
  bool _isLoading = true;

  Future<void> getProductImage(String prodId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/product/$prodId'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        setState(() {
          images.add(responseBody['image']);
          names.add(responseBody['name']);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Future<void>> futures = [];

    for (int i = 0; i < widget.product.length; i++) {
      futures.add(getProductImage(widget.product[i]));
    }

    Future.wait(futures).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              // Your existing code for the background image and other UI elements
              Container(
                height: 600,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 15,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeRecipe(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.8,
            minChildSize: 0.4,
            initialChildSize: 0.4,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 28.0,
                          ),
                          Text(
                            widget.totalRating.toString(),
                            style: const TextStyle(
                              fontFamily: 'Lateef',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            widget.title.toString(),
                            style: const TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "دقـــيـقـة",
                            style: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.time.toString(),
                            style: const TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "|",
                            style: TextStyle(
                              fontFamily: "Lateef",
                              fontSize: 34,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (int.tryParse(widget.time) != null &&
                              int.parse(widget.time) <= 30)
                            const Text(
                              'ســهــل',
                              style: TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                          else if (int.tryParse(widget.time) != null &&
                              int.parse(widget.time) > 30)
                            const Text(
                              'مــتــوســط',
                              style: TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                          else if (int.tryParse(widget.time) != null &&
                              int.parse(widget.time) >= 60)
                            const Text(
                              'صــعــب',
                              style: TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  isSelected = false;
                                } else {
                                  isSelected = true;
                                }
                                // Select the category
                              });
                            },
                            child: Catagories(
                              isSelected: isSelected,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.topRight,
                            child: const Text(
                              "المنتجات المستخدمة",
                              style: TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (int i = 0; i < names.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.ingredients[i].toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Lateef',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    names[i],
                                    style: const TextStyle(
                                      fontFamily: 'Lateef',
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Products(
                                      image: images[i],
                                      isSelected: isSelected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    for (int i = 0; i < widget.preparation.length; i++)
                      Container(
                        alignment: Alignment.topRight,
                        child: ListTile(
                          title: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              'الخطوة ${i + 1}',
                              style: const TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 20,
                              ),
                            ),
                          ),
                          subtitle: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              widget.preparation[i],
                              style: const TextStyle(
                                fontFamily: 'Lateef',
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Text(
                    //     "fjk jkisjdikj  dsiuhfcie hifcuahaiuf hifuesh hurfe uhudw huhrf gyuaojfcni hguyb hgugubjksc guygca"),
                    // Container(
                    //   alignment: Alignment.topRight,
                    //   // height: MediaQuery.of(context).size.height,
                    //   child: _isLoading
                    //       ? const Center(
                    //           child: CircularProgressIndicator(),
                    //         )
                    //       : Column(
                    //           children: [
                    //             ListView.builder(
                    //               shrinkWrap: true,
                    //               itemCount: images.length,
                    //               itemBuilder:
                    //                   (BuildContext context, int index) {
                    //                 return Padding(
                    //                   padding:
                    //                       const EdgeInsets.only(right: 18.0),
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(
                    //                             left: 18.0),
                    //                         child: Container(
                    //                           alignment: Alignment.topLeft,
                    //                           child: const Text(
                    //                             '1م.ص',
                    //                             style: TextStyle(
                    //                               fontFamily: 'Lateef',
                    //                               fontSize: 18,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       Expanded(
                    //                         child: Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.end,
                    //                           children: [
                    //                             Text(
                    //                               names[index],
                    //                               style: const TextStyle(
                    //                                 fontFamily: 'Lateef',
                    //                                 fontSize: 22,
                    //                               ),
                    //                             ),
                    //                             const SizedBox(
                    //                               width: 10,
                    //                             ),
                    //                             Container(
                    //                               alignment: Alignment.topRight,
                    //                               child: Products(
                    //                                 image: images[index],
                    //                                 isSelected: isSelected,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 );
                    //               },
                    //             ),
                    //             // Container(
                    //             //   alignment: Alignment.topRight,
                    //             //   height: MediaQuery.of(context).size.height,
                    //             //   child: ListView.builder(
                    //             //     itemCount: 12,
                    //             //     itemBuilder:
                    //             //         (BuildContext context, int index) {
                    //             //       return ListTile(
                    //             //         title: Container(
                    //             //             alignment: Alignment.topRight,
                    //             //             child:
                    //             //                 Text('الخطوة ${index + 1}')),
                    //             //         subtitle: Container(
                    //             //           alignment: Alignment.topRight,
                    //             //           child: Text(
                    //             //             'اخفقي جميع المكونات في محضرة الطعام حتى تصبح ناعمة، بدءًا من ثلاث ملاعق كبيرة من الحليب.',
                    //             //           ),
                    //             //         ),
                    //             //       );
                    //             //     },
                    //             //   ),
                    //             // ),
                    //           ],
                    //         ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Products extends StatelessWidget {
  final bool isSelected;
  final String image;

  const Products({
    Key? key,
    required this.isSelected,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 5),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: isSelected
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/plus.png', // Replace with your SVG file path
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  )
                : Image.asset(
                    image,
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class Catagories extends StatefulWidget {
  final bool isSelected;

  const Catagories({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  _CatagoriesState createState() => _CatagoriesState();
}

class _CatagoriesState extends State<Catagories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        height: 50,
        width: 105,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          color: widget.isSelected ? const Color(0xFF5F6F52) : Colors.white,
          border: Border.all(
            color:
                widget.isSelected ? Colors.white : Colors.black, // Border color
            width: widget.isSelected ? 2.0 : 0.0, // Border width when selected
          ),
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
                child: Text(
                  'أضــف الـى الـسـلـة',
                  style: TextStyle(
                    color: widget.isSelected ? Colors.white : Colors.black,
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
