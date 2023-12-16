import 'package:flutter/material.dart';

class ButtonScreen extends StatelessWidget {
  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // Add your action for the first button
                  },
                  backgroundColor: Colors.blue,
                  heroTag: null,
                  child: const Icon(Icons.all_inclusive_outlined),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Add your action for the second button
                  },
                  backgroundColor: Colors.green,
                  heroTag: null,
                  child: const Icon(Icons.coffee_outlined),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Add your action for the third button
                  },
                  backgroundColor: Colors.red,
                  heroTag: null,
                  child: const Icon(Icons.food_bank_outlined),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Add your action for the fourth button
                  }, // Updated asset path
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  heroTag: null,
                  child: Image.asset(
                      'assets/Backgrounds/spices.png'),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Add your action for the fifth button
                  },
                  backgroundColor: Colors.pink,
                  heroTag: null,
                  child: const Icon(Icons.favorite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
