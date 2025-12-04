# Rama SQLite-Linux - ProyectoAppDoctor

## 📋 Descripción
Esta rama está configurada específicamente para desarrollo local en Linux usando **SQLite** como base de datos, eliminando la necesidad de configurar MySQL u otros servicios de base de datos externos.

## 🔄 Cambios Realizados

### Backend (Laravel)
1. **Base de datos configurada a SQLite**
   - Archivo: `back_doctor/.env`
   - Configuración: `DB_CONNECTION=sqlite`
   - Archivo de BD creado: `back_doctor/database/database.sqlite`

2. **Variables de entorno comentadas**
   - Las variables de MySQL han sido comentadas en `.env`
   - No se requiere configuración de host, puerto, usuario ni contraseña

### Frontend (Flutter)
1. **URL de API actualizada para localhost**
   - Archivo: `appdoctor/lib/utils/config.dart`
   - API URL: `http://localhost:8000/api`
   - No requiere configuración de IP de red

## 🚀 Inicio Rápido

### Requisitos Previos
- PHP >= 8.1
- Composer
- Flutter SDK
- Extensión SQLite para PHP (generalmente viene por defecto)

### Pasos de Instalación

#### Backend
```bash
cd back_doctor

# Instalar dependencias
composer install

# Generar key de aplicación
php artisan key:generate

# Ejecutar migraciones (crea las tablas en SQLite)
php artisan migrate

# Opcional: Seeders
php artisan db:seed

# Iniciar servidor
php artisan serve
```

El backend estará disponible en: `http://localhost:8000`

#### Frontend
```bash
cd appdoctor

# Instalar dependencias
flutter pub get

# Ejecutar app (Linux desktop)
flutter run -d linux

# O para desarrollo web
flutter run -d chrome
```

## 📝 Notas Importantes

### Ventajas de SQLite en esta rama:
- ✅ Sin necesidad de instalar MySQL/MariaDB
- ✅ Sin configuración de puertos
- ✅ Sin gestión de usuarios de BD
- ✅ Desarrollo local más simple
- ✅ Base de datos en un solo archivo
- ✅ Ideal para desarrollo y pruebas

### Limitaciones:
- ⚠️ No apto para producción con múltiples usuarios concurrentes
- ⚠️ Limitaciones en consultas concurrentes
- ⚠️ Para producción, usar MySQL/PostgreSQL

### Archivo de Base de Datos:
La base de datos SQLite se encuentra en:
```
back_doctor/database/database.sqlite
```

Puedes explorarla con herramientas como:
- DB Browser for SQLite
- DBeaver
- VS Code con extensión SQLite

## 🔀 Diferencias con la Rama Principal

| Característica | Rama Main | Rama sqlite-linux |
|---------------|-----------|-------------------|
| Base de datos | MySQL | SQLite |
| Configuración de BD | Requiere host, puerto, usuario | Solo archivo local |
| URL de API | IP de red (192.168.x.x) | localhost |
| Ideal para | Producción / Red local | Desarrollo local |

## 🛠️ Comandos Útiles

### Laravel
```bash
# Ver estado de migraciones
php artisan migrate:status

# Revertir última migración
php artisan migrate:rollback

# Resetear BD completa
php artisan migrate:fresh

# Con seeders
php artisan migrate:fresh --seed

# Limpiar caché
php artisan cache:clear
php artisan config:clear
```

### Flutter
```bash
# Limpiar proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Analizar código
flutter analyze

# Ver dispositivos disponibles
flutter devices
```

## 🔄 Volver a MySQL

Si necesitas volver a usar MySQL, simplemente:

1. Edita `back_doctor/.env`:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=back_doctor
DB_USERNAME=root
DB_PASSWORD=tu_password
```

2. Edita `appdoctor/lib/utils/config.dart`:
```dart
static const String apiBaseUrl = '192.168.x.x:8000';
```

## 📧 Soporte

Para cualquier problema con esta configuración, verifica:
1. Que PHP tenga la extensión SQLite habilitada: `php -m | grep sqlite`
2. Que el archivo `database.sqlite` tenga permisos de escritura
3. Que el servidor Laravel esté corriendo en puerto 8000

---

**Rama creada para:** Desarrollo local simple en Linux sin configuración de red ni servicios de BD externos.
