# TECOMNET CONECTA

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

Todo lo que cambia entre ambientes vive en **un solo archivo**:
[lib/config/ambiente.dart](lib/config/ambiente.dart). Son tres datos por ambiente —la URL del
API, y el usuario y la contraseña de la cuenta de servicio— y un interruptor:

```dart
static const bool produccion = false;   // false = pruebas · true = producción
```

| | Servidor |
|---|---|
| Pruebas | `https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io` |
| Producción | `https://ca-movilidad-prod-api.wonderfulground-31c63143.centralus.azurecontainerapps.io` |

Las rutas (`/api/Account`, `/api/Cliente/Login`, `/api/cobros/tarjetas/...`) son iguales en los
dos. Lo que cambia es el servidor, y **cada uno tiene sus propias credenciales**: las de
producción dan 401 contra el servidor de pruebas y al revés.

**Cómo saber a dónde está apuntando.** Al arrancar en depuración, la consola lo dice:

```
🌐 Ambiente: pruebas → https://ca-movilidad-dev-api...
🌐 Ambiente: PRODUCCIÓN → https://ca-movilidad-prod-api...
```

Si se marca producción con alguno de los tres datos vacío, la app corta al arrancar con un
mensaje que lo explica. En la versión publicada no se escribe nada de esto.

**Trabajo diario: `produccion = false`.** Las pruebas se hacen contra dev, donde las tarjetas
de prueba y las ofertas de $1 no cobran dinero real. En producción una recarga cobra de verdad
y una tarjeta guardada es una tarjeta real.

## Publicar en Google Play

El interruptor de ambiente **se cambia a mano**, así que este orden importa. Saltarse el
paso 2 significa publicar la app apuntando al servidor de pruebas, y nadie se daría cuenta
hasta que un cliente reclame.

1. **Prueba el cambio en dev** (`produccion = false`) hasta que funcione.
2. **Cambia `produccion` a `true`** en [lib/config/ambiente.dart](lib/config/ambiente.dart).
3. **Súbelo en `pubspec.yaml`**: el número después del `+` en `version:`. Play rechaza un
   `versionCode` repetido.
4. **Compila el paquete firmado:**

   ```bash
   flutter build appbundle --release
   ```

   Queda en `build/app/outputs/bundle/release/app-release.aab`.

5. **Regresa `produccion` a `false`** en cuanto termine la compilación, antes de seguir
   trabajando. Así el repositorio siempre queda en pruebas y producción solo existe durante
   el build.
6. **Sube el AAB al canal de Pruebas internas** de Play Console, no directo a producción.
   Llega por Play a los correos que agregues, ya firmado por Google e instalado como lo
   instalaría un cliente.
7. **Pruébalo instalado**: iniciar sesión, ver las líneas, una recarga. Si todo está bien,
   **promueve** ese mismo AAB a producción desde Play Console, sin recompilar. Si algo falla,
   no lo promueves y ningún cliente se enteró.

El keystore de firma (`android/app/KeyTecomnetMovil.jks`) **no está en el repositorio**: se
pide a quien administra la cuenta de Play. Sin él no se puede compilar en release.

### Probar contra producción desde la computadora

Si el cambio depende de datos reales, se puede mirar producción antes de publicar: pon
`produccion = true`, corre `flutter run`, confirma en la consola que dice PRODUCCIÓN, y
**solo mira** —no hagas pagos, ahí se cobra de verdad—. Al terminar, regrésalo a `false`.

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
