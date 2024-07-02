package com.example.flutter_microphone_control

import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import androidx.core.app.ActivityCompat
import android.Manifest
import androidx.core.content.ContextCompat

class FlutterMicrophoneControlPlugin: FlutterPlugin, MethodCallHandler {

    private lateinit var channel : MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_microphone_control")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "toggleMicrophone" -> {
                val isEnabled = call.arguments as Boolean
                val handler = MicrophoneHandler(context)
                val newState = handler.toggleMicrophone(isEnabled)
                result.success(newState)
            }
            "checkMicrophonePermission" -> {
                val isPermissionGranted = checkMicrophonePermission()
                result.success(isPermissionGranted)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkMicrophonePermission(): Boolean {
        val permission = Manifest.permission.RECORD_AUDIO
        val result = ContextCompat.checkSelfPermission(context, permission)
        return result == PackageManager.PERMISSION_GRANTED
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

// Define MicrophoneHandler class to handle microphone operations
class MicrophoneHandler(private val context: Context) {

    fun toggleMicrophone(isEnabled: Boolean): Boolean {
        // Implement logic to toggle microphone state
        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager.isMicrophoneMute = !isEnabled
        return audioManager.isMicrophoneMute
    }
}
