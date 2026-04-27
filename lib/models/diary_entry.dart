import 'dart:convert';

class DiaryEntry {
  final String? id;
  final String title;
  final String content;
  final String date;
  final int happy;
  final int sad;
  final int anxious;
  final int angry;
  final int? displayIndex;

  DiaryEntry({
    this.id,
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

  factory DiaryEntry.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return DiaryEntry(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      happy: (map['happy'] as num?)?.toInt() ?? 0,
      sad: (map['sad'] as num?)?.toInt() ?? 0,
      anxious: (map['anxious'] as num?)?.toInt() ?? 0,
      angry: (map['angry'] as num?)?.toInt() ?? 0,
      displayIndex: (map['displayIndex'] as num?)?.toInt(),
    );
  }

  factory DiaryEntry.fromDbMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'] as String?,
      title: map['Title'] ?? '',
      content: map['Content'] ?? '',
      date: map['Date'] ?? '',
      happy: map['Happy'] ?? 0,
      sad: map['Sad'] ?? 0,
      anxious: map['Anxious'] ?? 0,
      angry: map['Angry'] ?? 0,
      displayIndex: map['DisplayIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiaryEntry.fromJson(String source, {String? documentId}) =>
      DiaryEntry.fromMap(json.decode(source), documentId: documentId);
}
