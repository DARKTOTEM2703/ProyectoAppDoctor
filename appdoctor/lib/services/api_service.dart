import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';

/// Servicio centralizado para todas las peticiones HTTP a la API de Laravel
/// Usa la IP configurada en Config.dart (192.168.1.8:8000)
class ApiService {
  // Headers por defecto para todas las peticiones
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Realiza una petición POST a la API
  /// 
  /// [endpoint] - Ruta del endpoint (ej: 'login', 'register')
  /// [data] - Datos a enviar en el body
  /// Returns: Respuesta decodificada como Map
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('POST Request to: $url'); // Debug
      
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(data),
      );

      print('Response Status: ${response.statusCode}'); // Debug
      print('Response Body: ${response.body}'); // Debug

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error en la petición: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error en POST: $e'); // Debug
      rethrow;
    }
  }

  /// Realiza una petición GET a la API
  /// 
  /// [endpoint] - Ruta del endpoint
  /// [token] - Token de autenticación opcional (Sanctum)
  /// Returns: Respuesta decodificada como Map
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('GET Request to: $url'); // Debug

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Response Status: ${response.statusCode}'); // Debug

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error en la petición: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error en GET: $e'); // Debug
      rethrow;
    }
  }

  /// Realiza una petición PUT a la API
  /// 
  /// [endpoint] - Ruta del endpoint
  /// [data] - Datos a actualizar
  /// [token] - Token de autenticación opcional
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('PUT Request to: $url'); // Debug

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error en la petición: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error en PUT: $e'); // Debug
      rethrow;
    }
  }

  /// Realiza una petición DELETE a la API
  /// 
  /// [endpoint] - Ruta del endpoint
  /// [token] - Token de autenticación opcional
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final url = '${Config.fullApiUrl}/$endpoint';
      print('DELETE Request to: $url'); // Debug

      final headers = Map<String, String>.from(_headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Error en la petición: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error en DELETE: $e'); // Debug
      rethrow;
    }
  }
}
