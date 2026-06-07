import 'dart:async';

import 'package:get/get.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/note_controller.dart';
import 'package:smart_kishan/models/note.dart';
import 'package:smart_kishan/models/sync.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/sync_service.dart';

class SyncController extends GetxController {
  static SyncController instance = Get.find();

  // RxList<Note> notes = List<Note>.empty(growable: true).obs;

  final _syncService = SyncService();
  final LocalAuthService _localAuthService = LocalAuthService();
  @override
  void onInit() async {
    super.onInit();
    await _syncService.init();
    await _localAuthService.init();

    // syncWithServer(true);
  }

  Future<void> syncWithServer(bool isConnected) async {
    // Check for internet connectivity
    if (isConnected) {
      // Get all records from the sync table
      final List<Map<String, dynamic>> records =
          await _syncService.getSyncDataASC();
      for (var record in records) {
        // Send the corresponding HTTP request based on the change_type
        print(record);
        switch (record['object_type']) {
          case 'Note':
            noteSync(record);
            break;
          case 'update':
            // await updateNoteOnline(Note.fromJson(record));
            break;
          case 'delete':
            // await deleteNoteOnline(record['note_id']);
            break;
        }

        // If the HTTP request was successful, delete the record from the sync table
        // await db.delete('sync', where: 'id = ?', whereArgs: [record['id']]);
      }
    }
  }

  void noteSync(Map<String, dynamic> record) async {
    switch (record['change_type']) {
      case 'create':
        Timer(const Duration(seconds: 1), () async {
          Note note = noteController.offlineNotes.firstWhere(
              (element) => element.id == record['object_id'],
              orElse: () => Note());
          bool inserted = await noteController.addNote(note, true);
          inserted
              ? _syncService.removeSyncData(record['object_id'])
              : print('no Object');
        });

        // await createNoteOnline(Note.fromJson(record));
        break;
      case 'update':
        // await updateNoteOnline(Note.fromJson(record));
        break;
      case 'delete':
        // await deleteNoteOnline(record['note_id']);
        break;
    }
  }
  // addSyncData(Sync sync) async {
  //   try {
  //     var result = await _syncService.(note);
  //     if (result > 0) {
  //       Get.back();
  //       await getNotesOffline();
  //       ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
  //           backgroundColor: kSuccessColor,
  //           content: Text(
  //             'नोट सफलतापूर्वक थपियो!',
  //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  //           )));
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {}
  // }
}
