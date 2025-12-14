import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';
import 'local_storage_service.dart';

class SyncService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> syncNotes() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return;

    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final localNotes = await _localStorageService.getAllNotes();
    final remoteNotes = await _getRemoteNotes(user.uid);

    // Sync local to remote
    for (final localNote in localNotes) {
      final remoteNote = remoteNotes.firstWhere((note) => note.id == localNote.id, orElse: () => localNote);
      if (localNote.updatedAt.isAfter(remoteNote.updatedAt)) {
        await _setRemoteNote(user.uid, localNote);
      }
    }

    // Sync remote to local
    for (final remoteNote in remoteNotes) {
      final localNote = localNotes.firstWhere((note) => note.id == remoteNote.id, orElse: () => remoteNote);
      if (remoteNote.updatedAt.isAfter(localNote.updatedAt)) {
        await _localStorageService.saveNote(remoteNote);
      }
    }
  }

  Future<List<Note>> _getRemoteNotes(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).collection('notes').get();
    return snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
  }

  Future<void> _setRemoteNote(String uid, Note note) async {
    await _firestore.collection('users').doc(uid).collection('notes').doc(note.id).set(note.toJson());
  }

  Future<void> deleteRemoteNote(String noteId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).collection('notes').doc(noteId).delete();
  }
}
