// Autogenerated from Pigeon (v2.0.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;

import 'package:flutter/foundation.dart' show WriteBuffer, ReadBuffer;
import 'package:flutter/services.dart';

enum StandUpResult {
  bad,
  good,
  better,
  amazing,
}

enum FitnessRequestPermissionResult {
  granted,
  fitnessNotGranted,
  fitnessNotInstalled,
  noGoogleAccountConfirmed,
}

class NativeStepList {
  NativeStepList({
    this.records,
  });

  List<NativeStep?>? records;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['records'] = records;
    return pigeonMap;
  }

  static NativeStepList decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return NativeStepList(
      records: (pigeonMap['records'] as List<Object?>?)?.cast<NativeStep?>(),
    );
  }
}

class NativeStep {
  NativeStep({
    this.date,
    this.distance,
    this.steps,
  });

  String? date;
  int? distance;
  int? steps;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['date'] = date;
    pigeonMap['distance'] = distance;
    pigeonMap['steps'] = steps;
    return pigeonMap;
  }

  static NativeStep decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return NativeStep(
      date: pigeonMap['date'] as String?,
      distance: pigeonMap['distance'] as int?,
      steps: pigeonMap['steps'] as int?,
    );
  }
}

class StandUpHourResult {
  StandUpHourResult({
    this.hour,
    this.result,
  });

  int? hour;
  StandUpResult? result;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['hour'] = hour;
    pigeonMap['result'] = result == null ? null : result!.index;
    return pigeonMap;
  }

  static StandUpHourResult decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StandUpHourResult(
      hour: pigeonMap['hour'] as int?,
      result: pigeonMap['result'] != null
          ? StandUpResult.values[pigeonMap['result']! as int]
          : null,
    );
  }
}

class StandUpResultInDate {
  StandUpResultInDate({
    this.value,
    this.errorMessage,
  });

  List<StandUpHourResult?>? value;
  String? errorMessage;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['value'] = value;
    pigeonMap['errorMessage'] = errorMessage;
    return pigeonMap;
  }

  static StandUpResultInDate decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StandUpResultInDate(
      value: (pigeonMap['value'] as List<Object?>?)?.cast<StandUpHourResult?>(),
      errorMessage: pigeonMap['errorMessage'] as String?,
    );
  }
}

class StandUpRequestDuration {
  StandUpRequestDuration({
    this.dateFormat,
    this.startDate,
    this.endDate,
  });

  String? dateFormat;
  String? startDate;
  String? endDate;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['dateFormat'] = dateFormat;
    pigeonMap['startDate'] = startDate;
    pigeonMap['endDate'] = endDate;
    return pigeonMap;
  }

  static StandUpRequestDuration decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StandUpRequestDuration(
      dateFormat: pigeonMap['dateFormat'] as String?,
      startDate: pigeonMap['startDate'] as String?,
      endDate: pigeonMap['endDate'] as String?,
    );
  }
}

class StandUpResults {
  StandUpResults({
    this.duration,
    this.results,
  });

  StandUpRequestDuration? duration;
  Map<String?, List<Object?>?>? results;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['duration'] = duration == null ? null : duration!.encode();
    pigeonMap['results'] = results;
    return pigeonMap;
  }

  static StandUpResults decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StandUpResults(
      duration: pigeonMap['duration'] != null
          ? StandUpRequestDuration.decode(pigeonMap['duration']!)
          : null,
      results: (pigeonMap['results'] as Map<Object?, Object?>?)?.cast<String?, List<Object?>?>(),
    );
  }
}

class FitnessRequestPermissionResultObject {
  FitnessRequestPermissionResultObject({
    this.value,
  });

  FitnessRequestPermissionResult? value;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['value'] = value == null ? null : value!.index;
    return pigeonMap;
  }

  static FitnessRequestPermissionResultObject decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return FitnessRequestPermissionResultObject(
      value: pigeonMap['value'] != null
          ? FitnessRequestPermissionResult.values[pigeonMap['value']! as int]
          : null,
    );
  }
}

