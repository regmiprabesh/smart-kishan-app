import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/models/note.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/notes/services/remote_note_service.dart';

class NoteController extends GetxController {
  static NoteController get instance => Get.find();

  final RxList<Note> notes = <Note>[].obs;
  final RxBool isEdit = false.obs;
  final Rx<Note> selectedNote = Note().obs;
  final RxBool isNotesLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getNotes();
  }

  void getNotes() async {
    try {
      isNotesLoading(true);
      final token = await _localAuthService.getToken();
      final result = await RemoteNoteService().getNotes(token: token!);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        notes.assignAll(noteListFromJson(jsonEncode(body['data'])));
        sortNote();
      }
    } catch (e) {
      debugPrint('getNotes error: $e');
    } finally {
      isNotesLoading(false);
    }
  }

  Future<bool> addNote(Note note) async {
    try {
      isNotesLoading(true);
      final token = await _localAuthService.getToken();
      final result =
          await RemoteNoteService().addNote(token: token!, data: note.toJson());
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        notes.add(Note.fromJson(body['data']));
        sortNote();
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('addNote error: $e');
    } finally {
      isNotesLoading(false);
    }
    return false;
  }

  void updateNote(Note note) async {
    try {
      isNotesLoading(true);
      final token = await _localAuthService.getToken();
      final result = await RemoteNoteService()
          .updateNote(token: token!, data: note.toJson(), id: note.id!);
      if (result.statusCode == 200) {
        final updatedNote = Note.fromJson(jsonDecode(result.body)['data']);
        final i = notes.indexWhere((e) => e.id == note.id);
        if (i != -1) notes[i] = updatedNote;
        sortNote();
        Get.back();
      }
    } catch (e) {
      debugPrint('updateNote error: $e');
    } finally {
      isNotesLoading(false);
    }
  }

  void deleteNote(int id) async {
    try {
      isNotesLoading(true);
      final token = await _localAuthService.getToken();
      final result =
          await RemoteNoteService().deleteNote(token: token!, id: id);
      if (result.statusCode == 200) {
        notes.removeWhere((e) => e.id == id);
        sortNote();
        Get.back();
      }
    } catch (e) {
      debugPrint('deleteNote error: $e');
    } finally {
      isNotesLoading(false);
    }
  }

  void sortNote() {
    notes.sort((a, b) {
      if (a.priority == null && b.priority == null) return 0;
      if (a.priority == null) return 1;
      if (b.priority == null) return -1;
      return a.priority!.compareTo(b.priority!);
    });
  }
}
