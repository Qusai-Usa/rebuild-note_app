import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/notes_model.dart';
import 'package:note_app/provider/notes_provider.dart';

class UpdateNoteModal extends ConsumerStatefulWidget {
  final NotesModel note;

  const UpdateNoteModal({super.key, required this.note});

  @override
  ConsumerState<UpdateNoteModal> createState() => _UpdateNoteModalState();
}

class _UpdateNoteModalState extends ConsumerState<UpdateNoteModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Category _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedCategory = widget.note.category ?? Category.work;
    _selectedDate = widget.note.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateNote() async {
  if (_formKey.currentState!.validate()) {
    final updatedNote = NotesModel(
      id: widget.note.id, // Keep the same ID
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
      date: _selectedDate,
    );

    try {
      // Call the provider's updateNote method
      await ref.read(notesProvider.notifier).updateNote(updatedNote);

      // Pop the modal screen
      if (!context.mounted) return; // Safety check
      Navigator.of(context).pop(true); // Pass true to indicate success

      // Show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully!')),
      );
    } catch (e) {
      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update note: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Note',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: Category.values
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateNote,
              child: const Text('Update Note'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
