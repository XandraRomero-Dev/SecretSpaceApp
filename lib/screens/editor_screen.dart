import 'package:flutter/material.dart';

class EditorScreen extends StatelessWidget {
  final bool isMale;
  final Color primaryColor;
  final Color bgColor;
  final VoidCallback onDiary;
  final VoidCallback onMoods;
  final VoidCallback onBack;

  const EditorScreen({
    super.key,
    required this.isMale,
    required this.primaryColor,
    required this.bgColor,
    required this.onDiary,
    required this.onMoods,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          onPressed: onBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: primaryColor, width: 2.5),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _icon('assets/images/book_1.png', "Diary", onDiary),
                  _icon(
                    isMale
                        ? 'assets/images/smiley_boy.png'
                        : 'assets/images/smiley_girl.png',
                    "Moods",
                    onMoods,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 45),
            Image.asset(
              isMale ? 'assets/images/star.png' : 'assets/images/ribbon.png',
              height: 60,
            ),
            const Text(
              "pick something you'd like!",
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(String path, String label, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: bgColor.withOpacity(0.5),
            child: Image.asset(path, height: 35),
          ),
          Text(
            label,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
