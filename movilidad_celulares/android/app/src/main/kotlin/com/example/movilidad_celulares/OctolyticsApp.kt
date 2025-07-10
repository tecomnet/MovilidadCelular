package com.example.movilidad_celulares

import com.octolytics.octopulse.Octopulse
import android.app.Application
import android.os.Build

class OctolyticsApp: Application() {

    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Octopulse.initialize(this)
        }
    }
}