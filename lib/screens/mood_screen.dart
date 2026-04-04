import 'package:flutter/material.dart';
import 'dart:math' as math;

class MoodScreen extends StatelessWidget {
  final int h, s, anx, ang;
  final Function(int, int, int, int) onUpdate;
  final VoidCallback onDone;
  final VoidCallback onSummary;

  const MoodScreen({
    super.key,
    required this.h,
    required this.s,
    required this.anx,
    required this.ang,
    required this.onUpdate,
    required this.onDone,
    required this.onSummary,
  });

  @override
  Widget build(BuildContext context) {
    int total = h + s + anx + ang;
    final Color textColor = Colors.brown[900]!;
    final TextStyle legendStyle = TextStyle(color: textColor, fontSize: 16);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.check, color: textColor, size: 28),
          onPressed: onDone,
        ),
        title: Text(
          "Mood Tracker",
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF3EFE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onSummary,
              icon: Icon(Icons.analytics_outlined, color: textColor),
              label: Text(
                "Summary",
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            "What's your mood?",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter: MoodPiePainter(
                    happy: h,
                    sad: s,
                    anxious: anx,
                    angry: ang,
                  ),
                  child: Center(
                    child: Text(
                      "$total/40",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Legend:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _legendItem(Colors.yellow, "Happy", legendStyle),
                  _legendItem(Colors.blue, "Sad", legendStyle),
                  _legendItem(Colors.orange, "Anxious", legendStyle),
                  _legendItem(Colors.red, "Angry", legendStyle),
                ],
              ),
            ],
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _btn("😊", h, (v) => onUpdate(v, s, anx, ang)),
              _btn("😢", s, (v) => onUpdate(h, v, anx, ang)),
              _btn("😟", anx, (v) => onUpdate(h, s, v, ang)),
              _btn("😡", ang, (v) => onUpdate(h, s, anx, v)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color col, String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: col,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: style),
        ],
      ),
    );
  }

  Widget _btn(String emoji, int count, Function(int) updateFn) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => updateFn(math.min(10, count + 1)),
          child: Text(emoji, style: const TextStyle(fontSize: 50)),
        ),
        const SizedBox(height: 8),
        Text("$count/10", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class MoodPiePainter extends CustomPainter {
  final int happy, sad, anxious, angry;
  MoodPiePainter({
    required this.happy,
    required this.sad,
    required this.anxious,
    required this.angry,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total = (happy + sad + anxious + angry).toDouble();
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    Paint bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, bgPaint);

    if (total == 0) return;
    double startAngle = -math.pi / 2;

    final segments = [
      {'val': happy, 'col': Colors.yellow.shade600},
      {'val': sad, 'col': Colors.blue.shade400},
      {'val': anxious, 'col': Colors.orange.shade400},
      {'val': angry, 'col': Colors.red.shade400},
    ];

    Paint paint = Paint()..style = PaintingStyle.fill;

    for (var seg in segments) {
      if ((seg['val'] as int) == 0) continue;
      double sweepAngle = (seg['val'] as int) / total * 2 * math.pi;
      paint.color = seg['col'] as Color;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
