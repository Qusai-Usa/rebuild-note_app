import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:note_app/provider/notes_provider.dart';
import 'package:note_app/widgets/add_note.dart';
import 'package:note_app/widgets/notes_data.dart';


class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    void showModal() async{
      await showModalBottomSheet(
            useSafeArea: true,
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const AddNoteModal(),
          );
          // Refresh the notes list after closing the modal
          ref.read(notesProvider.notifier).fetchNotes();
    }
    
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
         IconButton(onPressed: showModal, icon: const Icon(Icons.add))
        ],
      ),
    
      body: ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return NotesListTile(note: note);
      },
    )
    );
  }
}