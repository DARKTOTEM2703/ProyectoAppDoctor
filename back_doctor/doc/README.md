# 📚 Documentación Backend - ProyectoAppDoctor

## Tabla de Contenidos

1. [Configuración](#configuración)
2. [Arquitectura](#arquitectura)
3. [Modelos](#modelos)
4. [Controladores](#controladores)
5. [Rutas API](#rutas-api)
6. [Base de Datos](#base-de-datos)
7. [Seguridad](#seguridad)
8. [Validaciones](#validaciones)
9. [Testing](#testing)

---

## Configuración

### .env

```bash
APP_NAME="ProyectoAppDoctor"
APP_KEY=base64:...
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=sqlite
DB_DATABASE=database.sqlite

CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=cookie

# Sanctum
SANCTUM_STATEFUL_DOMAINS=localhost:8000,127.0.0.1:8000
COOKIE_HTTPONLY=true
```

### Servidor

Iniciar servidor con acceso desde cualquier IP:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Acceso:

-   Local: `http://localhost:8000/api`
-   Red: `http://192.168.x.x:8000/api`

---

## Arquitectura

```
back_doctor/
├── app/
│   ├── Models/
│   │   ├── User.php              # Pacientes y Doctores
│   │   ├── Doctor.php            # Doctores con especialidades
│   │   └── Appointment.php        # Citas médicas
│   └── Http/
│       ├── Controllers/
│       │   ├── AuthController.php     # Registro, Login, Logout
│       │   ├── DoctorController.php   # CRUD Doctores
│       │   └── AppointmentController.php # CRUD Citas
│       └── Middleware/
│           └── Authenticate.php
├── database/
│   ├── migrations/
│   │   ├── 2025_12_04_000000_create_users_table.php
│   │   ├── 2025_12_04_000001_create_doctors_table.php
│   │   └── 2025_12_04_000002_create_appointments_table.php
│   └── seeders/
│       └── DoctorSeeder.php       # 8 doctores con datos realistas
├── routes/
│   └── api.php                    # Todos los endpoints
├── database.sqlite                # Base de datos SQLite
└── doc/
    └── README.md (este archivo)
```

---

## Modelos

### User Model

Representa pacientes y doctores (tabla unificada)

```php
class User extends Model {
  protected $fillable = [
    'name',
    'email',
    'password',
  ];

  protected $hidden = [
    'password',
  ];

  // Relaciones
  public function appointments()
  {
    return $this->hasMany(Appointment::class);
  }

  public function doctor()
  {
    return $this->hasOne(Doctor::class, 'doc_id', 'id');
  }
}
```

**Atributos**:

-   id: int (PK)
-   name: string
-   email: string (unique)
-   password: string (hashed)
-   created_at, updated_at: timestamps

---

### Doctor Model

Información específica de doctores

```php
class Doctor extends Model {
  protected $fillable = [
    'doc_id',
    'category',
    'patients',
    'experience',
    'bio_data',
    'status',
  ];

  protected $appends = [
    'doctor_name',
    'doctor_profile',
  ];

  // Relaciones
  public function user()
  {
    return $this->belongsTo(User::class, 'doc_id', 'id');
  }

  public function appointments()
  {
    return $this->hasMany(Appointment::class);
  }

  // Atributos dinámicos
  public function getDoctorNameAttribute()
  {
    return $this->user->name ?? 'N/A';
  }

  public function getDoctorProfileAttribute()
  {
    return "https://ui-avatars.com/api/?name=" .
           urlencode($this->doctor_name) . "&background=random";
  }
}
```

**Atributos**:

-   id: int (PK)
-   doc_id: int (FK → users.id)
-   category: string (Especialidad)
-   patients: int (Cantidad de pacientes)
-   experience: int (Años de experiencia)
-   bio_data: text (Biografía)
-   status: string ('available', 'busy', etc)
-   created_at, updated_at: timestamps

**Atributos Appended**:

-   doctor_name: obtiene User.name
-   doctor_profile: URL avatar dinámico

---

### Appointment Model

Citas agendadas

```php
class Appointment extends Model {
  protected $fillable = [
    'user_id',
    'doctor_id',
    'date',
    'time',
    'status',
    'notes',
  ];

  protected $casts = [
    'date' => 'datetime',
  ];

  // Relaciones
  public function user()
  {
    return $this->belongsTo(User::class);
  }

  public function doctor()
  {
    return $this->belongsTo(Doctor::class);
  }
}
```

**Atributos**:

-   id: int (PK)
-   user_id: int (FK → users.id)
-   doctor_id: int (FK → doctors.id)
-   date: date
-   time: time (Formato HH:00)
-   status: string ('upcoming', 'complete', 'cancel')
-   notes: text (Notas)
-   created_at, updated_at: timestamps

---

## Controladores

### AuthController

#### POST /api/register

Crear nuevo usuario paciente

**Request**:

```json
{
    "name": "Juan Paciente",
    "email": "juan@example.com",
    "password": "password123",
    "password_confirmation": "password123"
}
```

**Response (201)**:

```json
{
    "success": true,
    "message": "Registro exitoso",
    "access_token": "1|8nTRm7BzFZHO3NtGak7zNnPmLDkyrMD...",
    "token_type": "Bearer",
    "user": {
        "id": 9,
        "name": "Juan Paciente",
        "email": "juan@example.com"
    }
}
```

**Validaciones**:

-   email: required, unique, email format
-   name: required, string, max 255
-   password: required, min 8, confirmed

---

#### POST /api/login

Iniciar sesión

**Request**:

```json
{
    "email": "juan@example.com",
    "password": "password123"
}
```

**Response (200)**:

```json
{
    "success": true,
    "message": "Login exitoso",
    "access_token": "1|...",
    "token_type": "Bearer",
    "user": {
        "id": 9,
        "name": "Juan Paciente",
        "email": "juan@example.com"
    }
}
```

**Error (401)**:

```json
{
    "success": false,
    "message": "Credenciales inválidas"
}
```

---

#### GET /api/user

Obtener usuario autenticado (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Response (200)**:

```json
{
    "success": true,
    "message": "Datos del usuario obtenidos",
    "user": {
        "id": 9,
        "name": "Juan Paciente",
        "email": "juan@example.com",
        "created_at": "2025-12-04T10:30:00Z"
    }
}
```

---

#### POST /api/logout

Cerrar sesión (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Response (200)**:

```json
{
    "success": true,
    "message": "Sesión cerrada"
}
```

---

### DoctorController

#### GET /api/doctors

Listar todos los doctores

**Response (200)**:

```json
{
  "success": true,
  "message": "Lista de doctores obtenida",
  "data": [
    {
      "id": 1,
      "doc_id": 1,
      "category": "General",
      "patients": 150,
      "experience": 15,
      "bio_data": "Médico general con 15 años...",
      "status": "available",
      "doctor_name": "Dr. Juan Pérez",
      "doctor_profile": "https://ui-avatars.com/api/?...",
      "created_at": "2025-12-04T00:00:00Z",
      "updated_at": "2025-12-04T00:00:00Z"
    },
    ...
  ],
  "total": 8
}
```

---

#### GET /api/doctors/{id}

Obtener doctor específico

**Response (200)**:

```json
{
  "success": true,
  "data": { doctor_object }
}
```

**Error (404)**:

```json
{
    "success": false,
    "message": "Doctor no encontrado"
}
```

---

### AppointmentController

#### GET /api/appointments

Obtener citas del usuario (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Response (200)**:

```json
{
    "success": true,
    "message": "Citas obtenidas",
    "data": [
        {
            "id": 1,
            "user_id": 9,
            "doctor_id": 1,
            "date": "2025-12-10",
            "time": "10:00",
            "status": "upcoming",
            "notes": "Revisión general",
            "doctor": {
                "id": 1,
                "doc_id": 1,
                "category": "General",
                "patients": 150,
                "experience": 15,
                "bio_data": "...",
                "doctor_name": "Dr. Juan Pérez",
                "doctor_profile": "https://ui-avatars.com/api/?..."
            },
            "user": {
                "id": 9,
                "name": "Juan Paciente",
                "email": "juan@example.com"
            },
            "created_at": "2025-12-04T10:30:00Z"
        }
    ],
    "total": 1
}
```

---

#### GET /api/appointments/{id}

Obtener cita específica (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Response (200)**:

```json
{
  "success": true,
  "data": { appointment_object }
}
```

**Error (404)**:

```json
{
    "success": false,
    "message": "Cita no encontrada"
}
```

---

#### POST /api/appointments

Crear cita (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Request**:

```json
{
    "doctor_id": 1,
    "date": "2025-12-10",
    "time": "10:00",
    "notes": "Revisión general"
}
```

**Response (201)**:

```json
{
  "success": true,
  "message": "Cita agendada exitosamente",
  "data": { appointment_object }
}
```

**Validaciones**:

-   doctor_id: required, exists in doctors
-   date: required, date, not in past, not weekend
-   time: required, time format (HH:00)
-   No permitir doble-reserva mismo doctor/fecha/hora

---

#### DELETE /api/appointments/{id}

Cancelar cita (Protegido)

**Header**:

```
Authorization: Bearer {token}
```

**Response (200)**:

```json
{
    "success": true,
    "message": "Cita cancelada"
}
```

---

## Rutas API

Archivo: `routes/api.php`

### Rutas Públicas (Sin Autenticación)

```php
// Test
GET /api/test

// Autenticación
POST /api/register
POST /api/login

// Doctores
GET /api/doctors
GET /api/doctors/{id}
```

### Rutas Protegidas (Requieren Bearer Token)

```php
// Usuario
GET /api/user
POST /api/logout

// Citas del usuario
GET /api/appointments
GET /api/appointments/{id}
POST /api/appointments
DELETE /api/appointments/{id}
```

---

## Base de Datos

### Schema

#### users table

```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  email_verified_at TIMESTAMP NULL,
  remember_token VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### doctors table

```sql
CREATE TABLE doctors (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  doc_id BIGINT NOT NULL FOREIGN KEY REFERENCES users(id),
  category VARCHAR(255),
  patients INT,
  experience INT,
  bio_data TEXT,
  status VARCHAR(100) DEFAULT 'available',
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### appointments table

```sql
CREATE TABLE appointments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL FOREIGN KEY REFERENCES users(id),
  doctor_id BIGINT NOT NULL FOREIGN KEY REFERENCES doctors(id),
  date DATE,
  time TIME,
  status VARCHAR(100) DEFAULT 'upcoming',
  notes TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Seeders

**DoctorSeeder.php** crea 8 doctores:

1. **Dr. Juan Pérez** - General

    - Pacientes: 150
    - Experiencia: 15 años
    - Bio: Médico general con 15 años de experiencia...

2. **Dra. María García** - Cardiología

    - Pacientes: 120
    - Experiencia: 12 años

3. **Dr. Carlos López** - Dermatología

    - Pacientes: 100
    - Experiencia: 10 años

4. **Dra. Ana Martínez** - Ginecología

    - Pacientes: 140
    - Experiencia: 14 años

5. **Dr. Roberto Sánchez** - Odontología

    - Pacientes: 180
    - Experiencia: 18 años

6. **Dra. Laura González** - Neumología

    - Pacientes: 110
    - Experiencia: 11 años

7. **Dr. Francisco Torres** - Oftalmología

    - Pacientes: 95
    - Experiencia: 9 años

8. **Dra. Patricia Ruiz** - Pediatría
    - Pacientes: 200
    - Experiencia: 20 años

**Ejecutar**:

```bash
php artisan db:seed --class=DoctorSeeder
```

---

## Seguridad

### Autenticación Sanctum

```php
// Generación de token
$token = $user->createToken('auth_token')->plainTextToken;

// Middleware
Route::middleware('auth:sanctum')->get('/user', ...);

// Verificación
$request->user() // obtiene usuario autenticado
```

**Características**:

-   Tokens generados al registrar/login
-   Tokens persisten con Bearer tokens
-   Middleware `auth:sanctum` valida requests
-   Tokens revocados al logout

---

### Contraseñas

```php
// Hash
password_hash('password123', PASSWORD_BCRYPT);

// Validación
Hash::check('password123', $user->password);

// Requisitos
- Mínimo 8 caracteres
- Password confirmation en registro
```

---

### CORS

```php
// Configurado para requests desde Flutter
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['Content-Type', 'Authorization'],
```

---

### Validación

```php
// Email único
'email' => 'required|email|unique:users'

// Campos requeridos
'name' => 'required|string|max:255'
'password' => 'required|min:8|confirmed'

// Existencia de registros
'doctor_id' => 'required|exists:doctors,id'
```

---

## Validaciones

### Registro

```php
'name' => 'required|string|max:255',
'email' => 'required|email|unique:users',
'password' => 'required|min:8|confirmed',
```

### Login

```php
'email' => 'required|email',
'password' => 'required',
```

### Crear Cita

```php
'doctor_id' => 'required|exists:doctors,id',
'date' => 'required|date|not_in_past',
'time' => 'required|date_format:H:i',

Validaciones adicionales:
- No permitir fin de semana (sábado/domingo)
- No permitir doble-reserva
- No permitir hora pasada del día actual
```

---

## Testing

### Test Conexión

```bash
curl -s http://localhost:8000/api/test
```

**Response**:

```json
{
    "success": true,
    "message": "API conectada correctamente"
}
```

---

### Test Registro

```bash
curl -s -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

---

### Test Doctores

```bash
curl -s http://localhost:8000/api/doctors | jq .
```

---

### Test Cita con Token

```bash
curl -s -X POST http://localhost:8000/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "doctor_id": 1,
    "date": "2025-12-10",
    "time": "10:00",
    "notes": "Revisión"
  }'
```

---

### Test Unit (PHPUnit)

```bash
# Ejecutar todos los tests
php artisan test

# Ejecutar tests específicos
php artisan test --filter=LoginTest

# Con coverage
php artisan test --coverage
```

---

**Última actualización:** 4 de diciembre de 2025  
**Estado:** ✅ Completo y funcional
