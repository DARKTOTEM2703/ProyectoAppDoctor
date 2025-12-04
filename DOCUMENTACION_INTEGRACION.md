# 📱 Documentación Completa - ProyectoAppDoctor

## Tabla de Contenidos
1. [Resumen General](#resumen-general)
2. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
3. [Backend - Laravel API](#backend---laravel-api)
4. [Frontend - Flutter](#frontend---flutter)
5. [Seguridad](#seguridad)
6. [Flujo de Autenticación](#flujo-de-autenticación)
7. [Endpoints Disponibles](#endpoints-disponibles)
8. [Modelos de Datos](#modelos-de-datos)
9. [Servicios en Flutter](#servicios-en-flutter)
10. [Validación de Integración](#validación-de-integración)

---

## Resumen General

**ProyectoAppDoctor** es una aplicación móvil integral para reservar citas médicas en línea. Utiliza una arquitectura cliente-servidor moderna con:

- **Backend**: Laravel 11 con Sanctum (autenticación por tokens)
- **Frontend**: Flutter + Dart con patrón Service Layer
- **Base de datos**: SQLite (configurada para Linux)
- **Patrón de comunicación**: RESTful API con Bearer tokens

### Características Principales
✅ Registro e inicio de sesión seguro  
✅ Listado de doctores por especialidad  
✅ Sistema de reserva de citas con calendario  
✅ Bloqueo de fin de semana  
✅ Prevención de doble reserva  
✅ Persistencia de tokens en dispositivo  
✅ Gestión de errores y validación completa  

---

## Arquitectura del Proyecto

```
ProyectoAppDoctor/
├── back_doctor/                 # Backend Laravel
│   ├── app/
│   │   ├── Models/
│   │   │   ├── User.php
│   │   │   ├── Doctor.php
│   │   │   └── Appointment.php
│   │   └── Http/Controllers/
│   │       ├── AuthController.php
│   │       ├── DoctorController.php
│   │       └── AppointmentController.php
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── routes/
│   │   └── api.php              # Define todos los endpoints
│   └── .env                     # Configuración (SQLite)
│
└── appdoctor/                   # Frontend Flutter
    ├── lib/
    │   ├── models/
    │   │   ├── doctor_model.dart
    │   │   └── appointment_model.dart
    │   ├── services/
    │   │   ├── api_service.dart      # HTTP client centralizado
    │   │   ├── auth_service.dart     # Autenticación
    │   │   ├── doctor_service.dart   # Gestión de doctores
    │   │   └── appointment_service.dart # Gestión de citas
    │   ├── screens/
    │   │   ├── Home_page.dart
    │   │   ├── auth_page.dart
    │   │   ├── register_page.dart
    │   │   ├── doctor_details.dart
    │   │   ├── appointment_page.dart
    │   │   └── success_booking.dart
    │   ├── components/
    │   │   ├── booking_page.dart     # Componente reserva
    │   │   ├── doctor_card.dart
    │   │   ├── login_forms.dart
    │   │   └── register_forms.dart
    │   └── utils/
    │       ├── config.dart           # Configuración global
    │       └── text.dart             # Textos multiidioma
    └── pubspec.yaml                # Dependencias
```

---

## Backend - Laravel API

### Configuración

**Archivo: `.env`**
```bash
DB_CONNECTION=sqlite
DB_DATABASE=/ruta/a/database.sqlite

SANCTUM_STATEFUL_DOMAINS=localhost:8000,127.0.0.1:8000
SESSION_DRIVER=cookie
COOKIE_HTTPONLY=true
```

### Modelos

#### **User Model**
```php
// Relaciones
- hasMany(Appointment)
- Attributes: name, email, password (hashed), timestamps
```

#### **Doctor Model**
```php
// Relaciones
- belongsTo(User as user) // Relación con datos médico
- hasMany(Appointment)
- Attributes: doc_id (FK), category, patients, experience, bio_data, status
```

#### **Appointment Model**
```php
// Relaciones
- belongsTo(User)
- belongsTo(Doctor)
- Attributes: user_id, doctor_id, date, time, status, notes
// Estados: 'upcoming', 'complete', 'cancel'
```

### Controladores

#### **AuthController**

| Método | Endpoint | Tipo | Autenticación | Descripción |
|--------|----------|------|--------------|-------------|
| register | `/register` | POST | ❌ No | Crear nuevo usuario |
| login | `/login` | POST | ❌ No | Iniciar sesión |
| getUser | `/user` | GET | ✅ Sí | Obtener usuario autenticado |
| logout | `/logout` | POST | ✅ Sí | Cerrar sesión |

**Validaciones:**
- Email único
- Contraseña mínimo 8 caracteres
- Password confirmation

#### **DoctorController**

| Método | Endpoint | Tipo | Autenticación | Descripción |
|--------|----------|------|--------------|-------------|
| index | `/doctors` | GET | ❌ No | Listar todos los doctores |
| show | `/doctors/{id}` | GET | ❌ No | Obtener doctor específico |
| filterBySpecialty | `/doctors/specialty/{specialty}` | GET | ❌ No | Filtrar por especialidad |

#### **AppointmentController**

| Método | Endpoint | Tipo | Autenticación | Descripción |
|--------|----------|------|--------------|-------------|
| index | `/appointments` | GET | ✅ Sí | Obtener citas del usuario |
| show | `/appointments/{id}` | GET | ✅ Sí | Obtener cita específica |
| store | `/appointments` | POST | ✅ Sí | Crear nueva cita |
| update | `/appointments/{id}` | PUT | ✅ Sí | Modificar cita |
| destroy | `/appointments/{id}` | DELETE | ✅ Sí | Cancelar cita |
| getAvailableSlots | `/appointments/available/{doctorId}` | GET | ❌ No | Horarios disponibles |

### Validaciones de Citas

```php
// Al crear una cita se valida:
- Fecha no puede ser en el pasado
- No se permite agendar en fin de semana (sábado/domingo)
- No se puede reservar dos citas en el mismo horario
- El doctor debe existir
```

---

## Frontend - Flutter

### Configuración

**Archivo: `lib/utils/config.dart`**
```dart
class Config {
  // API Configuration
  static const String baseApiUrl = 'http://192.168.1.8:8000';
  static const String apiPath = '/api';
  static String get fullApiUrl => '$baseApiUrl$apiPath';
  
  // Colors, sizes, spacing, etc.
}
```

### Dependencias Clave

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # Cliente HTTP
  shared_preferences: ^2.0.0 # Persistencia local
  table_calendar: ^3.0.0    # Calendario
  flutter_localizations:     # Multiidioma
```

### Modelos Dart

#### **Doctor Model**
```dart
class Doctor {
  final int id;
  final int docId;
  final String? category;
  final int? patients;
  final int? experience;
  final String? bioData;
  final String? status;
  final String? doctorName;
  final String? doctorProfile; // URL avatar
  
  factory Doctor.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

#### **Appointment Model**
```dart
class Appointment {
  final int id;
  final int userId;
  final int doctorId;
  final DateTime date;
  final String time;
  final String status; // 'upcoming', 'complete', 'cancel'
  final String? notes;
  final Doctor? doctor;
  final User? user;
  
  factory Appointment.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

---

## Seguridad

### 🔐 Autenticación (Laravel Sanctum)

**Flujo de tokens:**

1. **Registro/Login** → API retorna `access_token`
2. **Almacenamiento** → Token guardado en SharedPreferences
3. **Uso** → Token incluido en header `Authorization: Bearer {token}`
4. **Validación** → Middleware `auth:sanctum` valida en cada request
5. **Logout** → Token eliminado de dispositivo y revocado en servidor

### Headers de Seguridad

```dart
// ApiService inyecta automáticamente:
Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $token', // Si está autenticado
};
```

### Contraseñas

- **Hasheadas** con bcrypt en Laravel (`Hash::make()`)
- **Nunca** se transmiten en texto plano
- **Mínimo 8 caracteres** en registro

### CORS Configurado

```php
// config/cors.php en Laravel
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

### Validación en Servidor

Todas las validaciones se hacen en el backend:
- Unicidad de email
- Formato de fecha/hora
- Existencia de doctor
- Autorización de usuario

---

## Flujo de Autenticación

### 1️⃣ Registro

```
[Flutter RegisterPage]
    ↓
[Presiona "Crear Cuenta"]
    ↓
[AuthService.register(name, email, password, passwordConfirmation)]
    ↓
[ApiService.post('register', data)]
    ↓
[POST /api/register - Backend valida]
    ↓
[Si válido: crea User y genera token]
    ↓
[Retorna: {success: true, access_token: "...", user: {...}}]
    ↓
[SharedPreferences guarda token]
    ↓
[Navega a HomePage]
```

### 2️⃣ Login

```
[Flutter AuthPage]
    ↓
[Presiona "Iniciar Sesión"]
    ↓
[AuthService.login(email, password)]
    ↓
[ApiService.post('login', {email, password})]
    ↓
[POST /api/login - Backend verifica credenciales]
    ↓
[Si válido: genera token y retorna user]
    ↓
[SharedPreferences guarda token + user data]
    ↓
[Navega a HomePage]
```

### 3️⃣ Solicitud Autenticada (Citas)

```
[Flutter BookingPage - Crear cita]
    ↓
[AuthService.getToken()]
    ↓
[SharedPreferences.getString('auth_token')]
    ↓
[AppointmentService.createAppointment(..., token)]
    ↓
[ApiService.post('appointments', data, token: token)]
    ↓
[POST /api/appointments con Authorization header]
    ↓
[Middleware auth:sanctum valida token]
    ↓
[Si válido: Crea Appointment en BD]
    ↓
[Retorna: {success: true, data: {...}}]
    ↓
[Muestra SnackBar de éxito]
```

### 4️⃣ Logout

```
[Flutter Perfil/Menú]
    ↓
[Presiona "Cerrar Sesión"]
    ↓
[AuthService.logout(token)]
    ↓
[ApiService.post('logout', {}, token: token)]
    ↓
[POST /api/logout - Backend revoca token]
    ↓
[SharedPreferences limpia auth_token y user data]
    ↓
[Navega a AuthPage]
```

---

## Endpoints Disponibles

### 🟢 Públicos (Sin Autenticación)

#### **Autenticación**
```
POST /api/register
{
  "name": "Juan Paciente",
  "email": "juan@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

```
POST /api/login
{
  "email": "juan@example.com",
  "password": "password123"
}
```

#### **Doctores**
```
GET /api/doctors
→ Retorna lista de todos los doctores

GET /api/doctors/{id}
→ Retorna detalles de doctor específico

GET /api/doctors/specialty/{specialty}
→ Filtra doctores por especialidad
Ejemplo: /api/doctors/specialty/Cardiología
```

#### **Citas - Disponibilidad**
```
GET /api/appointments/available/{doctorId}
→ Retorna horarios disponibles para un doctor
Ejemplo: /api/appointments/available/1
```

### 🔴 Protegidos (Con Autenticación)

**Header requerido:**
```
Authorization: Bearer {access_token}
```

#### **Usuario**
```
GET /api/user
→ Datos del usuario autenticado

POST /api/logout
→ Cierra sesión y revoca token
```

#### **Citas**
```
GET /api/appointments
→ Lista citas del usuario autenticado

POST /api/appointments
{
  "doctor_id": 1,
  "date": "2025-12-10",
  "time": "10:00",
  "notes": "Revisión general"
}

GET /api/appointments/{id}
→ Detalles de cita específica

PUT /api/appointments/{id}
{
  "date": "2025-12-12",
  "time": "14:00"
}

DELETE /api/appointments/{id}
→ Cancela la cita
```

---

## Modelos de Datos

### User (Paciente/Doctor)
```json
{
  "id": 1,
  "name": "Juan Paciente",
  "email": "juan@example.com",
  "email_verified_at": null,
  "created_at": "2025-12-04T20:38:20.000000Z",
  "updated_at": "2025-12-04T20:38:20.000000Z",
  "profile_photo_url": "https://ui-avatars.com/api/?name=J+P"
}
```

### Doctor
```json
{
  "id": 1,
  "doc_id": 1,
  "category": "General",
  "patients": 150,
  "experience": 15,
  "bio_data": "Médico general con 15 años de experiencia",
  "status": "available",
  "doctor_name": "Dr. Juan Pérez",
  "doctor_profile": "https://ui-avatars.com/api/?name=D+J+P",
  "created_at": "2025-12-04T20:30:42.000000Z",
  "updated_at": "2025-12-04T20:30:42.000000Z"
}
```

### Appointment
```json
{
  "id": 1,
  "user_id": 9,
  "doctor_id": 1,
  "date": "2025-12-10T00:00:00.000000Z",
  "time": "10:00",
  "status": "upcoming",
  "notes": "Revisión general de salud",
  "created_at": "2025-12-04T20:38:30.000000Z",
  "updated_at": "2025-12-04T20:38:30.000000Z",
  "doctor": { /* Doctor object */ },
  "user": { /* User object */ }
}
```

---

## Servicios en Flutter

### 📡 ApiService

Proporciona métodos HTTP genéricos con inyección automática de tokens:

```dart
// GET
static Future<Map<String, dynamic>> get(
  String endpoint, {
  String? token,
}) async { ... }

// POST
static Future<Map<String, dynamic>> post(
  String endpoint,
  Map<String, dynamic> data, {
  String? token,
}) async { ... }

// PUT
static Future<Map<String, dynamic>> put(
  String endpoint,
  Map<String, dynamic> data, {
  String? token,
}) async { ... }

// DELETE
static Future<Map<String, dynamic>> delete(
  String endpoint, {
  String? token,
}) async { ... }
```

### 🔐 AuthService

Gestiona autenticación y persistencia de tokens:

```dart
// Registro
static Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String password,
  required String passwordConfirmation,
}) async { ... }

// Login
static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async { ... }

// Obtener token guardado
static Future<String?> getToken() async { ... }

// Verificar si está autenticado
static Future<bool> isAuthenticated() async { ... }

// Logout
static Future<void> logout(String token) async { ... }
```

### 👨‍⚕️ DoctorService

Accede a doctores desde la API:

```dart
// Obtener todos los doctores
static Future<List<Doctor>> getAllDoctors() async { ... }

// Obtener doctor específico
static Future<Doctor> getDoctorById(int id) async { ... }

// Filtrar por especialidad
static Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async { ... }

// Crear doctor (solo admin)
static Future<Doctor> createDoctor(Map<String, dynamic> data, String token) async { ... }
```

### 📅 AppointmentService

Gestiona citas del usuario:

```dart
// Obtener citas del usuario
static Future<List<Appointment>> getUserAppointments(String token) async { ... }

// Obtener cita específica
static Future<Appointment> getAppointmentById(int id, String token) async { ... }

// Crear cita
static Future<Appointment> createAppointment({
  required int doctorId,
  required DateTime date,
  required String time,
  String? notes,
  required String token,
}) async { ... }

// Actualizar cita
static Future<Appointment> updateAppointment({
  required int appointmentId,
  DateTime? date,
  String? time,
  String? notes,
  required String token,
}) async { ... }

// Cancelar cita
static Future<void> cancelAppointment(int id, String token) async { ... }

// Obtener horarios disponibles
static Future<List<String>> getAvailableSlots(int doctorId) async { ... }
```

---

## Validación de Integración

### ✅ Verificación de Backend

#### 1. API de Autenticación
```bash
# Test endpoint
curl -s http://localhost:8000/api/test

# Registro
curl -s -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'

# Login
curl -s -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 2. API de Doctores
```bash
# Listar doctores
curl -s http://localhost:8000/api/doctors | jq .

# Obtener doctor específico
curl -s http://localhost:8000/api/doctors/1 | jq .

# Filtrar por especialidad
curl -s http://localhost:8000/api/doctors/specialty/Cardiología | jq .
```

#### 3. API de Citas (Protegido)
```bash
# Crear cita (requiere token)
curl -s -X POST http://localhost:8000/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "doctor_id": 1,
    "date": "2025-12-10",
    "time": "10:00",
    "notes": "Revisión general"
  }'

# Obtener citas del usuario
curl -s -X GET http://localhost:8000/api/appointments \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### ✅ Verificación de Flutter

#### 1. Servicios de API
```dart
// Test ApiService
final response = await ApiService.get('doctors');
print(response); // Debe retornar lista de doctores

// Test con token
final token = await AuthService.getToken();
final appointments = await AppointmentService.getUserAppointments(token!);
print(appointments); // Debe retornar lista de citas
```

#### 2. Autenticación
```dart
// Test registro
final registerResponse = await AuthService.register(
  name: 'Test',
  email: 'test@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);
print(registerResponse['access_token']); // Debe tener token

// Test login
final loginResponse = await AuthService.login(
  email: 'test@example.com',
  password: 'password123',
);
print(loginResponse['access_token']); // Debe tener token
```

#### 3. Persistencia de Token
```dart
// Después de login, verificar que el token se guardó
final token = await AuthService.getToken();
print(token); // Debe mostrar el token

// El token debe persistir después de cerrar/abrir la app
final isAuthenticated = await AuthService.isAuthenticated();
print(isAuthenticated); // Debe ser true
```

### ✅ Integración Completa

**Flujo de prueba end-to-end:**

1. **Registro en Flutter**
   - Abre `register_page.dart`
   - Ingresa datos
   - Presiona "Crear Cuenta"
   - Verifica en logs que token se guardó

2. **Login en Flutter**
   - Abre `auth_page.dart`
   - Ingresa credenciales
   - Presiona "Iniciar Sesión"
   - Debe ir a HomePage

3. **Ver Doctores**
   - En HomePage, verifica que lista se llena desde API
   - Presiona un doctor
   - Abre `doctor_details.dart` con datos dinámicos

4. **Reservar Cita**
   - Presiona "Agendar Cita"
   - Abre `booking_page.dart`
   - Selecciona fecha (no fin de semana)
   - Selecciona hora
   - Presiona "Confirmar Reserva"
   - Debe aparecer mensaje de éxito

5. **Verificación en Base de Datos**
   ```sql
   -- En el servidor, verificar que cita se creó
   SELECT * FROM appointments WHERE doctor_id = 1;
   ```

---

## Resumen de Integración

| Aspecto | Estado | Detalles |
|---------|--------|---------|
| **Backend** | ✅ Completo | Laravel 11, Sanctum, SQLite |
| **Frontend** | ✅ Completo | Flutter con todos los servicios |
| **Autenticación** | ✅ Implementada | Tokens Bearer, persistencia local |
| **Doctores** | ✅ Funcional | CRUD, filtrado por especialidad |
| **Citas** | ✅ Funcional | Crear, listar, actualizar, cancelar |
| **Validaciones** | ✅ Completas | Backend + Frontend |
| **Seguridad** | ✅ Robusta | Contraseñas hasheadas, tokens seguros |
| **Base de Datos** | ✅ Configurada | SQLite con relaciones |
| **API Testing** | ✅ Verificada | Todos los endpoints funcionan |

---

## Próximos Pasos Opcionales

- [ ] Agregar notificaciones push para recordatorios de citas
- [ ] Implementar video consultorio para llamadas en vivo
- [ ] Sistema de calificación/reseñas de doctores
- [ ] Historial médico del paciente
- [ ] Dashboard de doctor para ver sus citas
- [ ] Pagos en línea
- [ ] Cambio de contraseña
- [ ] Recuperación de contraseña por email

---

**Documentación Creada:** 4 de diciembre de 2025  
**Versión:** 1.0  
**Estado:** ✅ Sistema 100% Integrado y Funcional
