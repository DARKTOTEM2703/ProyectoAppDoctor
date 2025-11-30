import 'package:flutter/material.dart';
import 'package:appdoctor/services/api_service.dart';
import 'package:appdoctor/utils/config.dart';

/// Widget de prueba para verificar la conexión con el backend Laravel
///
/// USO: Agrega este widget en cualquier pantalla para probar la conexión
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     // ... otros widgets
///     TestConnectionButton(),
///   ],
/// )
/// ```
class TestConnectionButton extends StatefulWidget {
  const TestConnectionButton({super.key});

  @override
  State<TestConnectionButton> createState() => _TestConnectionButtonState();
}

class _TestConnectionButtonState extends State<TestConnectionButton> {
  bool _isLoading = false;
  String _result = '';
  bool _hasError = false;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _result = '';
      _hasError = false;
    });

    try {
      final response = await ApiService.get('test');

      setState(() {
        _isLoading = false;
        _hasError = false;
        _result = '''
✅ ¡Conexión exitosa!

Mensaje: ${response['message']}
Hora del servidor: ${response['timestamp']}
IP del cliente: ${response['server_ip']}

URL usada: ${Config.fullApiUrl}/test
''';
      });

      // Muestra un SnackBar de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Conexión con Laravel exitosa!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _result = '''
❌ Error de conexión

Detalles: $e

Verificar:
1. Laravel está corriendo: php artisan serve --host 0.0.0.0
2. IP correcta en Config.dart: ${Config.apiBaseUrl}
3. Firewall permite puerto 8000
4. Ambos dispositivos en la misma red WiFi

URL intentada: ${Config.fullApiUrl}/test
''';
      });

      // Muestra un SnackBar de error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error al conectar con el servidor'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '🧪 Test de Conexión API',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Servidor: ${Config.apiBaseUrl}',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.wifi_find),
              label: Text(_isLoading ? 'Probando...' : 'Probar Conexión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.colorprimario,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            if (_result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _hasError
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _hasError ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: _hasError ? Colors.red.shade900 : Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
