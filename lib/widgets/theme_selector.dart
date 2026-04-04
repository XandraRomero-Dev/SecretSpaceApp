import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class ThemeSelector extends StatelessWidget {
  final Color currentBg;
  final Color? selPrimary;
  final Color? selBg;
  final Color? selText;
  final Function(Color) onSelectPrimary;
  final Function(Color) onSelectBg;
  final Function(Color) onSelectText;
  final VoidCallback onSave;
  final VoidCallback onReset;

  const ThemeSelector({
    super.key,
    required this.currentBg,
    required this.selPrimary,
    required this.selBg,
    required this.selText,
    required this.onSelectPrimary,
    required this.onSelectBg,
    required this.onSelectText,
    required this.onSave,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: currentBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Personalize Your View",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          _buildRow("Primary", selPrimary, onSelectPrimary),
          _buildRow("Background", selBg, onSelectBg),
          _buildRow("Text", selText, onSelectText),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF15489B),
            ),
            onPressed: onSave,
            child: const Text(
              "Save My Theme",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text(
              "Reset to Default",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, Color? selected, Function(Color) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Wrap(
          spacing: 8,
          children: AppConstants.palette
              .map(
                (c) => GestureDetector(
                  onTap: () => onSelect(c),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: c,
                    child: selected == c
                        ? const Icon(Icons.check, size: 16, color: Colors.blue)
                        : null,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
