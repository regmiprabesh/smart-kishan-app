import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/repositories/repository.dart';

class LocalActivityService {
  late Repository _repository;

  Future<void> init() async {
    _repository = Repository();
  }

  //create activity
  saveActivity(Activity activity) async {
    return await _repository.insertData('daily_activity', activity.toJson());
  }

  //read activity
  readActivities() async {
    return await _repository.readData('daily_activity');
  }

  //read activity by id
  readActivityById(activityId) async {
    return await _repository.readDataById('daily_activity', activityId);
  }

  //read activity by id
  updateActivity(Activity activity) async {
    return await _repository.updateData('daily_activity', activity.toJson());
  }

  //delete activity
  deleteActivity(activityId) async {
    return await _repository.deleteData('daily_activity', activityId);
  }
}
