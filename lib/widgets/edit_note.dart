// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:note_app/model/notes_model.dart';
// import 'package:note_app/provider/notes_provider.dart';

// class EditNoteModal extends ConsumerStatefulWidget {
//   final NotesModel note;

//   const EditNoteModal({super.key, required this.note});

//   @override
//   ConsumerState<EditNoteModal> createState() => _EditNoteModalState();
// }

// class _EditNoteModalState extends ConsumerState<EditNoteModal> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleControler;
//   late TextEditingController _contentControler;
//   late Category selectedCategory;
//   late DateTime? pickedDate;

//   @override
//   void initState() {
//     super.initState();
//     _titleControler = TextEditingController(text: widget.note.title);
//     _contentControler = TextEditingController(text: widget.note.content);
//     selectedCategory = widget.note.category!;
//     pickedDate = widget.note.date;
//   }

//   @override
//   void dispose() {
//     _titleControler.dispose();
//     _contentControler.dispose();
//     super.dispose();
//   }

//   void _submitUpdatedNote() async {
//     if (_formKey.currentState!.validate()) {
//       final updatedNote = NotesModel(
//         id: widget.note.id, // Keep the same ID
//         title: _titleControler.text.trim(),
//         content: _contentControler.text.trim(),
//         category: selectedCategory,
//         date: pickedDate ?? DateTime.now(),
//       );

//       // Call the update method in the provider
//       await ref.read(notesProvider.notifier).updateNote(updatedNote);

//       // Close the modal and show confirmation
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Note updated successfully!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 32, 16, 16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text(
//               "Edit Note",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             Card(
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: _titleControler,
//                       decoration: const InputDecoration(
//                         label: Text("Title"),
//                         prefixIcon: Icon(Icons.title),
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.text,
//                       maxLength: 30,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a title';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _contentControler,
//                       decoration: const InputDecoration(
//                         label: Text("Content"),
//                         prefixIcon: Icon(Icons.description),
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.text,
//                       maxLength: 300,
//                       maxLines: 4,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter some content';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     pickedDate == null
//                         ? "No Date Selected"
//                         : DateFormat('yyyy-MM-dd').format(pickedDate!),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     final picked = await showDatePicker(
//                       context: context,
//                       initialDate: pickedDate ?? DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2101),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         pickedDate = picked;
//                       });
//                     }
//                   },
//                   icon: const Icon(Icons.date_range, color: Colors.blueAccent),
//                   tooltip: "Pick a Date",
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _submitUpdatedNote,
//               icon: const Icon(Icons.save),
//               label: const Text("Update Note"),
//             ),
//             const SizedBox(height: 12),
//             OutlinedButton.icon(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.cancel),
//               label: const Text("Cancel"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
