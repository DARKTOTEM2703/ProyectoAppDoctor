import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  /// Registrar un nuevo usuario
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await ApiService.post('register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      if (response['success'] == true) {
        // Guardar token
        await _saveToken(response['access_token']);
        return response;
      } else {
        throw Exception(
          response['message'] ?? 'Error en el registro',
        );
      }
    } catch (e) {
      print('Error en AuthService.register: $e');
      rethrow;
    }
  }

  /// Login de usuario
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post('login', {
        'email': email,
        'password': password,
      });

      if (response['success'] == true) {
        // Guardar token y datos del usuario
        await _saveToken(response['access_token']);
        if (response['user'] != null) {
          await _saveUser(response['user']);
        }
        return response;
      } else {
        throw Exception(
          response['message'] ?? 'Error en el login',
        );
      }
    } catch (e) {
      print('Error en AuthService.login: $e');
      rethrow;
    }
  }

  /// Obtener usuario autenticado
  static Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await ApiService.get('user', token: token);

      if (response['success'] == true) {
        return response['user'] ?? response;
      } else {
        throw Exception(response['message'] ?? 'Error al obtener usuario');
      }
    } catch (e) {
      print('Error en AuthService.getUser: $e');
      rethrow;
    }
  }

  /// Logout
  static Future<void> logout(String token) async {
    try {
      await ApiService.post('logout', {}, token: token);
      await _clearToken();
      await _clearUser();
    } catch (e) {
      print('Error en AuthService.logout: $e');
      // Limpiar token de todas formas
      await _clearToken();
      await _clearUser();
    }
  }

  /// Guardar token de autenticación
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Obtener token almacenado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Verificar si existe token válido
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Guardar datos del usuario
  static Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    // Aquí podrías serializar el usuario a JSON si es necesario
    await prefs.setString(_userKey, user.toString());
  }

  /// Obtener datos del usuario almacenados
  static Future<String?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  /// Limpiar token
  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Limpiar datos del usuario
  static Future<void> _clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Limpiar todos los datos de autenticación
  static Future<void> clearAll() async {
    await _clearToken();
    await _clearUser();
  }
}
