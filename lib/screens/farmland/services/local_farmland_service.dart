import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/repositories/repository.dart';

class LocalFarmlandService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //create farmland
  saveFarmland(Farmland farmland) async {
    return await _repository.insertData('farmlands', farmland.toJson());
  }

  //read farmland
  readFarmlands() async {
    return await _repository.readData('farmlands');
  }

  //read farmland by id
  readFarmlandById(farmlandId) async {
    return await _repository.readDataById('farmlands', farmlandId);
  }

  //read farmland by id
  updateFarmland(Farmland farmland) async {
    return await _repository.updateData('farmlands', farmland.toJson());
  }

  //delete farmland
  deleteFarmland(farmlandId) async {
    return await _repository.deleteData('farmlands', farmlandId);
  }
}
