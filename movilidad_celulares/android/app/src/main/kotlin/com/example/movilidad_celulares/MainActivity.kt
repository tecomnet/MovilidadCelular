package com.example.movilidad_celulares

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.octolytics.octopulse.Octopulse
import android.util.Log


class MainActivity : FlutterActivity() {

  
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Octopulse.initialize(application)
         Log.d("Octopulse", "SDK initialized successfully")

    }
}
