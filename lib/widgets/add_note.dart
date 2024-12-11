import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/notes_model.dart';
import 'package:note_app/provider/notes_provider.dart';

class AddNoteModal extends ConsumerStatefulWidget {
  const AddNoteModal({super.key});

  @override
  ConsumerState<AddNoteModal> createState() => _AddNoteModalState();
}

class _AddNoteModalState extends ConsumerState<AddNoteModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Category _selectedCategory = Category.work;
  DateTime? selectedDate ; // Initialize with today's date

  // Function to show the Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date to today's date
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final newNote = NotesModel(
        id:null ,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _selectedCategory,
        date: selectedDate, // Use the selected date here
      );
      try {
        // Add the note
        await ref.read(notesProvider.notifier).addNote(newNote);
        if(!context.mounted){
          return;
        }
        Navigator.of(context).pop(); // Close the modal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add note : $e')),
        );
        print("the error i have : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16
     
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Note',
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
                // Display the selected date
                
               
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  
                  children: [
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      onPressed: _saveNote,
                      child: const Text('Save Note'),
                    ),
                    const SizedBox(width: 5,),
                    OutlinedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text("Cancel"))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
