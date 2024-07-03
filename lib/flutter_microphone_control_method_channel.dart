import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_microphone_control_platform_interface.dart';

class MethodChannelFlutterMicrophoneControl
    extends FlutterMicrophoneControlPlatform {
  @visibleForTesting
  final MethodChannel methodChannel =
      const MethodChannel('flutter_microphone_control');

  @override
  Future<bool?> toggleMicrophone(bool isEnabled) async {
    try {
      final bool? newState = await methodChannel
          .invokeMethod<bool>('toggleMicrophone', {'isEnabled': isEnabled});
      return newState;
    } on PlatformException catch (e) {
      throw FlutterError('Failed to toggle microphone: ${e.message}');
    }
  }

  @override
  Future<bool?> checkMicrophonePermission() async {
    try {
      final bool? isPermissionGranted =
          await methodChannel.invokeMethod<bool>('checkMicrophonePermission');
      return isPermissionGranted;
    } on PlatformException catch (e) {
      throw FlutterError('Failed to check microphone permission: ${e.message}');
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final String? version =
          await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } on PlatformException catch (e) {
      throw FlutterError('Failed to get platform version: ${e.message}');
    }
  }
}
