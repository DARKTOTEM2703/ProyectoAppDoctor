import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../utils/config.dart';

/// Servicio centralizado para todas las peticiones HTTP a la API de Laravel
class ApiService {
  // Headers por defecto para todas las peticiones
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Realiza una petición POST a la API
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('🔵 POST Request to: $url');
      print('📤 Datos: $data');

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception(
                'Timeout: El servidor tardó demasiado en responder'),
          );

      print('🟢 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Errores de validación: ${errorData['errors'] ?? errorData['message'] ?? 'Error desconocido'}',
        );
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado: Credenciales inválidas');
      } else {
        throw Exception(
          'Error ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      print('🔴 Error de conexión: $e');
      throw Exception(
          'No se pudo conectar al servidor. ¿Está corriendo en localhost:8000?');
    } catch (e) {
      print('🔴 Error en POST: $e');
      rethrow;
    }
  }

  /// Realiza una petición GET a la API
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('🔵 GET Request to: $url');

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception(
                'Timeout: El servidor tardó demasiado en responder'),
          );

      print('🟢 Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado: Token inválido o expirado');
      } else {
        throw Exception(
          'Error ${response.statusCode}: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      print('🔴 Error de conexión: $e');
      throw Exception(
          'No se pudo conectar al servidor. ¿Está corriendo en localhost:8000?');
    } catch (e) {
      print('🔴 Error en GET: $e');
      rethrow;
    }
  }

  /// Realiza una petición PUT a la API
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('🔵 PUT Request to: $url');

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception(
                'Timeout: El servidor tardó demasiado en responder'),
          );

      print('🟢 Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (e) {
      print('🔴 Error de conexión: $e');
      throw Exception(
          'No se pudo conectar al servidor. ¿Está corriendo en localhost:8000?');
    } catch (e) {
      print('🔴 Error en PUT: $e');
      rethrow;
    }
  }

  /// Realiza una petición DELETE a la API
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('🔵 DELETE Request to: $url');

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception(
                'Timeout: El servidor tardó demasiado en responder'),
          );

      print('🟢 Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } on SocketException catch (e) {
      print('🔴 Error de conexión: $e');
      throw Exception(
          'No se pudo conectar al servidor. ¿Está corriendo en localhost:8000?');
    } catch (e) {
      print('🔴 Error en DELETE: $e');
      rethrow;
    }
  }
}
