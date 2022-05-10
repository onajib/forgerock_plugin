import 'dart:async';

import 'package:flutter/services.dart';

class ForgerockPlugin {
  static const MethodChannel _channel = MethodChannel('forgerock_plugin');

  static Future<String?> get platformVersion async {
    
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    // final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get tata async {
    final String? version = await _channel.invokeMethod('printTata');
    return version;
  }
  static Future<String?> get dismiss async {
    final String? result = await _channel.invokeMethod('dismiss');
    return result;
  }

  static Future<String?> get initSdk async {
    final String? version = await _channel.invokeMethod('initSdk');
    return version;
  }

  static Future<String?> login({
    required String email,
    required String password,
    required int keepSessionOpened,
  }) async {
    final String? version = await _channel.invokeMethod(
      'login',
      {
        'email': email,
        'password': password,
      },
    );
    return version;
  }

  static Future<String?> getToken() async {
    final String? version = await _channel.invokeMethod<String?>('getToken');
    return version;
  }
  static Future<String?> logOut() async {
    final String? result = await _channel.invokeMethod('logOut');
    print("resukt tt  ${result!}");
    return result;
  }

}
