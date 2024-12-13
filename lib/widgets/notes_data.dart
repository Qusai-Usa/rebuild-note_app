import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/notes_model.dart';
import 'package:intl/intl.dart';
import 'package:note_app/provider/notes_provider.dart';
import 'package:note_app/widgets/edit_note.dart';

class NotesListTile extends ConsumerWidget {
  final NotesModel note;

  const NotesListTile({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          ListTile(
           leading: Icon(categoryIcons[note.category]),
              title: Text(note.title),
              subtitle: Text(note.content),
              trailing: Text(formatDate(note.date))),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  try {
                    // Call the delete method when the delete button is pressed
                    await ref.read(notesProvider.notifier).deleteNote(note.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Note deleted successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete note: $e')),
                    );
                  }
                },
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await showModalBottomSheet<bool>(
                    isScrollControlled: true,
                    context: context,
                    useSafeArea: true,
                    builder: (_) => UpdateNoteModal(note: note),
                  );

                  // Check the result and refresh UI or display a message
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Note updated successfully!')),
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

String formatDate(DateTime? date) {
  if (date == null) return 'No Date';
  return DateFormat('yyyy-MM-dd').format(date);
}
