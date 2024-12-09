import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:note_app/model/notes_model.dart';
import 'dart:convert';



class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Future<List<NotesModel>> fetchNotes() async {
    final response = await http.get(Uri.parse('http://3.82.233.52:5050/notes'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((json) => NotesModel.fromjson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load notes");
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'No Date';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: FutureBuilder<List<NotesModel>>(
        future: fetchNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  leading: Icon(
                    categoryIcons[note.category],
                    color: Colors.blue,
                  ),
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: Text(formatDate(note.date)), // Display formatted date.
                );
              },
            );
          } else {
            return const Center(child: Text('No notes available.'));
          }
        },
      ),
    );
  }
}