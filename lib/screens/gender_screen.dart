import 'package:flutter/material.dart';

class GenderScreen extends StatelessWidget {
  final Color bgColor;
  final Function(bool) onPick;

  const GenderScreen({super.key, required this.bgColor, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "SecretSpace",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5E3C),
            ),
          ),
          const Text(
            "Pick whether you're a...",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 40),
          _btn('assets/images/boy.png', const Color(0xFFD1E3FF), true),
          const SizedBox(height: 20),
          _btn('assets/images/girl_transp.png', const Color(0xFFFFD1D1), false),
        ],
      ),
    );
  }

  Widget _btn(String asset, Color col, bool male) {
    return GestureDetector(
      onTap: () => onPick(male),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(asset, height: 120),
      ),
    );
  }
}
