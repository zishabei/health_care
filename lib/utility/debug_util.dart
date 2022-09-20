import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class DebugUtil {
  static bool isDebug() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return false;
    }
    return true;
  }

  static void log(dynamic value) {
    if (isDebug()) {
      developer.log(value.toString());
    }
  }

  static void showErrorToast({String? code, String? message, dynamic details}) {
    if (isDebug()) {
      final list = <dynamic>[code, message, details];
      list.removeWhere((dynamic value) => value == null);
      log(list.join('\n'));
      Fluttertoast.showToast(
        msg: list.join('\n'),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