class _FlutterCallNativeApiCodec extends StandardMessageCodec {
  const _FlutterCallNativeApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is NativeStep) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
    if (value is NativeStepList) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return NativeStep.decode(readValue(buffer)!);
      
      case 129:       
        return NativeStepList.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class FlutterCallNativeApi {
  /// Constructor for [FlutterCallNativeApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  FlutterCallNativeApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _FlutterCallNativeApiCodec();

  Future<NativeStep> getTodayStep() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallNativeApi.getTodayStep', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as NativeStep?)!;
    }
  }

  Future<NativeStepList> getHistorySteps() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallNativeApi.getHistorySteps', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as NativeStepList?)!;
    }
  }

  Future<NativeStepList> getLast2DaysSteps() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallNativeApi.getLast2DaysSteps', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as NativeStepList?)!;
    }
  }

  Future<NativeStepList> getSteps(String arg_startDate, String arg_endDate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallNativeApi.getSteps', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_startDate, arg_endDate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as NativeStepList?)!;
    }
  }
}

class _FlutterCallIosNativeApiCodec extends StandardMessageCodec {
  const _FlutterCallIosNativeApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is NativeStep) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return NativeStep.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class FlutterCallIosNativeApi {
  /// Constructor for [FlutterCallIosNativeApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  FlutterCallIosNativeApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _FlutterCallIosNativeApiCodec();

  Future<void> healthAuthorizationRequestMethod() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallIosNativeApi.healthAuthorizationRequestMethod', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isHealthKitDenied() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallIosNativeApi.isHealthKitDenied', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<NativeStep> monitorBackgroundStepChanged() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.FlutterCallIosNativeApi.monitorBackgroundStepChanged', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as NativeStep?)!;
    }
  }
}

class _NativeCallFlutterApiCodec extends StandardMessageCodec {
  const _NativeCallFlutterApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is NativeStep) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
    if (value is NativeStepList) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return NativeStep.decode(readValue(buffer)!);
      
      case 129:       
        return NativeStepList.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}
abstract class NativeCallFlutterApi {
  static const MessageCodec<Object?> codec = _NativeCallFlutterApiCodec();

  void uploadBackgroundLast2DaysSteps(NativeStepList list);
  void showLocalNotification();
  static void setup(NativeCallFlutterApi? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.NativeCallFlutterApi.uploadBackgroundLast2DaysSteps', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.NativeCallFlutterApi.uploadBackgroundLast2DaysSteps was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final NativeStepList? arg_list = (args[0] as NativeStepList?);
          assert(arg_list != null, 'Argument for dev.flutter.pigeon.NativeCallFlutterApi.uploadBackgroundLast2DaysSteps was null, expected non-null NativeStepList.');
          api.uploadBackgroundLast2DaysSteps(arg_list!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.NativeCallFlutterApi.showLocalNotification', codec, binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          // ignore message
          api.showLocalNotification();
          return;
        });
      }
    }
  }
}

class _StandUpApiCodec extends StandardMessageCodec {
  const _StandUpApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is StandUpHourResult) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
    if (value is StandUpRequestDuration) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else 
    if (value is StandUpResultInDate) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else 
    if (value is StandUpResults) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return StandUpHourResult.decode(readValue(buffer)!);
      
      case 129:       
        return StandUpRequestDuration.decode(readValue(buffer)!);
      
      case 130:       
        return StandUpResultInDate.decode(readValue(buffer)!);
      
      case 131:       
        return StandUpResults.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class StandUpApi {
  /// Constructor for [StandUpApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  StandUpApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _StandUpApiCodec();

  Future<StandUpResultInDate> getStandUpAt(String arg_date, String arg_dateFormat) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StandUpApi.getStandUpAt', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_date, arg_dateFormat]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StandUpResultInDate?)!;
    }
  }

  Future<StandUpResults> getStandUp(StandUpRequestDuration arg_duration) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StandUpApi.getStandUp', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_duration]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StandUpResults?)!;
    }
  }
}

class _AndroidFitnessApiCodec extends StandardMessageCodec {
  const _AndroidFitnessApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is FitnessRequestPermissionResultObject) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else 
{
      super.writeValue(buffer, value);
    }
  }
  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:       
        return FitnessRequestPermissionResultObject.decode(readValue(buffer)!);
      
      default:      
        return super.readValueOfType(type, buffer);
      
    }
  }
}

class AndroidFitnessApi {
  /// Constructor for [AndroidFitnessApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  AndroidFitnessApi({BinaryMessenger? binaryMessenger}) : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _AndroidFitnessApiCodec();

  Future<bool> googleSignInHasPermissions() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.AndroidFitnessApi.googleSignInHasPermissions', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<FitnessRequestPermissionResultObject> requestFitnessPermissionStatus() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.AndroidFitnessApi.requestFitnessPermissionStatus', codec, binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error = (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as FitnessRequestPermissionResultObject?)!;
    }
  }
}