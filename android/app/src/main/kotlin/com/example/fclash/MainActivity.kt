package com.example.fclash

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {
    companion object {
        lateinit var flutterMethodChannel: MethodChannel
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FClashVPNService.TAG)
        flutterMethodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            FClashVPNService.Companion.Action.StartProxy.toString() -> {

                result.success(null)
            }
            FClashVPNService.Companion.Action.StopProxy.toString() -> {
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
