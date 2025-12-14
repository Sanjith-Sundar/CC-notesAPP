import 'package:hive/hive.dart';
import '../models/note.dart';

class LocalStorageService {
  static const String _notesBoxName = 'notes';

  Future<Box<Note>> _openNotesBox() async {
    return await Hive.openBox<Note>(_notesBoxName);
  }

  Future<void> saveNote(Note note) async {
    final box = await _openNotesBox();
    await box.put(note.id, note);
  }

  Future<void> deleteNote(String noteId) async {
    final box = await _openNotesBox();
    await box.delete(noteId);
  }

  Future<List<Note>> getAllNotes() async {
    final box = await _openNotesBox();
    return box.values.toList();
  }

  Future<void> clearAllNotes() async {
    final box = await _openNotesBox();
    await box.clear();
  }
}
