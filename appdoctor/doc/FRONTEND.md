# 📱 Documentación Frontend - ProyectoAppDoctor

## Tabla de Contenidos
1. [Configuración](#configuración)
2. [Arquitectura](#arquitectura)
3. [Modelos](#modelos)
4. [Servicios](#servicios)
5. [Pantallas](#pantallas)
6. [Seguridad](#seguridad)
7. [Validaciones](#validaciones)

---

## Configuración

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0              # HTTP client
  shared_preferences: ^2.0.0 # Local storage
  table_calendar: ^3.0.0    # Calendar widget
  flutter_localizations:     # Multiidioma
```

### config.dart
```dart
class Config {
  static const String baseApiUrl = 'http://192.168.1.8:8000';
  static const String apiPath = '/api';
  static String get fullApiUrl => '$baseApiUrl$apiPath';
  
  // Colores, tamaños, spacing, etc.
}
```

---

## Arquitectura

```
appdoctor/
├── lib/
│   ├── models/
│   │   ├── doctor_model.dart      # Doctor class + fromJson/toJson
│   │   └── appointment_model.dart # Appointment class + fromJson/toJson
│   ├── services/
│   │   ├── api_service.dart       # HTTP client (GET, POST, PUT, DELETE)
│   │   ├── auth_service.dart      # Autenticación + token persistence
│   │   ├── doctor_service.dart    # Doctor API calls
│   │   └── appointment_service.dart # Appointment API calls
│   ├── screens/
│   │   ├── auth_page.dart         # Login UI
│   │   ├── register_page.dart     # Registro UI
│   │   ├── Home_page.dart         # Lista doctores
│   │   ├── doctor_details.dart    # Detalles doctor
│   │   ├── appointment_page.dart  # Mis citas
│   │   ├── profile_page.dart      # Mi perfil
│   │   └── success_booking.dart   # Confirmación cita
│   ├── components/
│   │   ├── booking_page.dart      # Calendario + reserva cita
│   │   ├── doctor_card.dart       # Card doctor en lista
│   │   ├── login_forms.dart       # Formulario login
│   │   ├── register_forms.dart    # Formulario registro
│   │   └── custom_appbar.dart     # AppBar personalizado
│   └── utils/
│       ├── config.dart            # Config global
│       └── text.dart              # Textos multiidioma
├── pubspec.yaml
└── doc/
    └── FRONTEND.md (este archivo)
```

---

## Modelos

### Doctor
Representa un doctor en la aplicación

```dart
class Doctor {
  final int id;
  final int docId;
  final String? category;      // Especialidad
  final int? patients;          // Número de pacientes
  final int? experience;        // Años de experiencia
  final String? bioData;        // Biografía
  final String? status;         // Estado (available, etc)
  final String? doctorName;     // Nombre del doctor
  final String? doctorProfile;  // URL del avatar
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Factory constructor
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      docId: json['doc_id'] as int,
      category: json['category'] as String?,
      patients: json['patients'] as int?,
      experience: json['experience'] as int?,
      bioData: json['bio_data'] as String?,
      status: json['status'] as String?,
      doctorName: json['doctor_name'] as String?,
      doctorProfile: json['doctor_profile'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
  
  // Convert to JSON
  Map<String, dynamic> toJson() { ... }
}
```

### Appointment
Representa una cita agendada

```dart
class Appointment {
  final int id;
  final int userId;
  final int doctorId;
  final DateTime date;
  final String time;
  final String status;    // 'upcoming', 'complete', 'cancel'
  final String? notes;
  final Doctor? doctor;   // Objeto doctor completo
  final User? user;       // Objeto user
  
  factory Appointment.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

---

## Servicios

### ApiService
Cliente HTTP centralizado para todas las peticiones

```dart
class ApiService {
  // GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    // Retorna respuesta decodificada
    // Inyecta token en Authorization header si es proporcionado
  }
  
  // POST request
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    // Retorna respuesta decodificada
  }
  
  // PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    // Actualiza datos
  }
  
  // DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    // Elimina recurso
  }
}
```

### AuthService
Gestiona autenticación y persistencia de tokens

```dart
class AuthService {
  // Crear nueva cuenta
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    // POST /register
    // Guarda token en SharedPreferences
    // Retorna {success, access_token, user}
  }
  
  // Iniciar sesión
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // POST /login
    // Guarda token en SharedPreferences
    // Retorna {success, access_token, user}
  }
  
  // Obtener usuario autenticado
  static Future<Map<String, dynamic>> getUser(String token) async {
    // GET /user con token
    // Retorna datos del usuario
  }
  
  // Cerrar sesión
  static Future<void> logout(String token) async {
    // POST /logout con token
    // Limpia token de SharedPreferences
  }
  
  // Obtener token guardado
  static Future<String?> getToken() async {
    // Recupera token de SharedPreferences
  }
  
  // Verificar si está autenticado
  static Future<bool> isAuthenticated() async {
    // Retorna true si hay token guardado
  }
}
```

### DoctorService
Accede a doctores desde la API

```dart
class DoctorService {
  // Obtener todos los doctores
  static Future<List<Doctor>> getAllDoctors() async {
    // GET /doctors
    // Convierte JSON a List<Doctor>
    // Maneja errores con mensajes descriptivos
  }
  
  // Obtener doctor específico
  static Future<Doctor> getDoctorById(int id) async {
    // GET /doctors/{id}
    // Retorna objeto Doctor
  }
  
  // Filtrar por especialidad
  static Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    // GET /doctors/specialty/{specialty}
    // Retorna List<Doctor> filtrada
  }
  
  // Crear doctor (solo admin)
  static Future<Doctor> createDoctor({
    required String name,
    required String specialty,
    required String token,
  }) async {
    // POST /doctors con token
    // Retorna Doctor creado
  }
}
```

### AppointmentService
Gestiona citas del usuario

```dart
class AppointmentService {
  // Obtener citas del usuario
  static Future<List<Appointment>> getUserAppointments(String token) async {
    // GET /appointments con token
    // Retorna List<Appointment> del usuario
  }
  
  // Obtener cita específica
  static Future<Appointment> getAppointmentById(int id, String token) async {
    // GET /appointments/{id} con token
    // Retorna Appointment
  }
  
  // Crear nueva cita
  static Future<Appointment> createAppointment({
    required int doctorId,
    required DateTime date,
    required String time,
    String? notes,
    required String token,
  }) async {
    // POST /appointments con token
    // Convierte date a formato YYYY-MM-DD
    // Retorna Appointment creado
    
    // Validaciones:
    // - Verifica que usuario esté autenticado
    // - Valida fecha no en pasado
    // - Valida formato time (HH:00)
  }
  
  // Actualizar cita existente
  static Future<Appointment> updateAppointment({
    required int appointmentId,
    DateTime? date,
    String? time,
    String? notes,
    required String token,
  }) async {
    // PUT /appointments/{appointmentId} con token
    // Retorna Appointment actualizado
  }
  
  // Cancelar cita
  static Future<void> cancelAppointment(int id, String token) async {
    // DELETE /appointments/{id} con token
  }
  
  // Obtener horarios disponibles
  static Future<List<String>> getAvailableSlots(int doctorId) async {
    // GET /appointments/available/{doctorId}
    // Retorna List<String> con horarios (09:00, 10:00, etc)
  }
}
```

---

## Pantallas

### auth_page.dart
Pantalla de inicio de sesión

```dart
Features:
- Formulario con email y contraseña
- Botón "Iniciar Sesión"
- Navegación a registro
- Manejo de errores con SnackBar
- Validación de campos vacíos
- Loading state

Flujo:
1. Usuario ingresa email y contraseña
2. Presiona "Iniciar Sesión"
3. AuthService.login() → POST /login
4. Si éxito: guarda token, navega a HomePage
5. Si error: muestra SnackBar
```

### register_page.dart
Pantalla de registro

```dart
Features:
- Formulario con nombre, email, contraseña
- Validación password confirmation
- Botón "Crear Cuenta"
- Manejo de errores
- Loading state

Flujo:
1. Usuario ingresa datos
2. Presiona "Crear Cuenta"
3. AuthService.register() → POST /register
4. Si éxito: muestra mensaje y vuelve a login
5. Si error: muestra detalles del error
```

### Home_page.dart
Lista de doctores disponibles

```dart
Features:
- FutureBuilder para cargar doctores desde API
- Lista de DoctorCard
- Loading state (circular progress)
- Error handling
- Búsqueda por categoría (opcional)

Flujo:
1. initState() llama DoctorService.getAllDoctors()
2. FutureBuilder espera respuesta de API
3. Mapea cada doctor a DoctorCard
4. Presionar card → doctor_details.dart con Doctor object
```

### doctor_details.dart
Detalles de un doctor específico

```dart
Features:
- Recibe Doctor object como argumento
- Muestra:
  - Foto del doctor
  - Nombre
  - Especialidad
  - Años de experiencia
  - Número de pacientes
  - Biografía
- Botón "Agendar Cita"

Flujo:
1. Recibe Doctor object de Home_page
2. Despliega toda la información dinámicamente
3. Presiona "Agendar Cita" → booking_page.dart con Doctor
```

### booking_page.dart
Reserva de cita con calendario

```dart
Features:
- Calendario (table_calendar)
- Bloqueo de fin de semana (rojo)
- Bloqueo de fechas pasadas
- Selección de horarios (9 AM - 5 PM)
- Bloque de horarios disponibles
- Campo de notas

Validaciones:
- No permite seleccionar fin de semana
- No permite seleccionar fecha en pasado
- Muestra solo horarios disponibles (09:00-17:00)

Flujo:
1. Usuario selecciona fecha en calendario
2. Sistema muestra horarios disponibles
3. Usuario selecciona hora
4. Usuario ingresa notas (opcional)
5. Presiona "Confirmar Reserva"
6. AppointmentService.createAppointment() → POST /appointments
7. Si éxito: navega a success_booking.dart
8. Si error: muestra SnackBar
```

### appointment_page.dart
Mis citas agendadas

```dart
Features:
- Obtiene citas del usuario autenticado
- Muestra estado de cada cita (upcoming, complete, cancel)
- Permite cancelar cita
- Permite editar cita (cambiar fecha/hora)
- FutureBuilder para loading

Flujo:
1. initState() llama AppointmentService.getUserAppointments(token)
2. Despliega cada cita con sus detalles
3. Botón cancelar → AppointmentService.cancelAppointment()
4. Botón editar → navega a booking_page.dart en modo edición
```

### success_booking.dart
Confirmación de cita agendada

```dart
Features:
- Muestra mensaje de éxito
- Resumen de cita:
  - Doctor
  - Fecha
  - Hora
  - Notas
- Botón "Ver mis citas"
- Botón "Volver al inicio"

Flujo:
1. Recibe Appointment object creado
2. Muestra confirmación con datos
3. Usuario presiona botón para continuar
```

### profile_page.dart
Mi perfil de usuario

```dart
Features:
- Muestra datos del usuario autenticado
- Opción para editar perfil
- Opción para cambiar contraseña
- Botón "Cerrar Sesión"
- Avatar dinámico

Flujo:
1. Obtiene datos de AuthService.getUser()
2. Despliega información
3. Presiona "Cerrar Sesión" → AuthService.logout()
4. Limpia token y vuelve a auth_page.dart
```

---

## Componentes

### doctor_card.dart
Card que muestra resumen de doctor

```dart
Props:
- Doctor object
- Callback al presionar

Muestra:
- Avatar (doctorProfile URL)
- Nombre
- Especialidad
- Experiencia
- Rating (opcional)

Al presionar:
- Navega a doctor_details.dart pasando Doctor object
```

### login_forms.dart
Formulario de login reutilizable

```dart
Props:
- onSuccess callback

Campos:
- Email input
- Password input (obscured)
- "Olvidé contraseña" link
- "Crear cuenta" link

Valida:
- Email no vacío
- Contraseña no vacía
- Formato email

Actions:
- Presiona login → AuthService.login()
```

### register_forms.dart
Formulario de registro reutilizable

```dart
Props:
- onSuccess callback

Campos:
- Name input
- Email input
- Password input (obscured)
- Confirm password input
- Terms checkbox

Valida:
- Campos requeridos
- Email format
- Password length (min 8)
- Passwords match
- Terms aceptados

Actions:
- Presiona registro → AuthService.register()
```

### booking_page.dart (componente)
Visto en [Pantallas](#booking_pagedart)

### custom_appbar.dart
AppBar personalizado

```dart
Props:
- title: String
- icon: Widget
- onPressed: callback (opcional)

Muestra:
- Ícono de atrás clickeable
- Título centralizado
- Color personalizado (Config.colorprimario)
```

---

## Seguridad

### Token Management
```dart
// Almacenamiento
- SharedPreferences.setString('auth_token', token)
- Persiste después de cerrar app

// Recuperación
- SharedPreferences.getString('auth_token')
- Usado en cada request autenticado

// Eliminación
- SharedPreferences.remove('auth_token')
- Al logout

// Inyección automática
- ApiService agrega "Authorization: Bearer {token}" header
```

### Validación en Cliente
```dart
- Email no vacío y formato válido
- Contraseñas mínimo 8 caracteres
- Confirmación de contraseña coincide
- Campos requeridos
- Fechas no en pasado
- Horarios válidos
```

### Mejor Prácticas
```dart
✅ Token guardado en SharedPreferences (local)
✅ Token inyectado en header Authorization
✅ Token limpiado al logout
✅ No hay credenciales hardcodeadas
✅ URLs base en config.dart
✅ Error handling completo
✅ Loading states para async operations
✅ Validación en ambos lados (cliente + servidor)
```

---

## Validaciones

### Autenticación
```dart
// Registro
- name: no vacío, string
- email: no vacío, email válido, no duplicado
- password: no vacío, mínimo 8 caracteres
- password_confirmation: coincide con password

// Login
- email: no vacío, email válido
- password: no vacío
```

### Citas
```dart
// Crear cita
- doctor_id: doctor debe existir
- date: no vacío, no en pasado, no fin de semana
- time: formato válido (HH:00), entre 09:00-17:00
- notes: opcional, máximo 500 caracteres

// Backend valida:
- Fecha no en pasado
- No doble-reserva
- Doctor existe
```

---

## Flujos Principales

### Registro → Login → Reservar Cita

```
1. REGISTRO
   register_page.dart
   ↓
   RegisterForm.onSubmit()
   ↓
   AuthService.register(name, email, password)
   ↓
   POST /api/register
   ↓
   SharedPreferences.setString('auth_token', response['access_token'])
   ↓
   Navega a auth_page.dart

2. LOGIN
   auth_page.dart
   ↓
   LoginForm.onSubmit()
   ↓
   AuthService.login(email, password)
   ↓
   POST /api/login
   ↓
   SharedPreferences.setString('auth_token', response['access_token'])
   ↓
   Navega a Home_page.dart

3. VER DOCTORES
   Home_page.dart
   ↓
   initState() → DoctorService.getAllDoctors()
   ↓
   GET /api/doctors
   ↓
   FutureBuilder.snapshot.data = List<Doctor>
   ↓
   Mapea a DoctorCard widgets

4. VER DETALLES
   Presiona doctor_card.dart
   ↓
   Navega a doctor_details.dart(doctor: Doctor object)
   ↓
   Muestra información dinámica del doctor

5. RESERVAR CITA
   Presiona "Agendar Cita" en doctor_details
   ↓
   Navega a booking_page.dart(doctor: Doctor)
   ↓
   Usuario selecciona fecha y hora
   ↓
   Presiona "Confirmar"
   ↓
   AppointmentService.createAppointment(
     doctorId, date, time, notes, token
   )
   ↓
   POST /api/appointments con Authorization header
   ↓
   Navega a success_booking.dart
   ↓
   Muestra confirmación
```

---

## Testing

### Test ApiService
```dart
final response = await ApiService.get('doctors');
expect(response['success'], true);
expect(response['data'], isA<List>());
```

### Test AuthService
```dart
final result = await AuthService.login(
  email: 'test@example.com',
  password: 'password123',
);
expect(result['success'], true);

final token = await AuthService.getToken();
expect(token, isNotNull);
```

### Test DoctorService
```dart
final doctors = await DoctorService.getAllDoctors();
expect(doctors, isA<List<Doctor>>());
expect(doctors.length, greaterThan(0));
```

### Test AppointmentService
```dart
final token = await AuthService.getToken();
final appointment = await AppointmentService.createAppointment(
  doctorId: 1,
  date: DateTime.now().add(Duration(days: 5)),
  time: '10:00',
  token: token!,
);
expect(appointment.status, 'upcoming');
```

---

**Última actualización:** 4 de diciembre de 2025  
**Estado:** ✅ Completo y funcional
