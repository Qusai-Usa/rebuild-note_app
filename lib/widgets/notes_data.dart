import 'package:flutter/material.dart';
import 'package:note_app/model/notes_model.dart';
import 'package:intl/intl.dart';

class NotesListTile extends StatelessWidget {
  final NotesModel note;

  const NotesListTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
         categoryIcons[note.category],
        color: Colors.blue,
      ),
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: Text(formatDate(note.date)),
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return 'No Date';
  return DateFormat('yyyy-MM-dd').format(date);}
