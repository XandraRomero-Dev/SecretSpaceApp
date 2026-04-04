import 'dart:convert';

class DiaryEntry {
  final String title;
  final String content;
  final String date;
  final int happy;
  final int sad;
  final int anxious;
  final int angry;
  final int? displayIndex;

  DiaryEntry({
    required this.title,
    required this.content,
    required this.date,
    required this.happy,
    required this.sad,
    required this.anxious,
    required this.angry,
    this.displayIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'happy': happy,
      'sad': sad,
      'anxious': anxious,
      'angry': angry,
      'displayIndex': displayIndex,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      happy: map['happy'] ?? 0,
      sad: map['sad'] ?? 0,
      anxious: map['anxious'] ?? 0,
      angry: map['angry'] ?? 0,
      displayIndex: map['displayIndex'],
    );
  }

  String toJson() => json.encode(toMap());
  factory DiaryEntry.fromJson(String source) =>
      DiaryEntry.fromMap(json.decode(source));
}
