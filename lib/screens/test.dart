import 'package:flutter/material.dart';

class RecomendBestCard extends StatelessWidget {
  const RecomendBestCard({
    Key? key,
    required this.image,
    required this.title1,
    required this.title2,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title1, title2;
  final int price;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 3, bottom: 12),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Add border radius here
            child: Image.asset(image),
          ),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: Colors.black.withOpacity(0.13),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    '\$$price',
                    style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.green) ??
                        const TextStyle(color: Colors.green),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$title1\n".toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        TextSpan(
                          text: title2.toUpperCase(),
                          style: TextStyle(
                            color: Colors.green.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
