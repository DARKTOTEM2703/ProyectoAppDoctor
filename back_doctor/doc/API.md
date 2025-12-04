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

---

## Configuración

### .env
```bash
DB_CONNECTION=sqlite
DB_DATABASE=database.sqlite

SANCTUM_STATEFUL_DOMAINS=localhost:8000,127.0.0.1:8000
SESSION_DRIVER=cookie
COOKIE_HTTPONLY=true
```

### Servidor
```bash
# Iniciar servidor
php artisan serve --host=0.0.0.0 --port=8000

# URL Base: http://192.168.1.8:8000/api
```

---

## Arquitectura

```
back_doctor/
├── app/
│   ├── Models/
│   │   ├── User.php              # Pacientes y Doctores
│   │   ├── Doctor.php            # Doctores con especialidades
│   │   └── Appointment.php        # Citas médicas
│   └── Http/Controllers/
│       ├── AuthController.php     # Registro, Login, Logout
│       ├── DoctorController.php   # CRUD Doctores
│       └── AppointmentController.php # CRUD Citas
├── database/
│   ├── migrations/
│   │   ├── 2025_12_04_000000_create_users_table.php
│   │   ├── 2025_12_04_000001_create_doctors_table.php
│   │   └── 2025_12_04_000002_create_appointments_table.php
│   └── seeders/
│       └── DoctorSeeder.php       # 8 doctores con datos realistas
├── routes/
│   └── api.php                    # Todos los endpoints
└── database.sqlite                # Base de datos SQLite
```

---

## Modelos

### User Model
Representa pacientes y doctores (tabla unificada)

```php
// Atributos
- id: int (PK)
- name: string
- email: string (unique)
- password: string (hashed)
- created_at, updated_at: timestamps

// Relaciones
- hasMany(Appointment)  // Las citas del usuario
```

### Doctor Model
Información específica de doctores

```php
// Atributos
- id: int (PK)
- doc_id: int (FK → users.id)
- category: string          // Especialidad: General, Cardiología, etc.
- patients: int             // Cantidad de pacientes atendidos
- experience: int           // Años de experiencia
- bio_data: text            // Biografía/descripción
- status: string            // 'available', 'busy', etc.
- created_at, updated_at: timestamps

// Relaciones
- belongsTo(User)           // Datos del doctor (user)
- hasMany(Appointment)      // Las citas del doctor

// Atributos Appended
- doctor_name: User.name
- doctor_profile: URL avatar dinámico
```

### Appointment Model
Citas agendadas

```php
// Atributos
- id: int (PK)
- user_id: int (FK → users.id)      // Paciente
- doctor_id: int (FK → doctors.id)   // Doctor
- date: date
- time: time                         // Formato HH:00
- status: string                     // 'upcoming', 'complete', 'cancel'
- notes: text                        // Notas adicionales
- created_at, updated_at: timestamps

// Relaciones
- belongsTo(User)           // Datos del paciente
- belongsTo(Doctor)         // Datos del doctor
```

---

## Controladores

### AuthController

#### POST /api/register
Crear nuevo usuario paciente

```php
Request:
{
  "name": "Juan Paciente",
  "email": "juan@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}

Response (201):
{
  "success": true,
  "message": "Registro exitoso",
  "access_token": "1|8nTRm7BzFZHO3NtGak7zNnPmLDkyrMD...",
  "token_type": "Bearer",
  "user": {
    "id": 9,
    "name": "Juan Paciente",
    "email": "juan@example.com",
    ...
  }
}

Validaciones:
- email: required, unique, email format
- name: required, string, max 255
- password: required, min 8, confirmed
```

#### POST /api/login
Iniciar sesión

```php
Request:
{
  "email": "juan@example.com",
  "password": "password123"
}

Response (200):
{
  "success": true,
  "message": "Login exitoso",
  "access_token": "1|...",
  "token_type": "Bearer",
  "user": { ... }
}

Error (401):
{
  "success": false,
  "message": "Credenciales inválidas"
}
```

#### GET /api/user
Obtener usuario autenticado (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "data": {
    "id": 9,
    "name": "Juan Paciente",
    "email": "juan@example.com",
    ...
  }
}
```

#### POST /api/logout
Cerrar sesión (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "message": "Sesión cerrada"
}
```

### DoctorController

#### GET /api/doctors
Listar todos los doctores

```php
Response (200):
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
      "doctor_name": "Dr. Juan Pérez",
      "doctor_profile": "https://ui-avatars.com/...",
      ...
    },
    ...
  ],
  "total": 8
}
```

#### GET /api/doctors/{id}
Obtener doctor específico

```php
Response (200):
{
  "success": true,
  "data": { doctor_object }
}

Error (404):
{
  "success": false,
  "message": "Doctor no encontrado"
}
```

#### GET /api/doctors/specialty/{specialty}
Filtrar doctores por especialidad

```php
# Ejemplo: /api/doctors/specialty/Cardiología

Response (200):
{
  "success": true,
  "data": [ array_of_doctors ]
}
```

#### POST /api/doctors
Crear doctor (Protegido)

```php
Header:
Authorization: Bearer {token}

Request:
{
  "name": "Dr. Nuevo",
  "specialty": "Neurología",
  ...
}

Response (201):
{
  "success": true,
  "data": { doctor_object }
}
```

#### PUT /api/doctors/{id}
Actualizar doctor (Protegido)

