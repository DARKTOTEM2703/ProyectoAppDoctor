# 📱 Documentación Frontend - ProyectoAppDoctor

## Tabla de Contenidos

1. [Configuración](#configuración)
2. [Arquitectura](#arquitectura)
3. [Modelos](#modelos)
4. [Servicios](#servicios)
5. [Pantallas](#pantallas)
6. [Componentes](#componentes)
7. [Seguridad](#seguridad)
8. [Validaciones](#validaciones)
9. [Setup Dinámico de IP](#setup-dinámico-de-ip)
10. [Problemas Resueltos](#problemas-resueltos)

---

## Configuración

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0 # HTTP client
  shared_preferences: ^2.0.0 # Local storage
  table_calendar: ^3.0.0 # Calendar widget
  flutter_localizations: # Multiidioma
```

### config.dart

```dart
class Config {
  static String _apiBaseUrl = 'localhost';

  static void setApiBaseUrl(String url) {
    _apiBaseUrl = url;
    print('🔵 Config: API Base URL actualizada a: $_apiBaseUrl');
  }

  static String get apiBaseUrl => _apiBaseUrl;
  static String get fullApiUrl => 'http://$apiBaseUrl/api';

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
│   │   ├── appointment_model.dart # Appointment class + fromJson/toJson
│   │   └── user_model.dart        # User class
│   ├── services/
│   │   ├── api_service.dart       # HTTP client (GET, POST, PUT, DELETE)
│   │   ├── auth_service.dart      # Autenticación + token persistence
│   │   ├── doctor_service.dart    # Doctor API calls
│   │   ├── appointment_service.dart # Appointment API calls
│   │   └── ip_service.dart        # Detección automática de IP
│   ├── screens/
│   │   ├── auth_page.dart         # Login UI
│   │   ├── register_page.dart     # Registro UI
│   │   ├── home_page.dart         # Lista doctores
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
│       ├── config.dart            # Config global (dinámico)
│       └── text.dart              # Textos multiidioma
├── pubspec.yaml
└── doc/
    └── README.md (este archivo)
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
  factory Doctor.fromJson(Map<String, dynamic> json) { ... }
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

### User

Representa un usuario autenticado

```dart
class User {
  final int id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) { ... }
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
    // Maneja timeouts, SocketException, y errores HTTP
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

### IpService

Detecta automáticamente la IP del servidor

```dart
class IpService {
  // Detecta automáticamente la IP del servidor
  static Future<String> detectServerIp() async {
    // Intenta conectar a: 10.64.132.23, 10.64.132.1, 192.168.1.1,
    // 192.168.0.1, 10.0.2.2, 127.0.0.1
    // Timeout: 800ms por IP
    // Retorna primera IP exitosa o 'localhost'
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
    // Retorna datos del usuario: {id, name, email, created_at}
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
  }

  // Cancelar cita
  static Future<void> cancelAppointment(int id, String token) async {
    // DELETE /appointments/{id} con token
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
- Validación mínimo 8 caracteres
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

### home_page.dart

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
1. Recibe Doctor object de home_page
2. Despliega toda la información dinámicamente
3. Presiona "Agendar Cita" → booking_page.dart con Doctor
```

### booking_page.dart (componente)

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
- Filtra por status (upcoming, complete, cancel)
- Muestra doctor name, specialty, date, time
- Permite cancelar cita
- FutureBuilder para loading

Flujo:
1. initState() llama AppointmentService.getUserAppointments(token)
2. Filtra citas por status usando enum FilterStatus
3. Despliega cada cita con sus detalles
4. Botón cancelar → AppointmentService.cancelAppointment()
5. Si éxito: actualiza lista
```

### profile_page.dart

Mi perfil de usuario

```dart
Features:
- Muestra datos del usuario autenticado (name, email, id)
- Obtiene datos de AuthService.getUser(token)
- Botón "Cerrar Sesión"
- Loading state
- Error handling

Flujo:
1. initState() llama AuthService.getUser(token)
2. Despliega información del usuario
3. Presiona "Cerrar Sesión" → AuthService.logout(token)
4. Limpia token y vuelve a auth_page.dart
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
✅ URLs base en config.dart (dinámicas)
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

## Setup Dinámico de IP

### ¿Cómo funciona?

Al iniciar la app:

1. `main()` llama `IpService.detectServerIp()`
2. El servicio intenta conectar a IPs comunes (10.64.132.23, 10.64.132.1, etc)
3. Obtiene la IP del servidor y configura `Config.setApiBaseUrl()`
4. Toda la app usa esta IP dinámicamente

### Ventajas

| Antes                          | Ahora                        |
| ------------------------------ | ---------------------------- |
| ❌ IP hardcoded en código      | ✅ IP dinámica automática    |
| ❌ Si cambias red, se rompe    | ✅ Funciona en cualquier red |
| ❌ Cambiar IP = cambiar código | ✅ Detecta automáticamente   |

### Logs de Depuración

Cuando abras la app, verás:

```
🔵 IpService: Intentando obtener IP del servidor...
🟢 IpService: IP obtenida dinámicamente: 10.64.132.23
🔵 Config: API Base URL actualizada a: 10.64.132.23:8000
```

---

## Problemas Resueltos

### Problema 1: Error 111 en Registro

**Causa**: Servidor Laravel no corriendo en localhost:8000
**Solución**: Detectar automáticamente la IP + mejor manejo de errores

### Problema 2: Validación inconsistente de contraseña

**Causa**: Registro requería 6 caracteres, login requería 8
**Solución**: Unificar a 8 caracteres en ambos

### Problema 3: Token no se guardaba después de login

**Causa**: No se guardaba en SharedPreferences
**Solución**: Guardar token automáticamente en AuthService.login()

### Problema 4: Token no se guardaba después de registro

**Causa**: No se guardaba en SharedPreferences
**Solución**: Guardar token automáticamente en AuthService.register()

### Problema 5: Errores API genéricos

**Causa**: No diferenciaba entre SocketException, 401, 422, etc
**Solución**: Manejo específico por tipo de error en ApiService

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
