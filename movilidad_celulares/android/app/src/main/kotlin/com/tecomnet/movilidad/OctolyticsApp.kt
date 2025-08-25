package com.tecomnet.movilidad
import android.app.Application
import android.os.Build
import com.octolytics.octopulse.Octopulse

class OctolyticsApp : Application() {
    companion object {
        lateinit var instance: OctolyticsApp
            private set
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Octopulse.initialize(this)
        }
    }
}