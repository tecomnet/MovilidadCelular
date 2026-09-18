# Movilidad Celulares

App de autoservicio para clientes de telefonía móvil de TECOMNET (`com.tecomnet.movilidad`).
Desde la app el cliente consulta sus líneas y su consumo, recarga, renueva o cambia de plan,
revisa su historial de recargas, administra sus tarjetas guardadas y corre el diagnóstico de red.

Hecha en Flutter. Se publica para **Android**; la carpeta `ios/` existe, pero el SDK de
diagnóstico (Octopulse) solo está disponible en Android.

El backend vive en **otro repositorio**. Los contratos del API están en
[docs/API-Contratos-y-Migracion.md](docs/API-Contratos-y-Migracion.md).

## Requisitos

- Flutter **3.32.2** (canal stable)
- Android SDK con `compileSdk 36`. La app pide Android 10 como mínimo (`minSdk 29`), porque lo exige el SDK de Octopulse.
- JDK 17

## Correr la app

```bash
flutter pub get
flutter run
```

La primera compilación descarga el SDK de Octopulse desde JitPack, con el token de
`android/gradle.properties`.

## Ambiente (pruebas o producción)

La URL del API se elige en **un solo lugar**: [lib/config/ambiente.dart](lib/config/ambiente.dart).

```dart
static const bool produccion = false;   // false = pruebas, true = producción
```

Para apuntar a producción, pega la URL que entregue backend en `_apiProduccion` y cambia
`produccion` a `true`. Si `_apiProduccion` está vacía, ninguna llamada funciona.

## Publicar en Google Play

1. Sube el número después del `+` en `version:` de `pubspec.yaml`. Play rechaza un `versionCode` repetido.
2. Compila el paquete firmado:

   ```bash
   flutter build appbundle --release
   ```

   El resultado queda en `build/app/outputs/bundle/release/app-release.aab`.

El keystore de firma (`android/app/KeyTecomnetMovil.jks`) **no está en el repositorio**: se
pide a quien administra la cuenta de Play. Sin él no se puede compilar en release.

## Estructura de `lib/`

| Carpeta | Qué hay |
|---|---|
| `config/` | Ambiente del API (pruebas o producción). |
| `screens/` | Una pantalla por archivo: login, inicio, recargar, actualizar plan, mis recargas, mis tarjetas, perfil… |
| `services/` | Llamadas al API (`api_service.dart`), flujo de cobro (`payment_flow.dart`), claves de idempotencia y el modelo de tarjetas. |
| `widgets/` | Piezas reutilizables: el armazón con menú lateral, tarjetas de línea y de oferta, el WebView de pago. |
| `utils/` | Enums del API, sesión, permisos, bloqueo de capturas de pantalla y reconocimiento de las páginas de retorno del pago. |
| `theme/` | Colores y estilos de la marca. |
| `call_native_code.dart` | Puente con el SDK de Octopulse, que corre en Kotlin (`MainActivity.kt`). |

## Pruebas

```bash
flutter test
```

## Cosas que conviene saber

- **El token dura 60 minutos y no se renueva.** Cuando vence, el API responde 401 y la app cierra la sesión y vuelve al login con un aviso.
- **El pago se hace en la página de SinergyPay**, dentro de un WebView. La app no ve ni el número de tarjeta ni el importe. Sabe que terminó cuando la pasarela redirige a `/pago-exitoso` o `/pago-error` (ver `utils/retorno_pago.dart`).
- **Los datos de tarjeta nunca se trazan**, ni siquiera en depuración, y la pantalla de agregar tarjeta no se puede capturar.
- **Los `debugPrint` van dentro de `if (kDebugMode)`** en las llamadas, no en una función aparte. Así el compilador los quita de la versión publicada. Mantener ese patrón.
