import 'dart:io';
import 'package:http/http.dart' as http;

/// Servicio para obtener la IP dinámicamente
class IpService {
  static String? _cachedIp;
  static DateTime? _lastCheckTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Detecta el servidor probando una lista de IPs comunes
  static Future<String> detectServerFromNetwork() async {
    try {
      print('🔵 IpService: Escaneando IPs comunes...');

      // IPs donde probablemente esté el servidor
      final ipsToTry = [
        '10.64.132.23', // Tu IP de PC
        '10.64.132.1', // Gateway
        '192.168.1.1', // Gateway común
        '192.168.0.1', // Gateway alternativo
        '10.0.2.2', // Emulador
        '127.0.0.1', // Localhost
      ];

      for (final ip in ipsToTry) {
        try {
          final response = await http
              .get(Uri.parse('http://$ip:8000/api/test'))
              .timeout(const Duration(milliseconds: 800));

          if (response.statusCode == 200) {
            print('🟢 IpService: ¡Servidor encontrado en: $ip!');
            return ip;
          }
        } catch (e) {
          print('🟡 IpService: No disponible en $ip');
        }
      }

      print('🟡 IpService: Servidor no encontrado');
      return 'localhost';
    } catch (e) {
      print('🔴 IpService: Error: $e');
      return 'localhost';
    }
  }

  /// Método principal para detectar la IP del servidor
  static Future<String> detectServerIp() async {
    try {
      // Usa IP cacheada si aún es válida
      if (_cachedIp != null && _lastCheckTime != null) {
        if (DateTime.now().difference(_lastCheckTime!).inSeconds < 300) {
          print('🔵 IpService: Usando IP cacheada: $_cachedIp');
          return _cachedIp!;
        }
      }

      // Detecta la IP
      final ip = await detectServerFromNetwork();
      _cachedIp = ip;
      _lastCheckTime = DateTime.now();

      print('🟢 IpService: IP configurada: $ip');
      return ip;
    } catch (e) {
      print('🔴 IpService: Error crítico: $e');
      return 'localhost';
    }
  }

  /// Limpia el cache
  static void clearCache() {
    _cachedIp = null;
    _lastCheckTime = null;
  }
}
