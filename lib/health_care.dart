import 'dart:convert';
import 'dart:io';

import 'package:karadalive_api_flutter/karadalive_flutter_api.dart';
import 'package:app_utils_flutter/app_utils.dart';
import 'package:health_care/pigeons/steps.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionStatus {
  notRequested,
  granted,
  denied,
}

enum IosCoreMotionOrHealthKitPermissionStatus {
  granted,
  denied,
}

class HealthCareManager {
  static final HealthCareManager _instance = HealthCareManager._internal();
  static final FlutterCallNativeApi _nativeApi = FlutterCallNativeApi();
  static const _hiveBoxName = "jp.co.felicapocketmk.healthCare_box";
  static final box = Hive.box(_hiveBoxName);
  static const _hiveBoxSaveStepListKey = "healthCare_stepList";
  static const _permissionHasRequested = "healthCare_permissionHasRequested";

  factory HealthCareManager() {
    return _instance;
  }

  HealthCareManager._internal();

  /// Home today's step data.
  Future<NativeStep> getHomeTodyStep() async {
    final todayStep = await _nativeApi.getTodayStep();
    final recordResponse = await ApiService(null).getHistoryRecord(
        historyRecordRequest: HistoryRecordRequest(
            beginDate: DateTime.now(),
            endDate: DateTime.now(),
            enableMove: true));
    if ((recordResponse?.list?.isNotEmpty ?? false) &&
        (recordResponse?.list?[0].step ?? 0) > (todayStep.steps ?? 0)) {
      return NativeStep(
          date: DateFormat(DateFormats.YMD_HYPHEN).format(DateTime.now()),
          distance: recordResponse?.list?[0].distance,
          steps: recordResponse?.list?[0].step);
    }
    return todayStep;
  }

  /// Get today's step data.
  Future<NativeStep> getTodayStep() async {
    return await _nativeApi.getTodayStep();
  }

  /// Get 31 days step list.
  Future<NativeStepList> getLast31DaysSteps() async {
    return await _nativeApi.getHistorySteps();
  }

