# 🏥 AppDoctor - Aplicación Médica Full Stack

Una aplicación médica moderna desarrollada con **Flutter** (Mobile) y **Laravel** (Backend API), diseñada para conectar pacientes con doctores especializados.

## 📱 Demo

**Dispositivo de Prueba:**

- Xiaomi Redmi M2101K7BL (Android 13)
- Conexión: WiFi local (192.168.1.6)
- Control: Scrcpy + ADB

---

## 🏗️ Arquitectura

```
ProyectoAppDoctor/
├── appdoctor/              # Frontend - Flutter
│   ├── lib/
│   │   ├── screens/        # Pantallas principales
│   │   ├── components/     # Componentes reutilizables
│   │   ├── services/       # Servicios (API, etc.)
│   │   ├── utils/          # Configuración global
│   │   └── widgets/        # Widgets personalizados
│   └── pubspec.yaml        # Dependencias de Flutter
│
├── back_doctor/            # Backend - Laravel
│   ├── app/
│   │   ├── Http/Controllers/  # Controladores (Auth, Doctor, etc.)
│   │   ├── Models/            # Modelos de BD (User, Doctor, etc.)
│   │   └── Providers/         # Service Providers
│   ├── database/
│   │   └── migrations/        # Migraciones de base de datos
│   ├── routes/
│   │   └── api.php            # Rutas de API
│   └── .env                   # Variables de entorno
│
└── README.md               # Este archivo
```

---

## 🚀 Funcionalidades

### ✅ Frontend (Flutter)

- **Autenticación**: Login y registro de usuarios
- **Pantalla de Inicio**: Listado de doctores por especialidad
- **Detalles de Doctor**: Información completa del profesional
- **Sistema de Citas**: Reserva de citas médicas con calendario
- **Gestión de Citas**: Ver citas próximas y completadas
- **Interfaz Responsiva**: Adaptada a diferentes tamaños de pantalla

### ✅ Backend (Laravel)

- **API RESTful**: Endpoints para autenticación y gestión de doctores
- **Autenticación Sanctum**: Tokens seguros para sesiones
- **CRUD de Doctores**: Crear, leer, actualizar, eliminar doctores
- **Sistema de Citas**: Gestionar reservaciones de pacientes
- **Validación de Datos**: Validación en servidor
- **Manejo de Errores**: Respuestas JSON consistentes

---

## 🛠️ Tecnologías

| Componente    | Tecnología      | Versión |
| ------------- | --------------- | ------- |
| **Frontend**  | Flutter         | 3.5.4+  |
| **Mobile OS** | Android         | 13+     |
| **Backend**   | Laravel         | 11.x    |
| **Database**  | MySQL           | 5.7+    |
| **Auth**      | Laravel Sanctum | Latest  |
| **HTTP**      | Dart http       | 1.2.0+  |

---

## 📋 Requisitos Previos

### Para Frontend (Flutter)

- Flutter 3.5.4 o superior
- Android SDK
- Dispositivo físico Android o emulador
- ADB (Android Debug Bridge)

### Para Backend (Laravel)

- PHP 8.2 o superior
- Composer
- MySQL/MariaDB
- Node.js (para assets)

---

## 🔧 Instalación y Setup

### 1. Clonar el repositorio

```bash
git clone https://github.com/DARKTOTEM2703/ProyectoAppDoctor.git
cd ProyectoAppDoctor
```

### 2. Configurar Backend (Laravel)

```bash
cd back_doctor

# Instalar dependencias PHP
composer install

# Copiar .env
cp .env.example .env

# Generar clave
php artisan key:generate

# Ejecutar migraciones
php artisan migrate

# (Opcional) Seed datos de prueba
php artisan db:seed

# Instalar dependencias de front-end
npm install && npm run build
```

**Configurar variables en `.env`:**

```env
APP_URL=http://192.168.1.8:8000
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=appdoctor
DB_USERNAME=root
DB_PASSWORD=
```

### 3. Configurar Frontend (Flutter)

```bash
cd appdoctor

# Instalar dependencias
flutter pub get

# Verificar setup
flutter doctor

# Correr en dispositivo
flutter run -d 192.168.1.6
```

---

## 🚀 Ejecutar la Aplicación

### Iniciar Backend

```bash
cd back_doctor
php artisan serve --host 0.0.0.0 --port 8000
```

**Verificar**: Abre `http://192.168.1.8:8000/api/test` en el navegador

### Iniciar Frontend

```bash
cd appdoctor
flutter run -d 192.168.1.6
```

---

## 📡 API Endpoints

### Rutas Públicas (Sin autenticación)

```
POST   /api/register              # Registrar usuario
POST   /api/login                 # Login de usuario
GET    /api/test                  # Test de conexión
GET    /api/doctors               # Listar todos los doctores
GET    /api/doctors/{id}          # Detalles de un doctor
GET    /api/doctors/specialty/{specialty}  # Filtrar por especialidad
```

### Rutas Protegidas (Requieren token Sanctum)

```
GET    /api/user                  # Datos del usuario autenticado
POST   /api/logout                # Logout
POST   /api/doctors               # Crear doctor (admin)
PUT    /api/doctors/{id}          # Actualizar doctor (admin)
DELETE /api/doctors/{id}          # Eliminar doctor (admin)
```

