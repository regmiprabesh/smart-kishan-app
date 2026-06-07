import 'package:smart_kishan/models/sync.dart';
import 'package:smart_kishan/repositories/repository.dart';

class SyncService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //read sync table
  getSyncDataASC() async {
    return await _repository.readDataASC('sync');
  }

  //create sync
  addSyncData(Sync sync) async {
    return await _repository.insertData('sync', sync.toJson());
  }

  //remove sync
  removeSyncData(int id) async {
    return await _repository.deleteData('sync', id);
  }
}
