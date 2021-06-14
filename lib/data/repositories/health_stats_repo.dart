import 'package:karetaker/data/models/bloodpressure.dart';
import 'package:karetaker/data/models/heartrate.dart';
import 'package:karetaker/data/models/sugar.dart';
import 'package:karetaker/data/provider/health_stats_api.dart';

class HealthStatsRepo {
  final HealthStatsApi _healthStatsApi = HealthStatsApi();

  fetchLatestSugarStats({required emailAddress}) async {
    var sugarResponse =
        await _healthStatsApi.fetchLatestSugarRate(emailAddress: emailAddress);

    Sugar sugarReading = Sugar.fromRawJson(sugarResponse.body);

    return sugarReading;
  }

  fetchLatestHeartStats({required emailAddress}) async {
    var heartResponse =
        await _healthStatsApi.fetchLatestHeartRate(emailAddress: emailAddress);

    HeartRate heartReading = HeartRate.fromRawJson(heartResponse.body);

    return heartReading;
  }

  fetchLatestBloodPressureStats({required emailAddress}) async {
    var bloodResponse =
        await _healthStatsApi.fetchLatestBloodRate(emailAddress: emailAddress);

    BloodPressure bloodPressureReading =
        BloodPressure.fromRawJson(bloodResponse.body);

    return bloodPressureReading;
  }
}