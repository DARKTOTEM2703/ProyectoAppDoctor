import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:appdoctor/services/api_service.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({
    super.key,
    required this.userData,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    // Mostrar diálogo de confirmación
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.post('logout', {});

      if (response['success'] == true) {
        // Logout exitoso - volver a login
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sesión cerrada correctamente'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Error al cerrar sesión'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.colorprimario,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Config.colorprimario,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (widget.userData['name'] ?? 'Usuario')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Config.espacioPequeno,

              // Nombre
              Text(
                widget.userData['name'] ?? 'Usuario',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.espacioMediano,

              // Email
              Text(
                widget.userData['email'] ?? 'Sin email',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Config.espacioPequeno,

              // ID Usuario
              Text(
                'ID: ${widget.userData['id'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              Config.espacioGrande,

              // Sección de Información
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información de la Cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.espacioMediano,
                    _buildInfoRow('Nombre', widget.userData['name'] ?? 'N/A'),
                    _buildInfoRow('Email', widget.userData['email'] ?? 'N/A'),
                    _buildInfoRow('ID Usuario', widget.userData['id']?.toString() ?? 'N/A'),
                  ],
                ),
              ),
              Config.espacioGrande,

              // Botón de Cerrar Sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Cerrando sesión...' : 'Cerrar Sesión',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Config.espacioMediano,
      ],
    );
  }
}
