import 'package:appdoctor/services/api_service.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

class FormularioDeRegistro extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegisterSuccess;

  const FormularioDeRegistro({
    super.key,
    required this.onRegisterSuccess,
  });

  @override
  State<FormularioDeRegistro> createState() => _FormularioDeRegistroState();
}

class _FormularioDeRegistroState extends State<FormularioDeRegistro> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Limpiar error previo
    setState(() => _errorMessage = null);

    // Validar campos
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Por favor completa todos los campos');
      return;
    }

    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden');
      return;
    }

    // Validar longitud de contraseña
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post('register', {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
      });

      if (response['success'] == true) {
        // Registro exitoso
        widget.onRegisterSuccess(response);
      } else {
        setState(() => _errorMessage = response['message'] ?? 'Error en el registro');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mostrar error si existe
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade400),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade900,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Campo de Nombre
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Nombre Completo',
            hintStyle: const TextStyle(color: Colors.grey),
            border: Config.bordeRedondeado,
            focusedBorder: Config.bordeEnfocado,
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
          ),
        ),
        Config.espacioPequeno,

        // Campo de Email
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Correo Electrónico',
            hintStyle: const TextStyle(color: Colors.grey),
            border: Config.bordeRedondeado,
            focusedBorder: Config.bordeEnfocado,
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
          ),
        ),
        Config.espacioPequeno,

        // Campo de Contraseña
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: const TextStyle(color: Colors.grey),
            border: Config.bordeRedondeado,
            focusedBorder: Config.bordeEnfocado,
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          ),
        ),
        Config.espacioPequeno,

        // Campo de Confirmar Contraseña
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            hintStyle: const TextStyle(color: Colors.grey),
            border: Config.bordeRedondeado,
            focusedBorder: Config.bordeEnfocado,
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          ),
        ),
        Config.espacioPequeno,

        // Botón de Registro
        ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: Config.colorprimario,
            disabledBackgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}
