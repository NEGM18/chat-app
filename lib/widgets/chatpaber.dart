import 'package:flutter/material.dart';

class Chatpaber extends StatelessWidget {
  const Chatpaber({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/WhatsApp Image 2024-12-01 at 14.49.45_1f65fb69.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
