package com.example.movilidad_celulares

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

class MainActivity : FlutterFragmentActivity() {

    private lateinit var permissionResultLauncher: ActivityResultLauncher<Array<String>>
    private val CHANNEL = "com.example.movilidad_celulares/permissions"

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
        Octopulse.stop()


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
        else -> result.notImplemented()
    }
}

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
            Log.d("Permissions", "Permiso de ubicación en segundo plano no concedido")
            return
        }
    }

    Log.d("Permissions", "Todos los permisos ya fueron otorgados")
    permissionResultCallback?.success(true)
    permissionResultCallback = null

    requestIgnoreBatteryOptimization()
    registerDevice()
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
        val msisdn = "1000246915"
        if (!Octopulse.isDeviceRegistered()) {
            val phoneNumber = if (Octopulse.hasCarrierPrivileges()) null else msisdn
            Octopulse.registerDevice(this, phoneNumber, {
                Log.d("Octopulse", "Registro exitoso")
                Octopulse.start()
            }, { error ->
                Log.d("Octopulse", "Error al registrar: ${error?.message}")
            })
        } else {
            Log.d("Octopulse", "Ya estaba registrado")
            Octopulse.start()
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


}
