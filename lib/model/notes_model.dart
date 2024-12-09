

import 'package:flutter/material.dart';




enum Category { sport, work, study, routine }

const categoryIcons = {
  Category.sport: Icons.sports_baseball,
  Category.work: Icons.work,
  Category.study: Icons.school,
  Category.routine: Icons.refresh,
};
class NotesModel {
  final String id;
  final String title;
  final String content;
  final DateTime? date; // Make date nullable if necessary.
  final Category? category; // Make category nullable if necessary.

  const NotesModel({
    required this.id,
    required this.title,
    required this.content,
    this.date,
    this.category,
  });

  factory NotesModel.fromjson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['id'] as String? ?? 'Unknown', // Provide a default value if null.
      title: json['title'] as String? ?? 'No Title', // Provide a default value if null.
      content: json['content'] as String? ?? 'No Content', // Provide a default value if null.
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) // Safely parse the date.
          : null,
      category: json['category'] != null
          ? _stringToCategory(json['category'] as String)
          : null, // Handle null category.
    );
  }

  static Category _stringToCategory(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Category.work;
      case 'routine':
        return Category.routine;
      case 'study':
        return Category.study;
      case 'sport':
        return Category.sport;
      default:
        throw FormatException('Invalid category: $category');
    }
  }
}
