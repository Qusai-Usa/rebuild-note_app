import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:note_app/model/notes_model.dart';

class ApiFetchData {
  static const String _baseUrl = 'http://3.82.233.52:5050/notes';

  static Future<List<NotesModel>> fetchNotes() async {
      final url = Uri.parse(_baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => NotesModel.fromjson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("failed to load the data.");
    }
  }
}
