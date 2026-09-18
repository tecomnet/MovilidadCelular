package com.tecomnet.movilidad

import android.app.Activity
import android.content.Context
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.octolytics.octopulse.Octopulse

class MainActivity : FlutterFragmentActivity() {

    private companion object {
        const val TAG = "Octopulse"
        const val CHANNEL = "channelUpdateKPI"

        /**
         * Canal para ocultar pantallas con datos sensibles. Va aparte de
         * [CHANNEL] a propósito: no tiene nada que ver con el SDK de Octopulse.
         */
        const val CANAL_PANTALLA_SEGURA = "tecomnet/pantalla_segura"

        /**
         * Business Entity ID de TECOMNET. Valor fijo, no cambia.
         *
         * En el SDK 1.6.x se pasaba explícitamente a
         * `Octopulse.initialize(context, carrierId)`. Desde la 2.x esa
         * sobrecarga ya no existe: el backend lo resuelve a partir del
         * CLIENT_ID/CLIENT_KEY de android/octopulse-config.json y lo devuelve
         * como `brandExternalId` dentro de la entidad de negocio.
         *
         * Se conserva aquí como referencia y para contrastarlo en el
         * diagnóstico: si el backend alguna vez devuelve otra entidad, el log
         * lo delata.
         */
        const val BE_ID = "374"

        // Estados que devuelve startServiceOctolytics al lado Dart.
        const val ST_REGISTERING = "REGISTERING"
        const val ST_ALREADY_REGISTERED = "ALREADY_REGISTERED"
        const val ST_PERMISSIONS_MISSING = "PERMISSIONS_MISSING"
        const val ST_MSISDN_MISSING = "MSISDN_MISSING"
    }

