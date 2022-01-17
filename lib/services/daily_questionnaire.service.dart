import 'package:hive/hive.dart';
import 'package:varenya_mobile/constants/hive_boxes.constant.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';

class DailyQuestionnaireService {
  final Box<List<dynamic>> _progressBox = Hive.box(VARENYA_PROGESS_BOX);

  void saveData(DailyProgressData dailyProgressData) {
    List<DailyProgressData> existingData = this.fetchDailyProgressData();

    existingData.add(dailyProgressData);

    existingData.sort((prevData, nextData) =>
        nextData.createdAt.compareTo(prevData.createdAt));

    this._progressBox.put(VARENYA_PROGESS_LIST, existingData);
  }

  List<DailyProgressData> fetchDailyProgressData() {
    return this
        ._progressBox
        .get(VARENYA_PROGESS_LIST, defaultValue: [])!.cast<DailyProgressData>();
  }
}
