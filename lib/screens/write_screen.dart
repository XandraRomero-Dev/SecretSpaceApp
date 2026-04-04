import 'package:flutter/material.dart';

class WriteScreen extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController contentCtrl;
  final Color primaryColor;
  final Color bgColor;
  final VoidCallback onBack;
  final VoidCallback onMood;
  final VoidCallback onSave;

  const WriteScreen({
    super.key,
    required this.titleCtrl,
    required this.contentCtrl,
    required this.primaryColor,
    required this.bgColor,
    required this.onBack,
    required this.onMood,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor.withOpacity(0.4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: const Text(
          "Write Memory",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.face, color: Colors.white),
            onPressed: onMood,
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: onSave,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                hintText: "Title...",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Write your story...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