    private var permissionResultCallback: MethodChannel.Result? = null
    private var isRequestingPermissions = false
    private var msisdn: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Pantalla de borde a borde en todas las versiones. Desde Android 15 es
        // obligatoria para apps con targetSdk >= 35; llamarla aquí da el mismo
        // comportamiento en versiones anteriores y es lo que Play Console pide.
        //
        // Va DESPUÉS de super.onCreate a propósito: FlutterFragmentActivity
        // reconfigura la ventana dentro de su onCreate (color de la barra de
        // estado y modo de pantalla) y, llamada antes, lo deshacía. Se comprobó
        // midiendo píxeles: con la llamada antes, la franja de la barra de
        // navegación seguía en negro.
        //
        // No tiene relación con el SDK de Octopulse.
        enableEdgeToEdge()
        // Octopulse.initialize() vive en OctolyticsApp.onCreate, que siempre
        // corre antes que esto. Aquí solo se activa el monitoreo.
        enableMonitoring()
    }

    private fun enableMonitoring() {
        if (!Octopulse.isMonitoringSettingEnabled()) {
            Octopulse.changeMonitoringSettingStatus(true)
        }
        if (BuildConfig.DEBUG) Log.d(TAG, "Monitoreo habilitado: ${Octopulse.isMonitoringSettingEnabled()}")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // FLAG_SECURE mientras hay datos de tarjeta en pantalla: Android no
        // guarda la miniatura en la vista de apps recientes y bloquea las
        // capturas y la grabación de pantalla. Lo activa y lo quita Dart al
        // entrar y salir de la pantalla, así que no afecta al resto de la app.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CANAL_PANTALLA_SEGURA)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "activar" -> {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        result.success(null)
                    }
                    "desactivar" -> {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // El SDK ya quedó inicializado en OctolyticsApp; esto solo
                    // confirma que el canal responde.
                    "initializeOctolytics" -> result.success("Ok")

                    // Pide permisos y responde SOLO cuando el usuario decidió.
                    // Antes respondía "Ok" de inmediato, así que Dart siempre
                    // creía que se habían concedido.
                    "validarPermisos" -> {
                        if (isRequestingPermissions) {
                            result.success(false)
                        } else {
                            permissionResultCallback = result
                            validatePermissions()
                        }
                    }

                    // Recibe el MSISDN real y recién entonces registra el
                    // dispositivo. Antes solo guardaba el número y no hacía nada,
                    // por lo que el registro ya había ocurrido sin él.
                    "startServiceOctolytics" -> {
                        msisdn = call.argument<String>("arg")?.trim().orEmpty()
                        result.success(iniciarMonitoreo())
                    }

                    "hasCarrierPrivileges" -> result.success(Octopulse.hasCarrierPrivileges())

                    "launchActivity" -> {
                        if (Octopulse.isDeviceRegistered()) {
                            Octopulse.launchHelpActivity(this)
                        } else {
                            Octopulse.launchAddMsisdnActivity(this, null)
                        }
                        result.success("Ok")
                    }

                    "launchHelpActivity" -> {
                        if (BuildConfig.DEBUG) Log.d(TAG, "Lanzando HelpActivity")
                        Octopulse.launchHelpActivity(this)
                        result.success("HelpActivity launched")
                    }

                    "launchAddMsisdnActivity" -> {
                        if (BuildConfig.DEBUG) Log.d(TAG, "Lanzando AddMsisdnActivity")
                        Octopulse.launchAddMsisdnActivity(this)
                        result.success("AddMsisdnActivity launched")
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ---------- permisos ----------

    private fun validatePermissions() {
        if (Octopulse.hasMinimumPermissionsGranted(this)) {
            if (BuildConfig.DEBUG) Log.d(TAG, "Permisos mínimos ya concedidos")
            responderPermisos(true)
            return
        }
        if (BuildConfig.DEBUG) Log.d(TAG, "Permisos mínimos ausentes; abriendo la actividad del SDK")
        isRequestingPermissions = true
        Octopulse.startPermissionsActivity(this, permissionsActivityResultContract)
    }

    private fun responderPermisos(granted: Boolean) {
        permissionResultCallback?.success(granted)
        permissionResultCallback = null
    }

    val permissionsActivityResultContract = registerForActivityResult(
        androidx.activity.result.contract.ActivityResultContracts.StartActivityForResult()
    ) { activityResult ->
        isRequestingPermissions = false
        // El resultCode del SDK no siempre refleja el estado final; se consulta
        // el permiso real en vez de confiar en RESULT_OK.
        val granted = Octopulse.hasMinimumPermissionsGranted(this)
        if (BuildConfig.DEBUG) Log.d(
            TAG,
            "Permisos tras la actividad del SDK: $granted (resultCode=${activityResult.resultCode})"
        )
        if (!granted && activityResult.resultCode != Activity.RESULT_OK) {
            if (BuildConfig.DEBUG) Log.d(TAG, "El usuario no concedió los permisos mínimos")
        }
        responderPermisos(granted)
    }

    // ---------- registro y arranque ----------

    /**
     * Registra el dispositivo y arranca el monitoreo. Se invoca desde
     * startServiceOctolytics, es decir, cuando el MSISDN ya se conoce.
     */
    /**
     * Lee el brandExternalId que el backend resolvió, para contrastarlo con
     * [BE_ID]. Depende de una clave interna del SDK, así que es exclusivamente
     * para diagnóstico: nunca debe influir en el comportamiento de la app.
     */
    private fun brandExternalIdResuelto(): String? = runCatching {
        getSharedPreferences("${packageName}_preferences", Context.MODE_PRIVATE)
            .getString("data_business_entity_items", null)
            ?.let {
                Regex("\"brandExternalId\"\\s*:\\s*\"([^\"]+)\"")
                    .find(it)?.groupValues?.get(1)
            }
    }.getOrNull()

    /** Vuelca el estado completo del SDK para poder diagnosticar por logcat. */
    private fun logDiagnostico(momento: String) {
        if (BuildConfig.DEBUG) Log.d(TAG, "── diagnóstico ($momento) ──")
        val beResuelto = brandExternalIdResuelto()
        if (BuildConfig.DEBUG) Log.d(TAG, "  BEid esperado        : $BE_ID (TECOMNET)")
        if (BuildConfig.DEBUG) Log.d(TAG, "  BEid resuelto        : ${beResuelto ?: "<aún no disponible>"}")
        if (beResuelto != null && beResuelto != BE_ID) {
            if (BuildConfig.DEBUG) Log.e(TAG, "  ⚠ El backend devolvió la entidad $beResuelto, se esperaba $BE_ID")
        }
        if (BuildConfig.DEBUG) Log.d(TAG, "  msisdn recibido      : '$msisdn' (largo=${msisdn.length})")
        if (BuildConfig.DEBUG) Log.d(TAG, "  msisdn es numérico   : ${msisdn.isNotEmpty() && msisdn.all { it.isDigit() }}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  permisos mínimos     : ${Octopulse.hasMinimumPermissionsGranted(this)}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  dispositivo registrado: ${Octopulse.isDeviceRegistered()}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  SDK arrancado        : ${Octopulse.isSdkStarted()}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  privilegios operador : ${Octopulse.hasCarrierPrivileges()}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  monitoreo habilitado : ${Octopulse.isMonitoringSettingEnabled()}")
        if (BuildConfig.DEBUG) Log.d(TAG, "  serial de SIM        : ${runCatching { Octopulse.getSimSerial() }.getOrNull()}")
        // El SDK puede resolver el MSISDN desde la propia SIM; sirve para saber
        // si el número que manda el backend coincide con el de la línea.
        runCatching {
            Octopulse.getMsisdnBySim(
                { desdeSim ->
                    if (BuildConfig.DEBUG) {
                        Log.d(TAG, "  msisdn según la SIM  : $desdeSim")
                    }
                },
                { e ->
                    if (BuildConfig.DEBUG) {
                        Log.d(TAG, "  msisdn según la SIM  : error -> ${e?.message}")
                    }
                }
            )
        }
        if (BuildConfig.DEBUG) Log.d(TAG, "───────────────────────────")
    }

    private fun iniciarMonitoreo(): String {
        if (BuildConfig.DEBUG) logDiagnostico("antes de registrar")

        if (!Octopulse.hasMinimumPermissionsGranted(this)) {
            if (BuildConfig.DEBUG) Log.d(TAG, "Sin permisos mínimos; no se registra el dispositivo")
            return ST_PERMISSIONS_MISSING
        }

        if (Octopulse.isDeviceRegistered()) {
            if (BuildConfig.DEBUG) Log.d(TAG, "Dispositivo ya registrado; arrancando monitoreo")
            Octopulse.start()
            return ST_ALREADY_REGISTERED
        }

        val tienePrivilegios = Octopulse.hasCarrierPrivileges()
        if (!tienePrivilegios && msisdn.isBlank()) {
            // Sin privilegios de operador el SDK no puede deducir el número, y
            // registrarse con null dejaría el dispositivo sin MSISDN de forma
            // permanente. Se pospone hasta tener el dato.
            if (BuildConfig.DEBUG) Log.d(TAG, "Sin MSISDN y sin privilegios de operador; registro pospuesto")
            return ST_MSISDN_MISSING
        }

        registerDevice(if (tienePrivilegios) null else msisdn)
        return ST_REGISTERING
    }

    private fun registerDevice(phoneNumber: String?) {
        if (BuildConfig.DEBUG) Log.d(TAG, "Registrando dispositivo (msisdn=${phoneNumber ?: "<privilegios de operador>"})")
        Octopulse.registerDevice(this, phoneNumber, {
            if (BuildConfig.DEBUG) Log.d(TAG, "Registro exitoso; arrancando monitoreo")
            Octopulse.start()
            if (BuildConfig.DEBUG) logDiagnostico("después de registrar")
        }, { error ->
            // El tipo del error importa: MsisdnValidation significa que el SDK
            // rechazó el formato del número, no que falle la red.
            if (BuildConfig.DEBUG) Log.e(TAG, "Error al registrar dispositivo")
            if (BuildConfig.DEBUG) Log.e(TAG, "  tipo    : ${error?.javaClass?.name}")
            if (BuildConfig.DEBUG) Log.e(TAG, "  mensaje : ${error?.message}")
            if (BuildConfig.DEBUG) logDiagnostico("tras el fallo de registro")
        })
    }
}
