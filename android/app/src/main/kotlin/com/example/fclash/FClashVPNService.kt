package com.example.fclash

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.util.Log
import java.io.FileInputStream
import java.io.OutputStream
import java.net.Socket

class FClashVPNService : VpnService() {

    companion object {
        const val TAG = "FClashPlugin"
        enum class Action {
            StartProxy,
            StopProxy
        }
    }

    private var httpThread: Thread? = null
    private var mFd: ParcelFileDescriptor? = null
    private var clashSocket: Socket? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        mFd = with(Builder()) {
            addAddress("10.0.0.2", 32)
            addRoute("0.0.0.0", 0)
            addDnsServer("8.8.8.8")
            setMtu(1500)
            setSession("FClash")
            establish()
        }
        if (mFd == null) {
            Log.e("FClash", "Interface creation failed")
            return START_NOT_STICKY
        }
        httpThread = Thread {
            startHttpService()
        }
        httpThread?.start()
        return START_STICKY
    }
    private fun startHttpService() {
        clashSocket = Socket("127.0.0.1", 7890)
        protect(clashSocket)
        val stream = FileInputStream(mFd?.fileDescriptor)
    }

    override fun onDestroy() {
        super.onDestroy()
        stopVpnService()
    }

    private fun stopVpnService() {
        try {
            httpThread?.interrupt()
            // Close the VPN interface
            mFd?.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

}