```php
Header:
Authorization: Bearer {token}

Request:
{
  "category": "Cardiología",
  "patients": 200,
  ...
}

Response (200):
{
  "success": true,
  "data": { updated_doctor }
}
```

#### DELETE /api/doctors/{id}
Eliminar doctor (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "message": "Doctor eliminado"
}
```

### AppointmentController

#### GET /api/appointments
Obtener citas del usuario (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "message": "Citas obtenidas",
  "data": [
    {
      "id": 1,
      "user_id": 9,
      "doctor_id": 1,
      "date": "2025-12-10T00:00:00Z",
      "time": "10:00",
      "status": "upcoming",
      "notes": "Revisión general",
      "doctor": { doctor_object },
      "user": { user_object }
    }
  ],
  "total": 1
}
```

#### GET /api/appointments/{id}
Obtener cita específica (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "data": { appointment_object }
}

Error (404):
{
  "success": false,
  "message": "Cita no encontrada"
}
```

#### POST /api/appointments
Crear cita (Protegido)

```php
Header:
Authorization: Bearer {token}

Request:
{
  "doctor_id": 1,
  "date": "2025-12-10",
  "time": "10:00",
  "notes": "Revisión general"
}

Response (201):
{
  "success": true,
  "message": "Cita agendada exitosamente",
  "data": { appointment_object }
}

Validaciones:
- doctor_id: required, exists in doctors
- date: required, date, not in past
- time: required, time format
- No permitir fin de semana (sábado/domingo)
- No permitir doble-reserva mismo doctor/fecha/hora
```

#### PUT /api/appointments/{id}
Actualizar cita (Protegido)

```php
Header:
Authorization: Bearer {token}

Request:
{
  "date": "2025-12-12",
  "time": "14:00",
  "notes": "Nueva nota"
}

Response (200):
{
  "success": true,
  "data": { updated_appointment }
}
```

#### DELETE /api/appointments/{id}
Cancelar cita (Protegido)

```php
Header:
Authorization: Bearer {token}

Response (200):
{
  "success": true,
  "message": "Cita cancelada"
}
```

#### GET /api/appointments/available/{doctorId}
Obtener horarios disponibles (Público)

```php
# Ejemplo: /api/appointments/available/1

Response (200):
{
  "success": true,
  "data": {
    "available_slots": [
      "09:00",
      "10:00",
      "11:00",
      ...
      "17:00"
    ],
    "blocked_dates": ["2025-12-06", "2025-12-07", ...]  // Fin de semana
  }
}
```

---

## Rutas API

Archivo: `routes/api.php`

### Públicas (Sin Autenticación)

```php
// Test
GET /api/test

// Autenticación
POST /api/register
POST /api/login

// Doctores
GET /api/doctors
GET /api/doctors/{id}
GET /api/doctors/specialty/{specialty}

// Citas
GET /api/appointments/available/{doctorId}
```

### Protegidas (Requieren Bearer Token)

```php
// Usuario
GET /api/user
POST /api/logout

// Doctores (admin)
POST /api/doctors
PUT /api/doctors/{id}
DELETE /api/doctors/{id}

// Citas
GET /api/appointments
GET /api/appointments/{id}
POST /api/appointments
PUT /api/appointments/{id}
DELETE /api/appointments/{id}
```

---

## Base de Datos

### Migraciones

#### users table
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  password VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### doctors table
```sql
CREATE TABLE doctors (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  doc_id BIGINT NOT NULL FOREIGN KEY users.id,
  category VARCHAR(255),
  patients INT,
  experience INT,
  bio_data TEXT,
  status VARCHAR(100),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### appointments table
```sql
CREATE TABLE appointments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL FOREIGN KEY users.id,
  doctor_id BIGINT NOT NULL FOREIGN KEY doctors.id,
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
1. Dr. Juan Pérez - General
2. Dra. María García - Cardiología
3. Dr. Carlos López - Dermatología
4. Dra. Ana Martínez - Ginecología
5. Dr. Roberto Sánchez - Odontología
6. Dra. Laura González - Neumología
7. Dr. Francisco Torres - Oftalmología
8. Dra. Patricia Ruiz - Pediatría

Ejecutar: `php artisan db:seed --class=DoctorSeeder`

---

## Seguridad

### Autenticación Sanctum
- Tokens generados al registrar/login
- Tokens persisten con Bearer tokens
- Middleware `auth:sanctum` valida requests
- Tokens revocados al logout

### Contraseñas
- Hasheadas con bcrypt
- Validación mínimo 8 caracteres
- Password confirmation en registro

### CORS
- Configurado para requests desde Flutter
- Headers permitidos: Content-Type, Authorization, Accept

### Validación
- Email único
- Campos requeridos
- Tipos de dato correos
- Existencia de registros (FK)

---

## Validaciones

### Registro
```php
- name: required|string|max:255
- email: required|email|unique:users
- password: required|min:8|confirmed
```

### Login
```php
- email: required|email
- password: required
```

### Crear Cita
```php
- doctor_id: required|exists:doctors
- date: required|date|not_in_past
- time: required|time_format:H:i
- status: nullable|in:upcoming,complete,cancel

Validaciones Adicionales:
- No permitir fin de semana
- No permitir doble-reserva
- No permitir hora pasada del día actual
```

---

## Testing

### Test Conexión
```bash
curl -s http://localhost:8000/api/test
```

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

### Test Doctores
```bash
curl -s http://localhost:8000/api/doctors | jq .
```

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

**Última actualización:** 4 de diciembre de 2025  
**Estado:** ✅ Completo y funcional
