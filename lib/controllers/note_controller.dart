import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/note.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/notes/services/local_note_service.dart';
import 'package:smart_kishan/screens/notes/services/remote_note_service.dart';
import 'package:smart_kishan/sync_service.dart';

class NoteController extends GetxController {
  static NoteController instance = Get.find();

  RxList<Note> notes = List<Note>.empty(growable: true).obs;

  RxList<Note> offlineNotes = List<Note>.empty(growable: true).obs;

  final _localNoteService = LocalNoteService();

  RxBool isEdit = false.obs;

  Rx<Note> selectedNote = Note().obs;

  RxBool isNotesLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();
  final SyncService _syncService = SyncService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    await _localNoteService.init();
    await _syncService.init();
    getNotes();
    // getNotesOffline();
  }

  Comparator<Note> sortById = (a, b) => b.id!.compareTo(a.id!);

  void getNotes() async {
    try {
      isNotesLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteNoteService().getNotes(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        notes.assignAll(noteListFromJson(jsonEncode(body['data'])));
        sortNote();
        sortNote();
        // var data = await _localNoteService.readNotes();
        // offlineNotes.assignAll(noteListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      // print(e);
      print('No Internet Connection');
      // getNotesOffline();
    } finally {
      isNotesLoading(false);
    }
  }

  getNotesOffline() async {
    try {
      var data = await _localNoteService.readNotes();
      notes.assignAll(noteListFromJson(jsonEncode(data)));
      offlineNotes.assignAll(noteListFromJson(jsonEncode(data)));
      // You can sort the list by id like this
      notes.sort(sortById);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<bool> addNote(Note note, bool isSync) async {
    try {
      isNotesLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteNoteService().addNote(token: token!, data: note.toJson());
      print(result.body);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        var newNote = Note.fromJson(body['data']);
        notes.add(newNote);
        sortNote();
        Get.back();
      }
    } catch (e) {
      // if (isSync) {
      //   return false;
      // }
      // int? noteId = await addNoteOffline(note);
      // Sync data =
      //     Sync(objectID: noteId!, objectType: 'Note', changeType: 'create');
      // _syncService.addSyncData(data);
      // return false;
    } finally {
      isNotesLoading(false);
    }
    return false;
  }

  Future<int?>? addNoteOffline(Note note) async {
    try {
      var result = await _localNoteService.saveNote(note);
      // print(result);
      if (result > 0) {
        Get.back();
        await getNotesOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक थपियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
        return result;
      }
    } catch (e) {
      print(e);
    } finally {}
    return null;
  }

  void updateNote(Note note) async {
    try {
      isNotesLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteNoteService()
          .updateNote(token: token!, data: note.toJson(), id: note.id!);
      if (result.statusCode == 200) {
        Note updatedNote = Note.fromJson(jsonDecode(result.body)['data']);
        notes[notes.indexWhere((element) => element.id == note.id)] =
            updatedNote;
        sortNote();
        // updateNoteOffline(note);
        Get.back();
      }
    } catch (e) {
      // updateNoteOffline(note);
    } finally {
      isNotesLoading(false);
    }
  }

  updateNoteOffline(Note note, [bool? isSync]) async {
    try {
      var result = await _localNoteService.updateNote(note);
      if (result > 0) {
        Get.back();
        await getNotesOffline();
        if (isSync != null && isSync) {
          return;
        }
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक अद्यावधिक गरियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void deleteNote(int id) async {
    try {
      isNotesLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteNoteService().deleteNote(token: token!, id: id);
      if (result.statusCode == 200) {
        notes.removeWhere((element) => element.id == id);
        sortNote();
        // deleteNoteOffline(id);
        Get.back();
      }
    } catch (e) {
      // deleteNoteOffline(id);
    } finally {
      isNotesLoading(false);
    }
  }

  deleteNoteOffline(int id) async {
    try {
      var result = await _localNoteService.deleteNote(id);
      if (result > 0) {
        Get.back();
        getNotesOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक मेटाइयो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
    } finally {}
  }

  void sortNote() {
    notes.sort((a, b) {
      // Treat null priority as the lowest priority
      if (a.priority == null && b.priority == null) {
        return 0;
      } else if (a.priority == null) {
        return 1; // Null priorities go last
      } else if (b.priority == null) {
        return -1; // Null priorities go last
      } else {
        return a.priority!.compareTo(b.priority!);
      }
    });
  }

  void reset() {
    notes.clear();
    offlineNotes.clear();
    isEdit(false);
    selectedNote(null);
    isNotesLoading(false);
  }
}
