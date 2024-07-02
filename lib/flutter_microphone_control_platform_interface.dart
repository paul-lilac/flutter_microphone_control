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

  /// Toggles the microphone state on the native platform.
  Future<bool?> toggleMicrophone(bool isEnabled);

  /// Checks microphone permission status on the native platform.
  Future<bool?> checkMicrophonePermission();

  /// Retrieves the platform version from the native platform.
  Future<String?> getPlatformVersion();
}

class MethodChannelFlutterMicrophoneControl
    extends FlutterMicrophoneControlPlatform {
  MethodChannelFlutterMicrophoneControl() : super();

  @override
  Future<bool?> toggleMicrophone(bool isEnabled) async {
    try {
      // Replace with actual implementation based on platform-specific code
      bool? result = await const MethodChannel('flutter_microphone_control')
          .invokeMethod('toggleMicrophone', isEnabled);
      return result;
    } catch (e) {
      log('~~~Failed to toggle microphone: $e');
      return false;
    }
  }

  @override
  Future<bool?> checkMicrophonePermission() async {
    try {
      // Replace with actual implementation based on platform-specific code
      bool? result = await const MethodChannel('flutter_microphone_control')
          .invokeMethod('checkMicrophonePermission');
      return result;
    } catch (e) {
      log('~~~Failed to check microphone permission: $e');
      return false;
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    try {
      // Replace with actual implementation based on platform-specific code
      String? version = await const MethodChannel('flutter_microphone_control')
          .invokeMethod('getPlatformVersion');
      return version;
    } catch (e) {
      log('~~~Failed to get platform version: $e');
      return 'Unknown';
    }
  }
}
