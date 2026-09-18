package com.tecomnet.movilidad

import android.app.Application
import com.octolytics.octopulse.Octopulse

class OctolyticsApp : Application() {
    companion object {
        lateinit var instance: OctolyticsApp
            private set
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        // Único punto de inicialización del SDK. Antes se llamaba también desde
        // MainActivity.onCreate, lo que inicializaba dos veces en Android 10+.
        // La guarda SDK_INT >= Q que había aquí dejaba fuera Android 9 (API 28),
        // que el AAR sí soporta; con minSdk = 28 ya no hace falta.
        Octopulse.initialize(this)
    }
}
