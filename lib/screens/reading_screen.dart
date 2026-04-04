import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class ReadingScreen extends StatelessWidget {
  final DiaryEntry? entry;
  final Color bgColor;
  final VoidCallback onBack;

  const ReadingScreen({
    super.key,
    required this.entry,
    required this.bgColor,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const Scaffold(body: Center(child: Text("No entry")));
    }
    final List<String> icons = [
      'assets/images/book_1.png',
      'assets/images/book_2.png',
      'assets/images/book_3.png',
      'assets/images/book_4.png',
      'assets/images/book_5.png',
    ];
    String book = icons[(entry!.displayIndex ?? 0) % icons.length];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          Center(child: Image.asset(book, height: 70)),
          Text(entry!.date, style: const TextStyle(color: Colors.grey)),
          Text(
            entry!.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text(entry!.content, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("😊 ${entry!.happy}"),
              Text("😢 ${entry!.sad}"),
              Text("😟 ${entry!.anxious}"),
              Text("😡 ${entry!.angry}"),
            ],
          ),
        ],
      ),
    );
  }
}
