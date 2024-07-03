import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterMicrophoneControlPlatform extends PlatformInterface {
  FlutterMicrophoneControlPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMicrophoneControlPlatform _instance =
      MethodChannelFlutterMicrophoneControl();

  static FlutterMicrophoneControlPlatform get instance => _instance;

  static set instance(FlutterMicrophoneControlPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> toggleMicrophone(bool isEnabled);

  Future<bool?> checkMicrophonePermission();

  Future<String?> getPlatformVersion();
}

class MethodChannelFlutterMicrophoneControl
    extends FlutterMicrophoneControlPlatform {
  MethodChannelFlutterMicrophoneControl() : super();

  static const MethodChannel _channel =
      MethodChannel('flutter_microphone_control');

  @override
  Future<bool?> toggleMicrophone(bool isEnabled) async {
    try {
      final bool? result = await _channel
          .invokeMethod('toggleMicrophone', {'isEnabled': isEnabled});
      return result;
    } catch (e) {
      log('~~~Failed to toggle microphone: $e');
      return false;
    }
  }

  @override
  Future<bool?> checkMicrophonePermission() async {
    try {
      final bool? result =
          await _channel.invokeMethod('checkMicrophonePermission');
      return result;
    } catch (e) {
      log('~~~Failed to check microphone permission: $e');
      return false;
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    } catch (e) {
      log('~~~Failed to get platform version: $e');
      return 'Unknown';
    }
  }
}
