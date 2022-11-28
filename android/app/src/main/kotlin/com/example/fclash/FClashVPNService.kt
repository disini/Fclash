package com.example.fclash

import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.VpnService

class FClashVPNService: VpnService() {

    override fun onCreate() {
        super.onCreate()
        val ifConnectivity = IntentFilter()
        ifConnectivity.addAction(ConnectivityManager.CONNECTIVITY_ACTION)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }

}