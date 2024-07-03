import Flutter
import UIKit
import AVFoundation

public class FlutterMicrophoneControlPlugin: NSObject, FlutterPlugin {
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_microphone_control", binaryMessenger: registrar.messenger())
    let instance = FlutterMicrophoneControlPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    NotificationCenter.default.addObserver(instance, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
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
    print("Toggling microphone to \(isEnabled)")
    let session = AVAudioSession.sharedInstance()
    var newMicrophoneState = isEnabled
    do {
      try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
      try session.setMode(.default)
      try session.setActive(true, options: .notifyOthersOnDeactivation)
      if isEnabled {
        try session.overrideOutputAudioPort(.none)
      } else {
        try session.overrideOutputAudioPort(.speaker)
      }
      newMicrophoneState = !isEnabled
      print("Microphone toggled successfully to \(newMicrophoneState)")
    } catch {
      print("Failed to toggle microphone: \(error.localizedDescription)")
      newMicrophoneState = !isEnabled
    }
    return newMicrophoneState
  }
  
  private func checkMicrophonePermission() -> Bool {
    let permissionStatus = AVCaptureDevice.authorizationStatus(for: .audio)
    return permissionStatus == .authorized
  }
  
  @objc private func handleInterruption(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
          let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
      return
    }
    
    if type == .began {
      // Interruption began, take appropriate actions
      print("Audio session interruption began")
    } else if type == .ended {
      // Interruption ended, take appropriate actions
      do {
        try AVAudioSession.sharedInstance().setActive(true)
        print("Audio session interruption ended")
      } catch {
        print("Failed to reactivate audio session after interruption: \(error.localizedDescription)")
      }
    }
  }
}
