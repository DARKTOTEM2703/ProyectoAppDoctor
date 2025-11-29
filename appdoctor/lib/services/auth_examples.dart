import 'package:appdoctor/services/api_service.dart';

/// Ejemplo de cómo usar ApiService para autenticación
/// Este archivo muestra los patrones de uso más comunes

class AuthExamples {
  
  /// Ejemplo 1: Login de usuario
  static Future<void> loginExample() async {
    try {
      final response = await ApiService.post('login', {
        'email': 'doctor@example.com',
        'password': 'password123',
      });

      // Respuesta esperada de Laravel:
      // {
      //   "access_token": "1|xxxxxxxxxxxx",
      //   "token_type": "Bearer",
      //   "user": {...}
      // }

      final token = response['access_token'];
      final user = response['user'];

      print('Login exitoso! Token: $token');
      // Aquí guardarías el token en SharedPreferences o secure_storage
      
    } catch (e) {
      print('Error en login: $e');
      // Manejar error (mostrar SnackBar, etc.)
    }
  }

  /// Ejemplo 2: Obtener datos de usuario autenticado
  static Future<void> getUserDataExample(String token) async {
    try {
      final response = await ApiService.get('user', token: token);

      print('Datos del usuario: $response');
      
    } catch (e) {
      print('Error obteniendo usuario: $e');
    }
  }

  /// Ejemplo 3: Registro de nuevo usuario
  static Future<void> registerExample() async {
    try {
      final response = await ApiService.post('register', {
        'name': 'Dr. Juan Pérez',
        'email': 'juan.perez@example.com',
        'password': 'password123',
        'password_confirmation': 'password123',
      });

      print('Registro exitoso: ${response['message']}');
      
    } catch (e) {
      print('Error en registro: $e');
    }
  }

  /// Ejemplo 4: Actualizar perfil
  static Future<void> updateProfileExample(String token) async {
    try {
      final response = await ApiService.put(
        'user/profile',
        {
          'name': 'Dr. Juan Pérez Actualizado',
          'specialty': 'Cardiología',
        },
        token: token,
      );

      print('Perfil actualizado: $response');
      
    } catch (e) {
      print('Error actualizando perfil: $e');
    }
  }
}
