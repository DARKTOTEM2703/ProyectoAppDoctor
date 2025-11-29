# AppDoctor - Guía de Configuración de IP Local

## 📍 Configuración Actual

```
PC (Backend):     192.168.1.8
Celular (App):    192.168.1.6
```

## 📝 Pasos para Cambiar la IP

### 1. Encontrar tu IP actual

```powershell
ipconfig
```

Busca "Adaptador de Ethernet" o "Adaptador de LAN inalámbrica" con IPv4

### 2. Actualizar IP en Flutter

Edita `appdoctor/lib/utils/config.dart`:

```dart
static const String apiBaseUrl = '192.168.1.8:8000'; // ← Cambia 8 por tu IP
```

### 3. Actualizar IP en Laravel

Edita `back_doctor/.env`:

```env
APP_URL=http://192.168.1.8:8000  # ← Cambia 8 por tu IP
```

### 4. Reiniciar servicios

```bash
# Flutter - Presiona 'r' en la consola o reconstruye

# Laravel - Reinicia el servidor
php artisan serve --host 0.0.0.0
```

## 🔧 Configuración por Defecto en .env

```env
APP_NAME=AppDoctor
APP_ENV=local
APP_KEY=base64:wjbwV+WVQ5EmPTKLmv/Iz0Vx+/hQzDr645nAyzK7mvU=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://192.168.1.8:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=appdoctor
DB_USERNAME=root
DB_PASSWORD=""
```

## 📱 Conectar Dispositivo Físico

```powershell
# Ver IP del dispositivo
adb devices

# Conectar por WiFi
adb tcpip 5555
adb connect 192.168.1.6

# Verificar conexión
adb devices
```

## ✅ Checklist

- [ ] Actualizar IP en `config.dart`
- [ ] Actualizar IP en `.env` de Laravel
- [ ] Permitir puerto 8000 en Firewall
- [ ] Laravel corriendo con `--host 0.0.0.0`
- [ ] Flutter pub get ejecutado
- [ ] Dispositivo conectado por ADB
- [ ] Probar conexión con test button