  /// Get step list in days.
  Future<NativeStepList> getStepsInDays(
      {required DateTime startDate, required DateTime endDate}) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String start = dateFormat.format(startDate);
    String end = dateFormat.format(endDate);
    return await _nativeApi.getSteps(start, end);
  }

  /// Upload step data that has not been uploaded.
  Future<void> uploadSteps() async {
    await _openHive();
    final nativeLast31DaysSteps = await getLast31DaysSteps();
    final List<StepAddRequest> stepsListFromDevice = nativeLast31DaysSteps
            .records
            ?.map((e) => StepAddRequest(
                date: e?.date, step: "${e?.steps}", distance: "${e?.distance}"))
            .toList() ??
        [];

    List<StepAddRequest> needUploadStepList = stepsListFromDevice;
    final String savedStepsJsonStr = box.get(_hiveBoxSaveStepListKey) ?? "";
    if (savedStepsJsonStr.isNotEmpty) {
      final savedStepsJson =
          json.decode(savedStepsJsonStr) as Map<String, dynamic>;
      StepListAddRequest savedSteps =
          stepListAddRequestFromJson(savedStepsJson);

      savedSteps.list?.forEach((savedStep) {
        needUploadStepList.removeWhere((deviceStep) =>
            deviceStep.date == savedStep.date &&
            deviceStep.distance == savedStep.distance &&
            deviceStep.step == savedStep.step);
      });
    }

    /// No need to upload data
    if (needUploadStepList.isEmpty) {
      return;
    }

    final StepListAddRequest needUploadSteps =
        StepListAddRequest(list: needUploadStepList);

    /// upload
    try {
      var result = await ApiService(null)
          .stepListAdd(stepListAddRequest: needUploadSteps);
      if (result?.isSuccess ?? false) {
        AppDebug.log('@@@ UPLOAD HISTORY STEP DATA SUCCESS');

        /// upload success
        if (savedStepsJsonStr.isNotEmpty) {
          final savedStepsJson =
              json.decode(savedStepsJsonStr) as Map<String, dynamic>;
          List<StepAddRequest> savedList =
              stepListAddRequestFromJson(savedStepsJson).list ?? [];
          for (var uploadStep in needUploadStepList) {
            savedList.removeWhere((element) => uploadStep.date == element.date);
          }
          savedList.addAll(needUploadStepList);
          if (savedList.length > 31) {
            savedList.sort((a, b) => a.date!.compareTo(b.date!));
            savedList.removeRange(0, savedList.length - 31);
          }
          await box.put(_hiveBoxSaveStepListKey,
              stepListAddRequestToJson(StepListAddRequest(list: savedList)));
        } else {
          await box.put(
              _hiveBoxSaveStepListKey,
              stepListAddRequestToJson(
                  StepListAddRequest(list: needUploadStepList)));
        }
      } else {
        AppDebug.log('@@@ UPLOAD HISTORY STEP DATA FILED');
      }
    } catch (e) {
      AppDebug.log('@@@ UPLOAD HISTORY STEP DATA FILED');
    }
  }

  /// check get steps permission.
  Future<PermissionStatus> checkPermission() async {
    await _openHive();
    bool permissionHasRequested =
        box.get(_permissionHasRequested, defaultValue: false);

    if (!permissionHasRequested) {
      return PermissionStatus.notRequested;
    }

    if (Platform.isAndroid) {
      bool hasPermission =
          await AndroidFitnessApi().googleSignInHasPermissions();
      return hasPermission ? PermissionStatus.granted : PermissionStatus.denied;
    }

    if (Platform.isIOS) {
      var healthKitIsGranted =
          !await FlutterCallIosNativeApi().isHealthKitDenied();

      var coreMotionIsGranted = await Permission.sensors.status.isGranted;

      return healthKitIsGranted || coreMotionIsGranted
          ? PermissionStatus.granted
          : PermissionStatus.denied;
    }
    return PermissionStatus.notRequested;
  }

  Future<IosCoreMotionOrHealthKitPermissionStatus>
      checkIosCoreMotionPermission() async {
    var coreMotionIsGranted = await Permission.sensors.status.isGranted;
    return coreMotionIsGranted
        ? IosCoreMotionOrHealthKitPermissionStatus.granted
        : IosCoreMotionOrHealthKitPermissionStatus.denied;
  }

  Future<IosCoreMotionOrHealthKitPermissionStatus>
      checkIosHealthKitPermission() async {
    var healthKitIsGranted =
        !await FlutterCallIosNativeApi().isHealthKitDenied();
    return healthKitIsGranted
        ? IosCoreMotionOrHealthKitPermissionStatus.granted
        : IosCoreMotionOrHealthKitPermissionStatus.denied;
  }

  /// requestPermission() is a async method with no return value. To check if permission has been granted, call checkPermission()
  ///
  /// Example:
  /// ```dart
  /// HealthCareManager().requestPermission().then((_) async {
  ///   final permissionStatus = await HealthCareManager().checkPermission();
  ///   // TODO: do something.
  /// });
  /// ```
  Future<void> requestPermission() async {
    await _openHive();
    AppDebug.log("health_care:call health_care requestPermission.");
    box.put(_permissionHasRequested, true);
    if (Platform.isAndroid) {
      bool hasPermission =
          await AndroidFitnessApi().googleSignInHasPermissions();
      if (!hasPermission) {
        AppDebug.log(
            "health_care: android googleSignInHasPermissions() = false");
        await AndroidFitnessApi().requestFitnessPermissionStatus();
      } else {
        AppDebug.log(
            "health_care: android googleSignInHasPermissions() = true");
      }
    }

    if (Platform.isIOS) {
      await Future.wait([
        Permission.sensors.request(),
        FlutterCallIosNativeApi().healthAuthorizationRequestMethod()
      ]);
    }
    AppDebug.log("health_care:call health_care requestPermission finished.");
  }

  Future<void> _openHive() async {
    var isBoxOpen = Hive.isBoxOpen(_hiveBoxName);
    AppDebug.log("isBoxOpen:$isBoxOpen");
    if (!isBoxOpen) {
      await Hive.initFlutter();
      await Hive.openBox(_hiveBoxName);
    }
  }
}
