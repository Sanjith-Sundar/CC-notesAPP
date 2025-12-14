import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';
import '../services/sync_service.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  const NoteEditScreen({super.key, this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late Note _note;

  final LocalStorageService _localStorageService = LocalStorageService();
  final SyncService _syncService = SyncService();

  @override
  void initState() {
    super.initState();
    _note = widget.note ?? Note(title: '', content: '');
    _title = _note.title;
    _content = _note.content;
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _note.title = _title;
      _note.content = _content;
      _note.updatedAt = DateTime.now();

      await _localStorageService.saveNote(_note);
      await _syncService.syncNotes();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _content,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  onSaved: (value) => _content = value!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
