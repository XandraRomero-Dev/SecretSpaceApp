import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class LibraryScreen extends StatelessWidget {
  final List<DiaryEntry> entries;
  final Color primaryColor;
  final Function(int) onDelete;
  final Function(int) onOpen;
  final VoidCallback onAdd;
  final VoidCallback onBack;

  const LibraryScreen({
    super.key,
    required this.entries,
    required this.primaryColor,
    required this.onDelete,
    required this.onOpen,
    required this.onAdd,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      'assets/images/book_1.png',
      'assets/images/book_2.png',
      'assets/images/book_3.png',
      'assets/images/book_4.png',
      'assets/images/book_5.png',
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("No memories yet. Tap + to start!"))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
              ),
              itemCount: entries.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => onOpen(i),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(icons[i % icons.length], height: 110),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 18,
                            ),
                            onPressed: () => onDelete(i),
                          ),
                        ),
                      ],
                    ),
                    Text(entries[i].title, overflow: TextOverflow.ellipsis),
                    Text(entries[i].date, style: const TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: onAdd,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
