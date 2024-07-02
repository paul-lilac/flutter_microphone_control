import 'flutter_microphone_control_platform_interface.dart';

class FlutterMicrophoneControl {
  /// Retrieves the platform version from the native platform.
  Future<String?> getPlatformVersion() {
    return FlutterMicrophoneControlPlatform.instance.getPlatformVersion();
  }

  /// Toggles the microphone state on the native platform.
  Future<bool?> toggleMicrophone(bool isEnabled) {
    return FlutterMicrophoneControlPlatform.instance
        .toggleMicrophone(isEnabled);
  }

  /// Checks microphone permission status on the native platform.
  Future<bool?> checkMicrophonePermission() {
    return FlutterMicrophoneControlPlatform.instance
        .checkMicrophonePermission();
  }
}
