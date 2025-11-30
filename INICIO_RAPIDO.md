# 🚀 Guía de Inicio Rápido - AppDoctor

## 📱 Dispositivo conectado

- **Celular**: Xiaomi Redmi M2101K7BL (192.168.1.6)
- **PC**: 192.168.1.8
- **Conexión**: ADB + Scrcpy

---

## ⚡ Pasos para Levantar el Entorno

### 1️⃣ Iniciar Backend Laravel

```powershell
# Navega al directorio del backend
cd G:\Laravel\ProyectoAppDoctor\back_doctor

# Inicia el servidor (IMPORTANTE: --host 0.0.0.0 para acceso desde red local)
php artisan serve --host 0.0.0.0 --port 8000
```

**Verificación**: Abre en tu navegador `http://192.168.1.8:8000` - Deberías ver la página de Laravel

---

### 2️⃣ Instalar Dependencias de Flutter

```powershell
# Navega al directorio de Flutter
cd G:\Laravel\ProyectoAppDoctor\appdoctor

# Instala dependencias (incluye el paquete http recién agregado)
flutter pub get
```

---

### 3️⃣ Conectar y Ejecutar en el Dispositivo

```powershell
# Verifica que el dispositivo esté conectado
adb devices
# Deberías ver: 192.168.1.6:5555    device

# Ejecuta la app en el dispositivo
flutter run -d 192.168.1.6

# Opcional: Inicia Scrcpy para ver la pantalla en tu PC
scrcpy
```

---

## 🧪 Prueba de Conexión

### Opción A: Desde el navegador del celular

1. Abre el navegador en tu celular
2. Ve a: `http://192.168.1.8:8000`
3. Si ves la página de Laravel, ¡la conexión funciona! ✅

### Opción B: Test de API desde Flutter

Crea un botón de prueba en tu app:

```dart
import 'package:appdoctor/services/api_service.dart';

ElevatedButton(
  onPressed: () async {
    try {
      final response = await ApiService.get('test'); // Crea esta ruta en Laravel
      print('¡Conexión exitosa!: $response');
    } catch (e) {
      print('Error de conexión: $e');
    }
  },
  child: Text('Probar Conexión API'),
)
```

---

## 🛠️ Troubleshooting

### ❌ "Connection refused" o "Failed to connect"

**Solución 1**: Verifica el Firewall de Windows

```powershell
# Permite el puerto 8000 en Windows Firewall
New-NetFirewallRule -DisplayName "Laravel Dev Server" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow
```

**Solución 2**: Verifica que Laravel esté corriendo

```powershell
# En otra terminal, verifica:
netstat -an | findstr :8000
# Deberías ver: TCP    0.0.0.0:8000    LISTENING
```

**Solución 3**: Verifica la IP en Config.dart

```dart
// Debe ser 192.168.1.8, NO localhost
static const String apiBaseUrl = '192.168.1.8:8000';
```

### ❌ "No devices found"

```powershell
# Reconecta el dispositivo
adb tcpip 5555
adb connect 192.168.1.6
```

### ❌ CORS Error en peticiones

Edita `back_doctor/config/cors.php`:

```php
'paths' => ['api/*'],
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

---

## 📋 Checklist de Configuración

- [x] Backend Laravel configurado con IP 192.168.1.8
- [x] Config.dart actualizado con apiBaseUrl
- [x] ApiService creado para peticiones HTTP
- [x] Dependencia `http` agregada a pubspec.yaml
- [ ] Base de datos MySQL corriendo (si se necesita)
- [ ] Rutas de API creadas en routes/api.php
- [ ] Modelos y controladores de Laravel listos

---

## 🎯 Próximos Pasos

1. **Crear rutas de autenticación en Laravel**:

   ```php
   // routes/api.php
   Route::post('/login', [AuthController::class, 'login']);
   Route::post('/register', [AuthController::class, 'register']);
   ```

2. **Implementar pantalla de login en Flutter**:

   ```dart
   // Usar auth_examples.dart como referencia
   await ApiService.post('login', {...});
   ```

3. **Configurar Sanctum para tokens de autenticación**

4. **Crear modelos de datos (Doctor, Patient, Appointment, etc.)**

---

## 💡 Comandos Útiles

```powershell
# Flutter
flutter clean                    # Limpia build
flutter pub get                  # Instala dependencias
flutter run -d 192.168.1.6      # Corre en dispositivo
flutter doctor                  # Verifica instalación

# Laravel
php artisan route:list          # Ver todas las rutas
php artisan migrate             # Ejecutar migraciones
php artisan db:seed             # Poblar BD
php artisan tinker              # REPL de Laravel

# ADB
adb devices                     # Listar dispositivos
adb logcat                      # Ver logs de Android
adb shell                       # Acceder al shell del dispositivo
```

---

## 📞 Soporte

Si encuentras algún error, revisa:

1. Los logs de Laravel: `back_doctor/storage/logs/laravel.log`
2. Los logs de Flutter: En la consola donde corriste `flutter run`
3. Los logs de Android: `adb logcat`

**GitHub Copilot está configurado para ayudarte** - Usa `@workspace` cuando le preguntes algo! 🤖
