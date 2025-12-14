import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
import '../services/sync_service.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final LocalStorageService _localStorageService = LocalStorageService();
  final SyncService _syncService = SyncService();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _syncService.syncNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _localStorageService.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _deleteNote(String noteId) async {
    await _localStorageService.deleteNote(noteId);
    await _syncService.deleteRemoteNote(noteId);
    _loadNotes();
  }

  void _navigateAndRefresh(BuildContext context, {Note? note}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditScreen(note: note)),
    );
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _navigateAndRefresh(context, note: note),
                    onLongPress: () => _deleteNote(note.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
