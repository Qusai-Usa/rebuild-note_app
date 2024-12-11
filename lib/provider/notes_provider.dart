import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/model/notes_model.dart';
import 'package:note_app/services/api_service.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<NotesModel>>(
  (ref) => NotesNotifier(ApiService()),
);

class NotesNotifier extends StateNotifier<List<NotesModel>> {
  final ApiService _apiService;

  NotesNotifier(this._apiService) : super([]) {
    fetchNotes(); // Fetch notes when the provider is initialized
  }

  // Fetch notes from the API
  Future<void> fetchNotes() async {
    try {
      final notes = await _apiService.fetchNotes();
      state = notes; // Directly set the state with the fetched notes
    } catch (e) {
      print('Failed to fetch notes: $e');
      // Optionally, you could handle errors here, like setting an empty list on failure
    }
  }

  // Add a new note
  Future<void> addNote(NotesModel newNote) async {
    try {
      await _apiService.addNote(newNote);
      fetchNotes(); // Refresh the notes list after adding
    } catch (e) {
      print('Failed to add note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await _apiService.delete(noteId); // Delete the note from the server
      // Remove the note from the local state after successful deletion
      state = state.where((note) => note.id != noteId).toList();
    } catch (e) {
      print('Failed to delete note: $e');
      throw Exception('Failed to delete note');
    }
  }
}
