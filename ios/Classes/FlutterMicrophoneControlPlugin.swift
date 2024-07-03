import Flutter
import UIKit
import AVFoundation

public class FlutterMicrophoneControlPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_microphone_control", binaryMessenger: registrar.messenger())
    let instance = FlutterMicrophoneControlPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "toggleMicrophone":
      guard let arguments = call.arguments as? [String: Any],
            let isEnabled = arguments["isEnabled"] as? Bool else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing or invalid argument", details: nil))
        return
      }
      let newState = toggleMicrophone(isEnabled: isEnabled)
      result(newState)
    case "checkMicrophonePermission":
      let isPermissionGranted = checkMicrophonePermission()
      result(isPermissionGranted)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func toggleMicrophone(isEnabled: Bool) -> Bool {
    let session = AVAudioSession.sharedInstance()
    var newMicrophoneState = isEnabled
    do {
      try session.setCategory(.playAndRecord, mode: .default, options: [])
      try session.setActive(true)
      if isEnabled {
        try session.setInputGain(1.0) // Set input gain to normal
      } else {
        try session.setInputGain(0.0) // Mute the microphone
      }
      newMicrophoneState = !isEnabled
    } catch {
      print("Failed to toggle microphone: \(error)")
      newMicrophoneState = isEnabled // Revert state on failure
    }
    return newMicrophoneState
  }

  private func checkMicrophonePermission() -> Bool {
    let permissionStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    return permissionStatus == .authorized
  }
}
