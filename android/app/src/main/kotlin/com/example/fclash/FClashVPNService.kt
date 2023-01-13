package com.example.fclash

import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.InetAddresses
import android.net.VpnService
import java.net.InetAddress

class FClashVPNService: VpnService() {

    companion object {
        const val TAG = "FClashPlugin"
        enum class Action {
            StartProxy,
            StopProxy
        }
    }

    override fun onCreate() {
        super.onCreate()
        val ifConnectivity = IntentFilter()
        ifConnectivity.addAction(ConnectivityManager.CONNECTIVITY_ACTION)
        Builder().addAddress(InetAddress.)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }

}