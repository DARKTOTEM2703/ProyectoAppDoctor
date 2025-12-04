import 'package:appdoctor/services/auth_service.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Formulariodeiniciodesecion extends StatefulWidget {
  final Function(Map<String, dynamic>) onLoginSuccess;

  const Formulariodeiniciodesecion({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<Formulariodeiniciodesecion> createState() =>
      _Estadodelosformulariosdeiniciodesesion();
}

class _Estadodelosformulariosdeiniciodesesion
    extends State<Formulariodeiniciodesecion> {
  final _llavedelformulario = GlobalKey<FormState>();
  final _controladordecorreo = TextEditingController();
  final _controladordecontrasena = TextEditingController();
  bool mostrarcontrasena = false;
  bool _isLoading = false;

  /// Validar email
  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Por favor ingresa un correo válido';
    }
    return null;
  }

  /// Validar contraseña
  String? _validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  /// Enviar formulario de login
  Future<void> _enviarLogin() async {
    if (!_llavedelformulario.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await AuthService.login(
        email: _controladordecorreo.text.trim(),
        password: _controladordecontrasena.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response['success'] ?? false) {
          // Login exitoso - guardar token
          final token = response['access_token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          // Llamar al callback de éxito
          widget.onLoginSuccess(response);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Login exitoso'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Error en login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Error en el login'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = 'Error de conexión';
        if (e.toString().contains('Connection refused')) {
          errorMessage =
              'No se pudo conectar al servidor. Verifica que el backend esté corriendo en localhost:8000';
        } else {
          errorMessage = 'Error: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _llavedelformulario,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Campo de email
          TextFormField(
            controller: _controladordecorreo,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.colorprimario,
            enabled: !_isLoading,
            validator: _validarEmail,
            decoration: InputDecoration(
              labelText: 'Correo',
              hintText: 'ejemplo@dominio.com',
              prefixIcon: const Icon(Icons.email),
            ),
          ),
          Config.espacioPequeno,

          // Campo de contraseña
          TextFormField(
            controller: _controladordecontrasena,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.colorprimario,
            obscureText: !mostrarcontrasena,
            enabled: !_isLoading,
            validator: _validarContrasena,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          mostrarcontrasena = !mostrarcontrasena;
                        });
                      },
                icon: Icon(
                  mostrarcontrasena ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),

          Config.espacioPequeno,

          // Botón de envío
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _enviarLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.colorprimario,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controladordecorreo.dispose();
    _controladordecontrasena.dispose();
    super.dispose();
  }
}
