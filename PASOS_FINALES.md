# 🎯 PASOS FINALES PARA EMPEZAR

## ✅ Lo que ya está configurado:

1. ✅ **Config.dart** actualizado con IP `192.168.1.8:8000`
2. ✅ **ApiService** creado para peticiones HTTP
3. ✅ **TestConnectionButton** widget de prueba listo
4. ✅ **Laravel .env** actualizado con IP correcta
5. ✅ **Ruta de prueba** `/api/test` creada en Laravel
6. ✅ **Dependencia http** agregada a pubspec.yaml

---

## 🚀 AHORA HAZ ESTO (en orden):

### 1️⃣ Instalar la dependencia HTTP en Flutter

**OPCIÓN A - Desde VS Code:**

1. Abre una terminal en VS Code (`Ctrl + ñ`)
2. Navega a la carpeta de Flutter:
   ```powershell
   cd G:\Laravel\ProyectoAppDoctor\appdoctor
   ```
3. Si Flutter está instalado, ejecuta:
   ```powershell
   flutter pub get
   ```

**OPCIÓN B - Desde tu terminal de Flutter existente:**
Si ya tienes Flutter configurado en otra terminal/CMD, solo ejecuta:

```bash
flutter pub get
```

---

### 2️⃣ Iniciar el Backend Laravel

```powershell
# Navega al backend
cd G:\Laravel\ProyectoAppDoctor\back_doctor

# Inicia el servidor (CRÍTICO: usar --host 0.0.0.0)
php artisan serve --host 0.0.0.0 --port 8000
```

**Verifica que funciona:**
Abre tu navegador en: `http://192.168.1.8:8000`

---

### 3️⃣ Agregar el Widget de Prueba a tu App

Edita cualquier pantalla de tu app Flutter (por ejemplo, `main.dart` o la pantalla principal):

```dart
import 'package:appdoctor/widgets/test_connection_button.dart';

// Dentro de tu build method, agrega:
Column(
  children: [
    // ... tus widgets existentes
    TestConnectionButton(), // ← Agrega esto
  ],
)
```

**Ejemplo completo en main.dart:**

```dart
import 'package:flutter/material.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:appdoctor/widgets/test_connection_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppDoctor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Config.colorprimario),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Config.init(context); // Inicializa las dimensiones

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppDoctor - Test'),
        backgroundColor: Config.colorprimario,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              '🏥 AppDoctor',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Widget de prueba de conexión
            const TestConnectionButton(),

            // Tus otros widgets...
          ],
        ),
      ),
    );
  }
}
```

---

### 4️⃣ Ejecutar la App en tu Celular

```powershell
# Verifica que el dispositivo esté conectado
adb devices
# Debe mostrar: 192.168.1.6:5555    device

# Ejecuta Flutter (ajusta la ruta si Flutter está en otro lugar)
flutter run -d 192.168.1.6
```

---

### 5️⃣ Probar la Conexión

1. La app se abrirá en tu celular
2. Busca el botón **"Probar Conexión"**
3. Tócalo y deberías ver:
   - ✅ **Si funciona**: "¡Conexión exitosa!" con los datos del servidor
   - ❌ **Si falla**: Mensaje de error con troubleshooting

---

## 🐛 Si sale Error de Conexión:

### Error: "Connection refused" o timeout

**Causa**: El celular no puede alcanzar tu PC

**Soluciones:**

1. **Verifica que Laravel esté corriendo:**

   ```powershell
   # Abre http://192.168.1.8:8000 en TU NAVEGADOR de PC
   # Si no carga, Laravel no está corriendo
   ```

2. **Permite el puerto en el Firewall:**

   ```powershell
   # Ejecuta como Administrador:
   New-NetFirewallRule -DisplayName "Laravel Dev Server" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow
   ```

3. **Verifica la IP del PC:**

   ```powershell
   ipconfig
   # Busca tu IP en "Adaptador de Ethernet" o "Adaptador de LAN inalámbrica"
   # Debe ser 192.168.1.8
   ```

4. **Prueba desde el navegador del celular:**
   - Abre Chrome en tu Xiaomi
   - Ve a: `http://192.168.1.8:8000/api/test`
   - Deberías ver un JSON con el mensaje de éxito

---

## 📱 Usar con Scrcpy

```powershell
# Inicia Scrcpy para ver la pantalla del celular en tu PC
scrcpy

# Ahora puedes interactuar con la app desde tu PC
```

---

## 🎓 Usar GitHub Copilot

Ahora que todo está configurado, prueba esto en el Chat de Copilot:

```
@workspace Basándome en mi ApiService actual, ¿cómo implemento un formulario de login completo que guarde el token en SharedPreferences?
```

Copilot ya sabe:

- Tu IP es 192.168.1.8
- Usar ApiService en lugar de localhost
- Seguir tu estructura de Config.dart
- Que estás usando Sanctum en Laravel

---

## 📋 Archivos Creados/Modificados:

- ✅ `appdoctor/lib/utils/config.dart` - Configuración API
- ✅ `appdoctor/lib/services/api_service.dart` - Servicio HTTP
- ✅ `appdoctor/lib/services/auth_examples.dart` - Ejemplos de uso
- ✅ `appdoctor/lib/widgets/test_connection_button.dart` - Widget de prueba
- ✅ `appdoctor/pubspec.yaml` - Dependencia http agregada
- ✅ `back_doctor/.env` - IP actualizada
- ✅ `back_doctor/routes/api.php` - Ruta de prueba
- ✅ `.copilot-instructions.md` - Configuración de Copilot

---

## 🎯 Próximo paso

Una vez que veas **"¡Conexión exitosa!"** en tu app, ya puedes empezar a desarrollar las funcionalidades reales:

1. Sistema de autenticación (login/register)
2. Pantallas de gestión de citas médicas
3. Perfiles de doctores y pacientes
4. etc.

**¡Y Copilot te ayudará en todo el camino!** 🚀
