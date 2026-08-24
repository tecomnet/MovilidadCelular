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
import android.app.Activity

class MainActivity : FlutterFragmentActivity() {

    
    private lateinit var permissionResultLauncher: ActivityResultLauncher<Array<String>>
    private val CHANNEL = "com.tecomnet.movilidad_celulares/permissions"

    private var permissionResultCallback: MethodChannel.Result? = null
    private var isRequestingPermissions = false

    private lateinit var channel: MethodChannel
    private var msisdn: String = ""
    private var BEid: String = "374"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Octopulse.initialize(application)
        enableMonitoring()

        permissionResultLauncher = registerForActivityResult(
    ActivityResultContracts.RequestMultiplePermissions()
) { permissions ->
            val allGranted = permissions.all { it.value }
            if (allGranted) {
                Log.d("Permissions", "Permisos mínimos otorgados (callback)")
                if (!Octopulse.isDeviceRegistered()) {
                    if (msisdn.isNotEmpty()) {
                        registerDevice(msisdn)
                    } else {
                        registerDevice()
                    }
                } else {
                    Octopulse.start()
                }
                permissionResultCallback?.success(true)
            } else {
                Log.d("Permissions", "Permisos mínimos NO otorgados (callback)")
                permissionResultCallback?.success(false)
            }
            permissionResultCallback = null
            isRequestingPermissions = false
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
            when (call.method) {
                "pedirPermisos" -> {
                    if (isRequestingPermissions) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    permissionResultCallback = result
                    validatePermissions()
                }
                
                else -> result.notImplemented()
            }
        }

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "channelUpdateKPI")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeOctolytics" -> {
                    result.success("Ok")
                }
                "startServiceOctolytics" -> {
                    val hasPrivileges = Octopulse.hasCarrierPrivileges()
                    Log.d("Octopulse", "¿Tiene privilegios de operador?: $hasPrivileges")
                    val phone = call.argument<String>("arg") ?: ""
                    msisdn = phone
                    result.success("Ok")
                }
                "validarPermisos" -> {
                    validatePermissions()
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
        if (Octopulse.hasMinimumPermissionsGranted(this)) {
            if (msisdn.isNotEmpty()) {
                registerDevice(msisdn)
            } else {
                registerDevice()
            }
            permissionResultCallback?.success(true)
            permissionResultCallback = null
        } else {
            Log.d("Permissions", "Permisos NO otorgados. Solicitando permisos...")
            isRequestingPermissions = true
            Octopulse.startPermissionsActivity(this, permissionsActivityResultContract)        }
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
            val phoneNumber = if (Octopulse.hasCarrierPrivileges()) null else argPhone.takeIf { it.isNotBlank() }
            Octopulse.registerDevice(this, phoneNumber, {
                Log.d("Octopulse", "Registro exitoso")
                Octopulse.start()
            }, { error ->
                Log.d("Octopulse", "Error al registrar dispositivo: ${error?.message}")
            })
        } else {
            Log.d("Octopulse", "Dispositivo ya registrado")
            Octopulse.start()
            continueToApp()
        }
    }

    @SuppressLint("NewApi")
    private fun continueToApp() {
        Log.d("Octopulse", "Continuando sin abrir actividades del SDK")
    }

    private fun openPermissionActivity() {
        Log.d("Octopulse", "Abriendo actividad de permisos...")
        Octopulse.launchPermissionActivity(this)
    }

     val permissionsActivityResultContract = registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val msisdn = this.msisdn
            Log.v("LOG", "registerForActivityResult: " + msisdn)
            registerDevice(msisdn)
            Log.d("Permissions grant", "permissions")
        } else {
            Log.d("Permissions error", "Missing permissions ${result.resultCode}")
        }
    }
}
