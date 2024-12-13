import 'package:flutter/material.dart';

/// Enum for note categories
enum Category { sport, work, study, routine }

/// Mapping of categories to their corresponding icons
const categoryIcons = {
  Category.sport: Icons.sports_baseball,
  Category.work: Icons.work,
  Category.study: Icons.school,
  Category.routine: Icons.refresh,
};

/// NotesModel class
class NotesModel {
  /// Unique identifier for the note
  String? id;

  /// Title of the note
  final String title;

  /// Content of the note
  final String content;

  /// Date associated with the note
  final DateTime? date;

  /// Category of the note
  final Category? category;

  /// Constructor
  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    this.date,
    this.category,
  });

  /// Factory constructor for creating a `NotesModel` instance from JSON
  factory NotesModel.fromjson(Map<String, dynamic> json) {
    return NotesModel(
      id: json['_id'] as String?, // Map MongoDB `_id` to `id`
      title: json['title'] as String? ?? 'No Title', // Default if null
      content: json['content'] as String? ?? 'No Content', // Default if null
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) // Safely parse the date
          : null,
      category: json['category'] != null
          ? _stringToCategory(json['category'] as String)
          : null, // Handle null category
    );
  }

  /// Method to convert a `NotesModel` instance to JSON
  Map<String, dynamic> toJson() {
  final data = {

  'title': title,
  'content': content,
  'category': category?.toString().split('.').last,
  'date': date?.toIso8601String(),
};
  print('toJson Output: $data');
  return data;
}

  /// Helper method to convert a string to a `Category` enum
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
