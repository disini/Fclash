package com.example.fclash

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.VpnService
import android.os.Build
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {
    companion object {
        lateinit var flutterMethodChannel: MethodChannel
    }

    private var isRunning = false
    private val VPN_PERMISSION_REQUEST_CODE = 1001


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FClashVPNService.TAG)
        flutterMethodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            FClashVPNService.Companion.Action.StartProxy.toString() -> {
                startVpnService()
                result.success(null)
            }
            FClashVPNService.Companion.Action.StopProxy.toString() -> {
                stopVpnService()
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startVpnService() {
        // Start the VPN service
        val intent = Intent(this, FClashVPNService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        isRunning = true
        // Request VPN permission
        if (!hasVpnPermission()) {
            val vpnPermissionIntent = VpnService.prepare(this)
            if (vpnPermissionIntent != null) {
                startActivityForResult(vpnPermissionIntent, VPN_PERMISSION_REQUEST_CODE)
            } else {
                onVpnPermissionResult(RESULT_OK)
            }
        } else {
            onVpnPermissionResult(RESULT_OK)
        }
    }

    private fun stopVpnService() {
        if (isRunning) {
            val intent = Intent(this, FClashVPNService::class.java)
            stopService(intent)
            isRunning = false
        }
    }

    private fun onVpnPermissionResult(resultCode: Int) {
        if (resultCode == RESULT_OK) {
            // VPN permission granted
            Toast.makeText(this, "已授予VPN权限", Toast.LENGTH_SHORT).show()
        } else {
            // VPN permission denied
            Toast.makeText(this, "VPN权限申请被拒绝", Toast.LENGTH_SHORT).show()
            stopVpnService()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == VPN_PERMISSION_REQUEST_CODE) {
            onVpnPermissionResult(resultCode)
        }
    }

    private fun hasVpnPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            (checkSelfPermission(Manifest.permission.INTERNET) == PackageManager.PERMISSION_GRANTED) &&
                    (checkSelfPermission(Manifest.permission.RECEIVE_BOOT_COMPLETED) == PackageManager.PERMISSION_GRANTED) &&
                    (checkSelfPermission(Manifest.permission.FOREGROUND_SERVICE) == PackageManager.PERMISSION_GRANTED)
        } else {
            (checkSelfPermission(Manifest.permission.INTERNET) == PackageManager.PERMISSION_GRANTED) &&
                    (checkSelfPermission(Manifest.permission.RECEIVE_BOOT_COMPLETED) == PackageManager.PERMISSION_GRANTED)
        }
    }
}