### Ejemplo de Request

```bash
# Login
curl -X POST http://192.168.1.8:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "usuario@example.com",
    "password": "password123"
  }'

# Respuesta exitosa
{
  "success": true,
  "message": "Login exitoso",
  "access_token": "1|xxxxxxxxxxxx",
  "token_type": "Bearer",
  "user": {
    "id": 1,
    "name": "Juan Pérez",
    "email": "usuario@example.com"
  }
}
```

---

## 🔐 Autenticación

La app usa **Laravel Sanctum** para autenticación basada en tokens.

### Flujo de Login

1. Usuario ingresa email y contraseña
2. Flutter envía a `/api/login`
3. Laravel valida credenciales
4. Si es correcto, genera token y lo devuelve
5. Flutter guarda el token (en SharedPreferences o secure_storage)
6. Futuras peticiones incluyen: `Authorization: Bearer {token}`

### Ejemplo en Flutter

```dart
// Login
final response = await ApiService.post('login', {
  'email': 'user@example.com',
  'password': 'password123',
});

final token = response['access_token'];
// Guardar token...

// Petición autenticada
final userData = await ApiService.get('user', token: token);
```

---

## 📁 Estructura de Carpetas

### Flutter (`appdoctor/lib/`)

```
lib/
├── main.dart                 # Punto de entrada
├── main_layout.dart         # Layout principal con navegación
├── auth_page.dart           # Pantalla de autenticación
├── screens/                 # Pantallas de la app
│   ├── Home_page.dart
│   ├── doctor_details.dart
│   ├── appointment_page.dart
│   └── success_booking.dart
├── components/              # Componentes reutilizables
│   ├── boton.dart
│   ├── login_forms.dart
│   ├── doctor_card.dart
│   └── booking_page.dart
├── services/                # Servicios
│   ├── api_service.dart     # Servicio HTTP centralizado
│   └── auth_examples.dart   # Ejemplos de uso
├── utils/                   # Configuración
│   ├── config.dart          # Colores, dimensiones, API
│   └── text.dart            # Textos multiidioma
└── widgets/                 # Widgets personalizados
    └── test_connection_button.dart
```

### Laravel (`back_doctor/`)

```
app/
├── Http/
│   └── Controllers/
│       ├── AuthController.php    # Autenticación
│       ├── DoctorController.php  # Gestión de doctores
│       └── AppointmentController.php (TODO)
├── Models/
│   ├── User.php
│   ├── Doctor.php
│   └── Appointment.php (TODO)
└── Providers/

database/
├── migrations/
│   ├── 2025_11_29_000000_create_doctors_table.php
│   └── 2025_11_29_000001_create_appointments_table.php
└── seeders/

routes/
└── api.php                  # Todas las rutas de API
```

---

## 🧪 Testing

### Probar la API desde Terminal

```bash
# Test de conexión
curl http://192.168.1.8:8000/api/test

# Login (obtener token)
curl -X POST http://192.168.1.8:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Obtener doctores
curl http://192.168.1.8:8000/api/doctors

# Con autenticación
curl http://192.168.1.8:8000/api/user \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Probar desde Flutter

1. Abre la app en tu dispositivo
2. Presiona el botón **"Probar Conexión"** para verificar que conecta con Laravel
3. Intenta hacer login con las credenciales de prueba
4. Si sale "Login exitoso", ¡la integración funciona! ✅

---

## 🐛 Troubleshooting

### Error: "Connection refused"

**Causa**: El celular no puede alcanzar tu PC

**Solución**:

```powershell
# Permite el puerto 8000 en Firewall de Windows
New-NetFirewallRule -DisplayName "Laravel Dev Server" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow

# Verifica tu IP local
ipconfig
```

### Error: "CORS error"

**Solución**: Edita `back_doctor/config/cors.php`

```php
'paths' => ['api/*'],
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
```

### Error: "Database connection failed"

**Solución**: Verifica `.env` en `back_doctor/`

```env
DB_HOST=127.0.0.1
DB_DATABASE=appdoctor
DB_USERNAME=root
DB_PASSWORD=
```

---

## 📚 Documentación Adicional

- [Flutter Documentation](https://flutter.dev/docs)
- [Laravel Documentation](https://laravel.com/docs)
- [Laravel Sanctum](https://laravel.com/docs/sanctum)
- [Dart HTTP Package](https://pub.dev/packages/http)

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Para cambios mayores:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📝 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**DARKTOTEM2703** - [GitHub](https://github.com/DARKTOTEM2703)

---

## 🎯 Roadmap Futuro

- [ ] Implementar SharedPreferences para guardar token
- [ ] Agregar confirmación de email
- [ ] Sistema de calificaciones de doctores
- [ ] Notificaciones push
- [ ] Historial de citas
- [ ] Pagos integrados
- [ ] Chat en tiempo real
- [ ] Aplicación web
- [ ] Aplicación de escritorio

---

## ❓ Preguntas o Soporte

Para reportar bugs o hacer preguntas:

1. Abre un [Issue](https://github.com/DARKTOTEM2703/ProyectoAppDoctor/issues)
2. Proporciona detalles de tu entorno
3. Adjunta logs o capturas de pantalla

---

**Última actualización**: 29 de noviembre de 2025
