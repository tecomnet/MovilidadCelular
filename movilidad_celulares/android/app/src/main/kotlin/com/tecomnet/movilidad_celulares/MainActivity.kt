package com.tecomnet.movilidad

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.octolytics.octopulse.Octopulse
import androidx.core.app.ActivityCompat
import android.annotation.SuppressLint


class MainActivity : FlutterFragmentActivity() {

    private lateinit var permissionResultLauncher: ActivityResultLauncher<Array<String>>
    private val CHANNEL = "com.tecomnet.movilidad_celulares/permissions"

    private var permissionResultCallback: MethodChannel.Result? = null
    private var isRequestingPermissions = false

    private lateinit var channel: MethodChannel
    private var msisdn: String = ""
    private var BEid: String = "000"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Octopulse.initialize(application)
        enableMonitoring()
        Octopulse.start()

        permissionResultLauncher = registerForActivityResult(
            ActivityResultContracts.RequestMultiplePermissions()
        ) { permissions ->

            isRequestingPermissions = false

            var allGranted = true
            val deniedPermissions = mutableListOf<String>()

            permissions.forEach { (perm, granted) ->
                Log.d("Permissions", "Permission $perm granted? $granted")
                if (!granted) {
                    allGranted = false
                    deniedPermissions.add(perm)
                }
            }

            if (allGranted) {
                validatePermissions()
            } else {
                val shouldShowRationale = deniedPermissions.any { shouldShowRequestPermissionRationale(it) }

                if (shouldShowRationale) {
                    validatePermissions()
                } else {
                    openAppSettings()
                    permissionResultCallback?.success(false)
                    permissionResultCallback = null
                }
            }
        }
    }
 private fun enableMonitoring() {
    Octopulse.changeMonitoringSettingStatus(true)
    val status = Octopulse.isMonitoringSettingEnabled()
    Log.d("Octopulse", "Monitoring is enabled: $status")
}

    fun isMonitoring() {
            if (!Octopulse.isMonitoringSettingEnabled()) {
                Octopulse.changeMonitoringSettingStatus(true)
            }
        }
        override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)

            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "pedirPermisos") {
                    if (isRequestingPermissions) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    permissionResultCallback = result
                    validatePermissions()
                } else {
                    result.notImplemented()
                }
            }
            channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "channelUpdateKPI")
    channel.setMethodCallHandler { call, result ->
        when (call.method) {
            "initializeOctolytics" -> {
                result.success("Ok")
            }
            "startServiceOctolytics" -> {
                val phone = call.argument<String>("arg") ?: msisdn
                registerDevice(phone)
                result.success("Ok")
            }
            "validarPermisos" -> {
        if (!Octopulse.hasMinimumPermissionsGranted(this)) {
            isRequestingPermissions = true
            permissionResultLauncher.launch(
                arrayOf(
                    Manifest.permission.READ_CALL_LOG,
                    Manifest.permission.READ_SMS,
                    Manifest.permission.POST_NOTIFICATIONS,
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.READ_PHONE_STATE
                )
            )
        } else {
            val phone = call.argument<String>("arg") ?: msisdn
            registerDevice(phone)
        }
        result.success("Ok")
    }

            "launchActivity" -> {
                if (Octopulse.isDeviceRegistered()) {
                    Octopulse.launchHelpActivity(this)
                } else {
                    Octopulse.launchAddMsisdnActivity(this, null)
                }
                
                result.success("Ok")
            }
            "launchHelpActivity" -> {
                    launchHelpActivity()
                    result.success("HelpActivity launched")
                }
                "launchAddMsisdnActivity" -> {
                    launchAddMsisdnActivity()
                    result.success("AddMsisdnActivity launched")
                }
            else -> result.notImplemented()
        }
    }

        }
  private fun launchHelpActivity() {
        Log.d("Octopulse", "Lanzando HelpActivity")
        Octopulse.launchHelpActivity(this)
    }

    private fun launchAddMsisdnActivity() {
        Log.d("Octopulse", "Lanzando AddMsisdnActivity")
        Octopulse.launchAddMsisdnActivity(this)
    }
    private fun validatePermissions() {
        Log.d("Permissions", "Iniciando validación de permisos")

        val foregroundPermissions = arrayOf(
            Manifest.permission.READ_CALL_LOG,
            Manifest.permission.READ_SMS,
            Manifest.permission.POST_NOTIFICATIONS,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_PHONE_STATE
        )

        val backgroundPermission = Manifest.permission.ACCESS_BACKGROUND_LOCATION

        val foregroundGranted = foregroundPermissions.all {
            ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
        }

        if (!foregroundGranted) {
            Log.d("Permissions", "Solicitando permisos de primer plano")
            isRequestingPermissions = true
            permissionResultLauncher.launch(foregroundPermissions)
            return
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val backgroundGranted = ContextCompat.checkSelfPermission(this, backgroundPermission) == PackageManager.PERMISSION_GRANTED
            if (!backgroundGranted) {
                Log.d("Permissions", "Solicitando permiso de ubicación en segundo plano")
                ActivityCompat.requestPermissions(this, arrayOf(backgroundPermission), 1234)
                return
            }
        }

        Log.d("Permissions", "Todos los permisos ya fueron otorgados")
        permissionResultCallback?.success(true)
        permissionResultCallback = null

        requestIgnoreBatteryOptimization()
        registerDevice()
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == 1234) {
            val backgroundGranted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            if (backgroundGranted) {
                Log.d("Permissions", "Permiso de ubicación en segundo plano otorgado")
                permissionResultCallback?.success(true)
                permissionResultCallback = null
                requestIgnoreBatteryOptimization()
                registerDevice()
            } else {
                Log.d("Permissions", "Permiso de ubicación en segundo plano denegado")
                permissionResultCallback?.success(false)
                permissionResultCallback = null
            }
        }
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = Uri.parse("package:$packageName")
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    private fun requestIgnoreBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
            intent.data = Uri.parse("package:$packageName")
            startActivity(intent)
        }
    }

    private fun registerDevice(argPhone: String = msisdn) {
    Log.d("Octopulse", "Iniciando registro del dispositivo")
    if (!Octopulse.isDeviceRegistered()) {
        val phoneNumber = if (Octopulse.hasCarrierPrivileges()) null else argPhone
        Octopulse.registerDevice(this, phoneNumber, {
            Log.d("Octopulse", "Registro exitoso")
            Octopulse.start()

            continueToApp()
        }, { error ->
            Log.d("Octopulse", "Error al registrar dispositivo: ${error?.message}")
        })
    } else {
        Log.d("Octopulse", "Dispositivo ya registrado")
        Octopulse.start()
        continueToApp()
    }
}

    private val permissionsActivityResultContract = registerForActivityResult(
    ActivityResultContracts.StartActivityForResult()
) { result ->
    if (result.resultCode == RESULT_OK) {
        registerDevice(msisdn)
        Log.d("Permissions grant", "permissions")
    } else {
        Log.d("Permissions error", "Missing permissions ${result.resultCode}")
    }
}

@SuppressLint("NewApi")
    private fun continueToApp() {
        Log.d("Octopulse", "Lanzando actividad para consultar APN y VoLTE")

      if (Octopulse.isDeviceRegistered()) {
            Octopulse.launchHelpActivity(this)
        } else {
            Octopulse.launchAddMsisdnActivity(this)
        }
        finish()
    }

     private fun openPermissionActivity() {
        Log.d("Octopulse", "Abriendo actividad de permisos...")
        Octopulse.launchPermissionActivity(this)
    }
}
    