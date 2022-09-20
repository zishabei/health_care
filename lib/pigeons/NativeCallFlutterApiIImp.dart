import 'package:karadalive_api_flutter/karadalive_flutter_api.dart';
import 'package:app_utils_flutter/app_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_care/pigeons/steps.dart';
import 'package:health_care/utility/debug_util.dart';

// Callbacks of Native Call Flutter method
class NativeCallFlutterApiImp extends NativeCallFlutterApi {
  @override
  Future<void> showLocalNotification() async {
    DebugUtil.log("@@@ iOS -> Flutter: showLocalNotification");
    if (getFlavor() == Flavor.dev) {
      // Just show in dev
      showNotification(
          0, "Note", "The last 2 days of steps are uploaded in the background");
    } else {
      DebugUtil.log("@@@ isProd. Do not show LocalNotification");
    }
  }

  @override
  Future<void> uploadBackgroundLast2DaysSteps(NativeStepList list) async {
    DebugUtil.log(
        "@@@ iOS -> Flutter: uploadBackgroundLast2DaysSteps: ${list.records}");

    var request = list.records
        ?.map((e) => StepAddRequest(
        date: e?.date,
        distance: e?.distance.toString(),
        step: e?.steps.toString()))
        .toList();

    var stepListAddRequest = StepListAddRequest(list: request);
    try {
      var result = await ApiService(null)
          .stepListAdd(stepListAddRequest: stepListAddRequest);

      if (result != null) {
        // final controller = buildContext.read(homeProvider.notifier);
        // WidgetsBinding.instance!.addPostFrameCallback((_) async {
        //   controller.getDataList(
        //     buildContext,
        //     enableBp: 1,
        //     enableWeight: 1,
        //     enableMove: 1,
        //   );
        // });
        DebugUtil.log(
            '@@@ BACKGROUND UPLOAD LAST 2 DAYS STEP DATA TO BACKEND SUCCESS: $result');
      } else {
        DebugUtil.log(
            '@@@ BACKGROUND UPLOAD LAST 2 DAYS STEP DATA TO BACKEND FAIL: $result');
      }
    } catch (e) {
      DebugUtil.log(
          '@@@ BACKGROUND UPLOAD LAST 2 DAYS STEP DATA TO BACKEND ERROR: $e');
    }
  }

  //
  showNotification(int? id, String? title, String? body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const IOSInitializationSettings initializationSettingsISO =
    IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    const InitializationSettings initializationSettings =
    InitializationSettings(iOS: initializationSettingsISO);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin.show(
        id ?? 0, title, body, NotificationDetails());
  }
}
