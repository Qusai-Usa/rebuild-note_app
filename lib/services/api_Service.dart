import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:note_app/model/notes_model.dart';

class ApiService {
  static const String _baseUrl = 'http://3.82.233.52:5050/notes';
  //fetch notes
  Future<List<NotesModel>> fetchNotes() async {
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
  // add note
  Future<void> addNote(NotesModel note) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        note.toJson(),
      ),
    );
    if(response.statusCode != 200){
      throw Exception("Failed load data");
    }
  }

 Future<void> delete(String endpoint) async {
  final response = await http.delete(Uri.parse('http://3.82.233.52:5050/notes/$endpoint'));

  if (response.statusCode != 200) {
    throw Exception('Failed to delete note');
  }
}


}
