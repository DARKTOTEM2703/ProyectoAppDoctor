import 'package:flutter/material.dart';
import 'package:appdoctor/services/api_service.dart';
import 'package:appdoctor/utils/config.dart';

/// Widget para probar la conexión con la API
/// Útil para debugging
class DebugConnectionWidget extends StatefulWidget {
  const DebugConnectionWidget({super.key});

  @override
  State<DebugConnectionWidget> createState() => _DebugConnectionWidgetState();
}

class _DebugConnectionWidgetState extends State<DebugConnectionWidget> {
  bool _isLoading = false;
  String? _status;
  Color? _statusColor;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Conectando a ${Config.fullApiUrl}...';
      _statusColor = Colors.orange;
    });

    try {
      final response = await ApiService.get('test');

      setState(() {
        _isLoading = false;
        _statusColor = Colors.green;
        _status = '''
✅ CONEXIÓN EXITOSA

URL: ${Config.fullApiUrl}
Status Code: 200
Mensaje: ${response['message'] ?? 'N/A'}
Timestamp: ${response['timestamp'] ?? 'N/A'}
        ''';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusColor = Colors.red;
        _status = '''
❌ ERROR DE CONEXIÓN

URL: ${Config.fullApiUrl}
Error: $e

SOLUCIÓN:
1. Verifica que Laravel esté corriendo en puerto 8000
2. Ejecuta: php artisan serve --host 127.0.0.1 --port 8000
3. Verifica que la URL sea correcta en config.dart
        ''';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🔧 Debug - Probar Conexión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.colorprimario,
                disabledBackgroundColor: Colors.grey,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text('Probar Conexión'),
            ),
            const SizedBox(height: 12),
            if (_status != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _statusColor?.withOpacity(0.1),
                  border: Border.all(color: _statusColor ?? Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _status!,
                  style: TextStyle(
                    color: _statusColor,
                    fontFamily: 'Courier',
                    fontSize: 12,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
