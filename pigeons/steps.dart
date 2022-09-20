import 'package:pigeon/pigeon.dart';

// step(歩数関連) start
class NativeStepList {
  List<NativeStep?>? records;
}

class NativeStep {
  String? date; // date format: 'yyyy-MM-dd'
  int? distance;
  int? steps;
}

//
@HostApi()
abstract class FlutterCallNativeApi {
  @async
  NativeStep getTodayStep();

  @async
  NativeStepList getHistorySteps(); // get 31 days step list

  @async
  NativeStepList getLast2DaysSteps();

  @async
  NativeStepList getSteps(
      String startDate, String endDate); // date format: 'yyyy-MM-dd'
}

@HostApi()
abstract class FlutterCallIosNativeApi {
  @async
  void healthAuthorizationRequestMethod();

  @async
  bool isHealthKitDenied();

  @async
  NativeStep monitorBackgroundStepChanged();
}

@FlutterApi()
abstract class NativeCallFlutterApi {
  void uploadBackgroundLast2DaysSteps(NativeStepList list);

  void showLocalNotification();
}
// step(歩数関連) end

// standup(ブレイク関連) start
enum StandUpResult { bad, good, better, amazing }

class StandUpHourResult {
  int? hour;
  StandUpResult? result;
}

class StandUpResultInDate {
  List<StandUpHourResult?>? value;
  String? errorMessage;
}

class StandUpRequestDuration {
  String? dateFormat;
  String? startDate;
  String? endDate;
}

class StandUpResults {
  StandUpRequestDuration? duration;
  Map<String?, List<Object?>?>? results;
}

@HostApi()
abstract class StandUpApi {
  @async
  StandUpResultInDate getStandUpAt(String date, String dateFormat);

  @async
  StandUpResults getStandUp(StandUpRequestDuration duration);
}
// standup(ブレイク関連) end

// fitness certification(GoogleFit) start
enum FitnessRequestPermissionResult {
  granted,
  fitnessNotGranted,
  fitnessNotInstalled,
  noGoogleAccountConfirmed
}

class FitnessRequestPermissionResultObject {
  FitnessRequestPermissionResult? value;
}

@HostApi()
abstract class AndroidFitnessApi {
  @async
  bool googleSignInHasPermissions();

  @async
  FitnessRequestPermissionResultObject requestFitnessPermissionStatus();
}
// fitness certification(GoogleFit) end
