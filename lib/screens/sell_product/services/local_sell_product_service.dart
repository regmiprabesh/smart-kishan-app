import 'package:smart_kishan/models/buyersgroup.dart';
import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/repositories/repository.dart';

class LocalBuyersGroupService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //create farmland
  saveBuyersGroup(BuyersGroup buyersGroup) async {
    return await _repository.insertData('buyersgroups', buyersGroup.toJson());
  }

  //read farmland
  readBuyersGroups() async {
    return await _repository.readData('buyersgroups');
  }

  //read farmland by id
  readBuyersGroupById(buyersGroupId) async {
    return await _repository.readDataById('buyersgroups', buyersGroupId);
  }

  //read farmland by id
  updateBuyersGroup(BuyersGroup buyersGroup) async {
    return await _repository.updateData('buyersgroups', buyersGroup.toJson());
  }

  //delete farmland
  deleteBuyersGroup(buyersGroupId) async {
    return await _repository.deleteData('buyersgroups', buyersGroupId);
  }
}
